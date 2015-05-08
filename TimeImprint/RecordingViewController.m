//
//  RecordingViewController.m
//  TimeImprint
//
//  Created by Paul on 5/3/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "RecordingViewController.h"
#import "VideoEditViewController.h"
#import "VIdeoAssetsViewController.h"
#import "MainViewController.h"

#import "RecordingView.h"
#import "CameraEngine.h"

typedef NS_ENUM(NSInteger, kRecordButtonStatus) {
    kRecordButtonStatusNormal = 0,
    kRecordButtonStatusPause = 1,
    kRecordButtonStatusRecording = 2
};

static void * RecordingContext = &RecordingContext;

@interface RecordingViewController () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>

#pragma mark - Mask View Properties

@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (assign, nonatomic, getter = isExitRecording) BOOL exitRecording;

#pragma mark - Recording Controls Properties

@property (weak, nonatomic) IBOutlet UIView *recordingControls;
@property (weak, nonatomic) IBOutlet UIButton *flashlightButton;
@property (weak, nonatomic) IBOutlet UIButton *assetButton;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIImageView *assetButtonImage;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *recordCompleteButton;

#pragma mark - Video Recording's Properties

@property (weak, nonatomic) IBOutlet RecordingView *recordingView;

// Use this property for UI display temporary, we should use CameraEngine.isRecoding after the bug solved
//
@property (assign, nonatomic, getter=isRecording) BOOL recording;

@property (strong, nonatomic) NSTimer *countBackwardTimer;
@property (assign, nonatomic) NSTimeInterval countBackwardTime;
@property (weak, nonatomic) IBOutlet UILabel *countBackwardLabel;

// After the CameraEngine Fixed, we should use CameraEngine.videoTime for fetch the video's time
//
@property (strong, nonatomic) NSTimer *recordingTimer;
@property (assign, nonatomic) NSTimeInterval recordingTime;

@property (strong, nonatomic) CAShapeLayer *videoTimeLayer;

@end

@implementation RecordingViewController

#pragma mark - Controller's Life Circle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Configure video recording
    //
    [[CameraEngine shareEngine]configureEngineOnPosition:AVCaptureDevicePositionBack];
    
    _exitRecording = NO;
    ((MainViewController *)self.tabBarController).lockScreenRotation = NO;
    
    self.tabBarController.tabBar.hidden = YES;
    
    // Add observer for device rotation
    //
    [[UIDevice currentDevice]beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didOrientationChanged:)
                                                name:UIDeviceOrientationDidChangeNotification
                                              object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {

    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    _recordingControls.hidden = YES;
    _recordingView.hidden = YES;
    _maskView.hidden = NO;
    
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIDeviceOrientationDidChangeNotification
                                                 object:nil];
    
    // Just for UI, it should change image better
    //
    _recordButton.tag = kRecordButtonStatusNormal;
    
    _recording = NO;
    _assetButton.hidden = NO;
    _assetButtonImage.hidden = NO;
    _recordCompleteButton.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Timer Methods

- (void)configureBackwardTimer {
    
    _countBackwardTime = 3;
    _countBackwardLabel.hidden = NO;
    
    _countBackwardTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(handleBackwardTimer)
                                                         userInfo:nil repeats:YES];
    
}

- (void)handleBackwardTimer {
    
    if (self.countBackwardTime == 0) {
        
        [UIView animateWithDuration:0.0f
                         animations:^{
            
                              _countBackwardLabel.alpha = 0.0f;
                             
                         }
                         completion:^(BOOL finished) {
            
                             _countBackwardLabel.text = @"3";
                             _countBackwardLabel.hidden = YES;
                             
                             // Start the camera engine here
                             //
                             // ......
                             
                             // Just for UI, it should change image better
                             //
                             _recordButton.tag = kRecordButtonStatusRecording;
                             
                             _recording = YES;
                             _assetButton.hidden = YES;
                             _assetButtonImage.hidden = YES;
                             _recordCompleteButton.hidden = NO;
                             _recordCompleteButton.enabled = YES;
                             _exitButton.hidden = YES;
                             
                             // Ready to display the timer and the progress layer
                             //
                             [self configureVideoTimeLayer];
                             [self configureRecordingTimer];
                             
                         }];
    
        [_countBackwardTimer invalidate];
        
        return ;
        
    }
    
    [UIView animateWithDuration:0.0f
                     animations:^{
                         
                         _countBackwardLabel.text = [NSString stringWithFormat:@"%.0f", self.countBackwardTime];
                         
                     }];
    
    _countBackwardTime--;
    
    
}

- (void)configureRecordingTimer {
    
    _recordingTime = 0;
    
    _recordingTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                       target:self
                                                     selector:@selector(handleRecordingTimer)
                                                     userInfo:nil
                                                      repeats:YES];
    
}

- (void)handleRecordingTimer {
    
    if (self.recordingTime == 10.0f) {
        
        // End recording here
        // ...
        
        
        [_recordingTimer invalidate];
        
        return ;
    }
    
    if (self.recordingTime == 3.0f) {
        
    }
    
    _videoTimeLayer.strokeEnd = _recordingTime/10.0f;
    [_videoTimeLayer setNeedsDisplay];
    
    _recordingTime += 0.1f;
    
}

- (void)configureVideoTimeLayer {
    
    _videoTimeLayer = [CAShapeLayer layer];
    _videoTimeLayer.frame = CGRectMake(0, self.view.frame.size.height - 6,
                                       self.view.bounds.size.width, 6);
    _videoTimeLayer.backgroundColor = [UIColor whiteColor].CGColor;
    _videoTimeLayer.strokeColor = [UIColor redColor].CGColor;
    _videoTimeLayer.lineWidth = 6;
    _videoTimeLayer.strokeEnd = 0.0f;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.videoTimeLayer.frame.size.height/2)];
    [path addLineToPoint:CGPointMake(self.videoTimeLayer.frame.size.width, self.videoTimeLayer.frame.size.height/2)];
    
    _videoTimeLayer.path = path.CGPath;
    
    [_recordingView.layer addSublayer:self.videoTimeLayer];
    
}

#pragma mark - Interface Orientation Methods

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    _maskView.hidden = YES;
    
}

- (void)didOrientationChanged:(NSNotification *)notification {
    
    UIDevice *currentDevice = notification.object;
    
    if (currentDevice.orientation == UIDeviceOrientationLandscapeLeft || currentDevice.orientation == UIDeviceOrientationLandscapeRight) {
        _recordingView.hidden = NO;
        _recordingControls.hidden = NO;
        _maskView.hidden = YES;
        
        // Configure capture preview
        //
        _recordingView.captureSession = [CameraEngine shareEngine].captureSession;
        ((AVCaptureVideoPreviewLayer *)_recordingView.layer).connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        
        if (self.isExitRecording) {
            [self rotateDeviceOrientation:UIInterfaceOrientationPortrait];
        }
        
    }
    
    ((MainViewController *)self.tabBarController).lockScreenRotation = !self.isExitRecording;
    
}

- (void)rotateDeviceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    [[UIDevice currentDevice]setValue:@(interfaceOrientation) forKey:@"orientation"];
    [[UIApplication sharedApplication]setStatusBarOrientation:interfaceOrientation];
    
}

- (NSUInteger)supportedInterfaceOrientations {

    return UIInterfaceOrientationLandscapeRight;
    
}

#pragma mark - Video Recording Methods

- (void)configureRecordingProcessor {
    
    
    
}

- (void)configureDeviceFlashMode:(AVCaptureFlashMode)flashMode
                forCaptureDevice:(AVCaptureDevice *)captureDevice {
    
    if ([captureDevice hasFlash] && [captureDevice isFlashModeSupported:flashMode]) {
        if ([captureDevice lockForConfiguration:nil]) {
            captureDevice.flashMode = flashMode;
            [captureDevice unlockForConfiguration];
        }
    }
    
}

- (AVCaptureDevice *)captureDeviceWithMediaType:(NSString *)mediaType
                             preferringPosition:(AVCaptureDevicePosition)devicePosition {
    
    NSArray *captureDevices = [AVCaptureDevice devicesWithMediaType:mediaType];

    for (AVCaptureDevice *device in captureDevices) {
        
        if (device.position == devicePosition) {
            return device;
        }
        
    }
    
    NSLog(@"No vvalid device for recording");
    
    return nil;
}

#pragma mark - Control's Action

- (IBAction)closeButtonTouchUpInside:(id)sender {
    
    // Use this special flag to handle the fucking tabBarController rotation
    //
    _exitRecording = YES;
    _maskView.hidden = NO;
        
    [[CameraEngine shareEngine]shutdownEngine];
    
    ((MainViewController *)self.tabBarController).lockScreenRotation = NO;
    
    
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        [self rotateDeviceOrientation:UIInterfaceOrientationLandscapeRight];
    }
    else {
        [self rotateDeviceOrientation:UIInterfaceOrientationPortrait];
    }

    self.tabBarController.tabBar.hidden = NO;
    [self.tabBarController setSelectedIndex:0];
    
}

- (IBAction)switchCaptureDevicePostionButtonTouchUpInside:(id)sender {
    
    /*
    dispatch_async(self.captureSessionQueue, ^{
        
        // Congfigure the prefer device position
        //
        AVCaptureDevice *currentDevice = self.captureDeviceInput.device;
        AVCaptureDevicePosition preferCaptureDevicePosition = AVCaptureDevicePositionUnspecified;
        
        if (currentDevice.position == AVCaptureDevicePositionBack) {
            preferCaptureDevicePosition = AVCaptureDevicePositionFront;
            
            // If the prefer device position is front camera, disable the flash button
            //
            dispatch_async(dispatch_get_main_queue(), ^{
               _flashlightButton.hidden = YES;
            });
            
        }
        else {

            
            // If the prefer device position is back camera, enable the flash button
            //
            dispatch_async(dispatch_get_main_queue(), ^{
                _flashlightButton.hidden = NO;
            });
            
        }
        
        // Configure prefer device
        //
        AVCaptureDevice *preferCaptureDevice = [self captureDeviceWithMediaType:AVMediaTypeVideo preferringPosition:preferCaptureDevicePosition];
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
        
    });
    */
}

- (IBAction)flashLightButtonTouchUpInside:(id)sender {

    
}

- (IBAction)recordingControlButtonTouchUpInside:(id)sender {

    UIButton *button = (UIButton *)sender;
    
    if (button.tag == kRecordButtonStatusNormal) {
        
        [self configureBackwardTimer];
        
    }
    else if (button.tag == kRecordButtonStatusRecording){
        [[CameraEngine shareEngine] pauseRecording];
        button.tag = kRecordButtonStatusPause;
    }
    else {
        [[CameraEngine shareEngine]resumeRecording];
        button.tag = kRecordButtonStatusRecording;
    }
    
}

- (IBAction)assetButtonTouchUpInside:(id)sender {
    
    [[CameraEngine shareEngine]endRecording];
    
}

- (IBAction)recordingCompleteButtonTouchUpInside:(id)sender {

    

}

@end
