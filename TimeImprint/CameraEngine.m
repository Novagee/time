//
//  CameraEngine.m
//  Encoder Demo
//
//  Created by Geraint Davies on 19/02/2013.
//  Copyright (c) 2013 GDCL http://www.gdcl.co.uk/license.htm
//

#import "CameraEngine.h"
#import "VideoEncoder.h"

static CameraEngine* theEngine;

@interface CameraEngine  () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic) dispatch_queue_t captureSessionQueue;

@property (strong, nonatomic) AVCaptureConnection *videoCaptureConnection;
@property (strong, nonatomic) AVCaptureConnection *audioCaptureConnection;
@property (strong, nonatomic) AVCaptureDeviceInput *captureDeviceInput;

@property (strong, nonatomic) VideoEncoder *videoEncoder;

@property (assign, nonatomic) NSInteger videoWidth;
@property (assign, nonatomic) NSInteger videoHeight;
@property (assign, nonatomic) int channels;
@property (assign, nonatomic) Float64 sampleRate;

@property (assign, nonatomic) NSInteger videoSegmentCount;
@property (assign, nonatomic) CMTime timeOffset;
@property (assign, nonatomic) CMTime videoTime;
@property (assign, nonatomic) CMTime audioTime;
@property (assign, nonatomic) BOOL discontinuity;

@property (assign, nonatomic) NSInteger previousSecond;

@end

@implementation CameraEngine

+ (instancetype)shareEngine {
    
    static CameraEngine *cameraEngine = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cameraEngine = [[self alloc]init];
    });
    
    return cameraEngine;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
    }
    return self;
}

- (AVCaptureDevice *)captureDeviceWithMediaType:(NSString *)mediaType
                             preferringPosition:(AVCaptureDevicePosition)devicePosition {
    
    NSArray *captureDevices = [AVCaptureDevice devicesWithMediaType:mediaType];
    
    for (AVCaptureDevice *device in captureDevices) {
        
        if (device.position == devicePosition) {
            return device;
        }
        
    }
    
    NSLog(@"No valid device for recording");
    
    return nil;
}

- (void)configureEngineOnPosition:(AVCaptureDevicePosition)captureDevicePosition
{
   
    // Configure local property
    //
    _captureDevicePosition = captureDevicePosition;
    
    // Initialization
    //
    _captureSession = [[AVCaptureSession alloc]init];
    _captureSessionQueue = dispatch_queue_create("captureSessionQueue", DISPATCH_QUEUE_SERIAL);
    
    _videoSegmentCount = 0;
    
    // Configure the video device with a back position camera
    //
    AVCaptureDevice *videoDevice = [self captureDeviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
    
    // Cofigure the camera capture input
    //
    NSError *errorForVideoDevice = nil;
    
    _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&errorForVideoDevice];
    
    if ([self.captureSession canAddInput:self.captureDeviceInput]) {
        
        [_captureSession addInput:self.captureDeviceInput];
        
    }
    
    // Configure the audio capture input
    //
    NSError *errorForAudioDevice = nil;
    
    AVCaptureDevice *audioDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio].firstObject;
    AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&errorForAudioDevice];
    
    if ([self.captureSession canAddInput:audioDeviceInput]) {
        [_captureSession addInput:audioDeviceInput];
    }
    
    // Configure the video output
    //
    AVCaptureVideoDataOutput *captureVideoDataOutput = [[AVCaptureVideoDataOutput alloc]init];
    [captureVideoDataOutput setSampleBufferDelegate:self queue:self.captureSessionQueue];
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey,
                                   nil];
    captureVideoDataOutput.videoSettings = videoSettings;
    
    if ([self.captureSession canAddOutput:captureVideoDataOutput]) {
        [_captureSession addOutput:captureVideoDataOutput];
    }
    
    // Configure the video output connection
    //
    _videoCaptureConnection = [captureVideoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    
    NSDictionary *actuallySetting = captureVideoDataOutput.videoSettings;
    _videoHeight = [[actuallySetting objectForKey:@"Height"] integerValue];
    _videoWidth = [[actuallySetting objectForKey:@"Width"] integerValue];
    
    // Confgireu the audio output
    //
    AVCaptureAudioDataOutput *captureAudioDataOutput = [[AVCaptureAudioDataOutput alloc]init];
    [captureVideoDataOutput setSampleBufferDelegate:self queue:self.captureSessionQueue];
    
    if ([self.captureSession canAddOutput:captureAudioDataOutput]) {
        [self.captureSession addOutput:captureAudioDataOutput];
    }
    
    // Configure the audio connection
    //
    _audioCaptureConnection = [captureAudioDataOutput connectionWithMediaType:AVMediaTypeAudio];
    
    //Configure preview layer
    //
    [_captureSession startRunning];
    

}

- (void) startRecording
{
    @synchronized(self)
    {
        if (!self.isRecording)
        {
            NSLog(@"Start Recording ...");
            
            _videoEncoder = nil;
            _isPaused = NO;
            _discontinuity = NO;
            _timeOffset = CMTimeMake(0, 0);
            _isRecording = YES;
            
            _previousSecond = 0;
        }
    }
}

- (void) endRecording
{
    @synchronized(self)
    {
        if (self.isRecording)
        {
            NSString* filename = [NSString stringWithFormat:@"capture%ld.mp4", _videoSegmentCount];
            NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
            NSURL* url = [NSURL fileURLWithPath:path];
            
            _videoSegmentCount++;
            
            // serialize with audio and video capture
            //
            self.isRecording = NO;
            
            dispatch_async(_captureSessionQueue, ^{
                [_videoEncoder finishWithCompletionHandler:^{
                    self.isRecording = NO;
                    _videoEncoder = nil;
                    
                    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                    [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error){
                        NSLog(@"End Recording ...");
                        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                    }];
                    
                }];
            });
        }
        
        _recordingTime = 0;
        
    }
}

- (void) pauseRecording
{
    @synchronized(self)
    {
        if (self.isRecording)
        {
            NSLog(@"Pause Recording ...");
            
            _isPaused = YES;
            _discontinuity = YES;
        }
    }
}

- (void) resumeRecording
{
    @synchronized(self)
    {
        if (self.isPaused)
        {
            NSLog(@"Resume Recording ...");
            
            _isPaused = NO;
        }
    }
}

- (CMSampleBufferRef)adjustTime:(CMSampleBufferRef)sample by:(CMTime)offset
{
    CMItemCount count;
    CMSampleBufferGetSampleTimingInfoArray(sample, 0, nil, &count);
    CMSampleTimingInfo* pInfo = malloc(sizeof(CMSampleTimingInfo) * count);
    CMSampleBufferGetSampleTimingInfoArray(sample, count, pInfo, &count);
    for (CMItemCount i = 0; i < count; i++)
    {
        pInfo[i].decodeTimeStamp = CMTimeSubtract(pInfo[i].decodeTimeStamp, offset);
        pInfo[i].presentationTimeStamp = CMTimeSubtract(pInfo[i].presentationTimeStamp, offset);
    }
    CMSampleBufferRef sout;
    CMSampleBufferCreateCopyWithNewTiming(nil, sample, count, pInfo, &sout);
    free(pInfo);
    return sout;
}

- (void)setAudioFormat:(CMFormatDescriptionRef)formatDescription
{
    const AudioStreamBasicDescription *asbd = CMAudioFormatDescriptionGetStreamBasicDescription(formatDescription);
    _sampleRate = asbd->mSampleRate;
    _channels = asbd->mChannelsPerFrame;
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    BOOL ishandleVideoStuff = YES;
    
    @synchronized(self)
    {
        if (!self.isRecording  || self.isPaused)
        {
            return;
        }
        if (connection != _videoCaptureConnection)
        {
            ishandleVideoStuff = NO;
        }
        if ((_videoEncoder == nil) && !ishandleVideoStuff)
        {
            CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
            [self setAudioFormat:formatDescription];
            
            NSString* filename = [NSString stringWithFormat:@"capture%ld.mp4", _videoSegmentCount];
            NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
            
            _videoEncoder = [VideoEncoder encoderForPath:path withHeight:(int)_videoHeight andWidth:(int)_videoWidth withChannels:_channels andSamples:_sampleRate];
        }
        if (_discontinuity)
        {
            if (ishandleVideoStuff)
            {
                return;
            }
            _discontinuity = NO;
            
            // calc adjustment
            //
            CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
            CMTime last = ishandleVideoStuff ? _videoTime : _audioTime;
            if (last.flags & kCMTimeFlags_Valid)
            {
                if (_timeOffset.flags & kCMTimeFlags_Valid)
                {
                    pts = CMTimeSubtract(pts, _timeOffset);
                }
                CMTime offset = CMTimeSubtract(pts, last);
                NSLog(@"Setting offset from %s", ishandleVideoStuff?"video": "audio");
                NSLog(@"Adding %f to %f (pts %f)", ((double)offset.value)/offset.timescale, ((double)_timeOffset.value)/_timeOffset.timescale, ((double)pts.value/pts.timescale));
                
                // this stops us having to set a scale for _timeOffset before we see the first video time
                if (_timeOffset.value == 0)
                {
                    _timeOffset = offset;
                }
                else
                {
                    _timeOffset = CMTimeAdd(_timeOffset, offset);
                }
            }
            _videoTime.flags = 0;
            _audioTime.flags = 0;
        }
        
        // retain so that we can release either this or modified one
        CFRetain(sampleBuffer);
        
        if (_timeOffset.value > 0)
        {
            CFRelease(sampleBuffer);
            sampleBuffer = [self adjustTime:sampleBuffer by:_timeOffset];
        }
        
        // record most recent time so we know the length of the pause
        CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        CMTime dur = CMSampleBufferGetDuration(sampleBuffer);
        if (dur.value > 0)
        {
            pts = CMTimeAdd(pts, dur);
        }
        
        if (ishandleVideoStuff)
        {
            _videoTime = pts;
            
            if (_previousSecond == 0) {
                _previousSecond = (NSInteger)floor((int)CMTimeGetSeconds(self.videoTime)%60);
            }
            if ((NSInteger)floor((int)CMTimeGetSeconds(self.videoTime)%60) - self.previousSecond == 1) {
                _previousSecond = (NSInteger)floor((int)CMTimeGetSeconds(self.videoTime)%60);
                _recordingTime++;
            }
            
        }
        else
        {
            _audioTime = pts;
        }
        
        
    }

    // pass frame to encoder
    //
    [_videoEncoder encodeFrame:sampleBuffer isVideo:ishandleVideoStuff];
    CFRelease(sampleBuffer);
}

- (void) shutdownEngine
{
    NSLog(@"Shutdown Engine");
    if (_captureSession)
    {
        [_captureSession stopRunning];

    }
    [_videoEncoder finishWithCompletionHandler:^{
        NSLog(@"Recording Completed");
    }];
}

- (void)changeCaptureDevicePosition {
    
    
     dispatch_async(self.captureSessionQueue, ^{
     
     
     });
    
    // Congfigure the prefer device position
    //
    AVCaptureDevice *currentDevice = self.captureDeviceInput.device;
    _captureDevicePosition = AVCaptureDevicePositionUnspecified;
    
    if (currentDevice.position == AVCaptureDevicePositionBack) {
        
        _captureDevicePosition = AVCaptureDevicePositionFront;
        
    }
    else {
        
        _captureDevicePosition = AVCaptureDevicePositionBack;
        
    }
    
    // Configure prefer device
    //
    AVCaptureDevice *preferCaptureDevice = [self captureDeviceWithMediaType:AVMediaTypeVideo
                                                         preferringPosition:self.captureDevicePosition];
    
    AVCaptureDeviceInput *preferCaptureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:preferCaptureDevice error:nil];
    
    // Begin configure captureSession
    //
    [self.captureSession beginConfiguration];
    
    // Remove previous captureDeviceInput
    //
    [self.captureSession removeInput:self.captureDeviceInput];
    
    if ([self.captureSession canAddInput:preferCaptureDeviceInput]) {
        
        [self.captureSession addInput:preferCaptureDeviceInput];
        [self setCaptureDeviceInput:preferCaptureDeviceInput];
        
    }
    
    // End configure captureSession
    //
    [self.captureSession commitConfiguration];
    
}

@end
