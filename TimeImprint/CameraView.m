//
//  CameraView.m
//  documentary-video-ios-native
//
//  Created by Bibo on 3/29/15.
//  Copyright (c) 2015 Bibo. All rights reserved.
//

#import "CameraView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CameraViewController.h"


@implementation CameraView

@synthesize closeBtn;
@synthesize frontOrBackBtn;
@synthesize flashBtn;
@synthesize recordBtn;
@synthesize movieFile;
@synthesize movieWriter;
@synthesize filter;
@synthesize timer;
@synthesize gpuImage;

+ (CameraView *)shared {
    static CameraView *shared;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ shared = [[[self class] alloc] init]; });
    return shared;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addNotifications];
        [self initiateCamera];
    }
    return self;
}

-(void)addNotifications {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(camRollThumbNailReady) name:@"camRollThumbNailReady" object:nil];
}

-(void)initiateCamera {
    
    videoFinished = NO;
    recordingStarted = NO;
    
    viewHeight = self.frame.size.height;
    
    [_videoProgressView removeFromSuperview];
    [_previewView removeFromSuperview];
    
    _videoProgressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    _videoProgressView.backgroundColor = [UIColor redColor];
    [self addSubview:_videoProgressView];

    _previewView = [[UIView alloc] initWithFrame:CGRectZero];
    _previewView.backgroundColor = [UIColor blackColor];
    CGRect previewFrame = CGRectMake(5, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    _previewView.frame = previewFrame;
    [self addSubview:_previewView];
    
    _previewLayer = [[PBJVision sharedInstance] previewLayer];
    _previewLayer.frame = _previewView.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_previewView.layer addSublayer:_previewLayer];
    
    [self addCameraOverLays];
    
    PBJVision *vision = [PBJVision sharedInstance];
    vision.delegate = self;
    vision.cameraMode = PBJCameraModeVideo;
    vision.cameraOrientation = PBJCameraOrientationPortrait;
    vision.focusMode = PBJFocusModeAutoFocus;
    vision.outputFormat = PBJOutputFormatPreset;
    
    [vision startPreview];
    
    [[PBJVision sharedInstance] setMaximumCaptureDuration:CMTimeMakeWithSeconds(20, 600)];
}

-(void)startThreeCountDown {
    UIView *countDownBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    countDownBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self addSubview:countDownBackground];
    
    UILabel *countDownLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-100, self.frame.size.height/2-100, 200, 200)];
    countDownLabel.text = @"3";
    countDownLabel.font = [UIFont fontWithName:@"American Typewriter" size:130];
    countDownLabel.textColor = [UIColor whiteColor];
    countDownLabel.textAlignment = NSTextAlignmentCenter;
    [countDownBackground addSubview:countDownLabel];
    countDownLabel.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
    
    [UIView animateWithDuration:1 animations:^{
        self.alpha = 0.99;
    } completion:^(BOOL finished) {
        countDownLabel.text = @"2";
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            countDownLabel.text = @"1";
            [UIView animateWithDuration:1 animations:^{
                self.alpha = 0.99;
            } completion:^(BOOL finished) {
                [countDownBackground removeFromSuperview];
                [[PBJVision sharedInstance] startVideoCapture];
                [self increaseProgressView];
            }];
        }];
    }];
}

-(void)addCameraOverLays {
    
    [closeBtn removeFromSuperview];
    [frontOrBackBtn removeFromSuperview];
    [flashBtn removeFromSuperview];
    [btnOverView removeFromSuperview];
    

    
    frontOrBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    frontOrBackBtn.frame = CGRectMake(self.frame.size.width/2+40, 20, 50, 50);
    [frontOrBackBtn setImage:[UIImage imageNamed:@"switchCam.png"] forState:UIControlStateNormal];
    [self addSubview:frontOrBackBtn];
    
    frontOrBackBtn.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
    
    [frontOrBackBtn addTarget:self action:@selector(rotateGPUCamera) forControlEvents:UIControlEventTouchUpInside];
    
    flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    flashBtn.frame = CGRectMake(self.frame.size.width/2-90, 20, 50, 50);
    [flashBtn setImage:[UIImage imageNamed:@"flash.png"] forState:UIControlStateNormal];
    [self addSubview:flashBtn];
    
    flashBtn.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
    
    [flashBtn addTarget:self action:@selector(flashBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    btnOverView = [[UIView alloc]initWithFrame:CGRectMake(5, self.frame.size.height-80, self.frame.size.width, 80)];
    btnOverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self addSubview:btnOverView];
    
    timerLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 30, 40, 20)];
    timerLabel.text = @"0秒";
    timerLabel.textAlignment = NSTextAlignmentCenter;
    timerLabel.textColor = [UIColor whiteColor];
    timerLabel.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
    [btnOverView addSubview:timerLabel];
    
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(50, btnOverView.frame.size.height/2-25, 50, 50);
    [closeBtn setImage:[UIImage imageNamed:@"videoExit"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [btnOverView addSubview:closeBtn];
    
    openCameraRollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openCameraRollBtn.frame = CGRectMake(btnOverView.frame.size.width-80, btnOverView.frame.size.height/2-25, 50, 50);
    openCameraRollBtn.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
    [openCameraRollBtn addTarget:self action:@selector(openCameraRoll) forControlEvents:UIControlEventTouchUpInside];
    [btnOverView addSubview:openCameraRollBtn];
    
    recordBackground = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    recordBackground.frame = CGRectMake(btnOverView.frame.size.width/2-30, btnOverView.frame.size.height/2-30, 60, 60);
    recordBackground.layer.cornerRadius = 30;
    recordBackground.backgroundColor = [UIColor clearColor];
    recordBackground.layer.borderColor = [UIColor whiteColor].CGColor;
    recordBackground.layer.borderWidth = 4;
    [btnOverView addSubview:recordBackground];
    
    recordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    recordBtn.frame = CGRectMake(8, 8, 44, 44);
    recordBtn.layer.cornerRadius = 22;
    recordBtn.backgroundColor = [UIColor redColor];
    [recordBackground addSubview:recordBtn];
    
    [recordBtn addTarget:self action:@selector(recordBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.playBtnBackground = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-25+5, self.frame.size.height-40-25-80, 50, 50)];
    self.playBtnBackground.backgroundColor = [UIColor clearColor];
//    self.playBtnBackground.layer.cornerRadius = 30;
//    self.playBtnBackground.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.playBtnBackground.layer.borderWidth = 4;
    [self addSubview:self.playBtnBackground];
    
    self.playBtnBackground.hidden = YES;
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake(0, 0, 50, 50);
    [self.playBtn setImage:[UIImage imageNamed:@"play@2x.png"] forState:UIControlStateNormal];
    [self.playBtnBackground addSubview:self.playBtn];
    self.playBtn.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
    [self.playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    
    self.recordingIsOkayBtnBackground = [[UIView alloc]initWithFrame:CGRectMake(btnOverView.frame.size.width-100, btnOverView.frame.size.height/2-25, 50, 50)];
    self.recordingIsOkayBtnBackground.backgroundColor = [UIColor clearColor];
//    self.recordingIsOkayBtnBackground.layer.cornerRadius = 30;
//    self.recordingIsOkayBtnBackground.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.recordingIsOkayBtnBackground.layer.borderWidth = 4;
    [btnOverView addSubview:self.recordingIsOkayBtnBackground];
    
    self.recordingIsOkayBtnBackground.hidden = YES;
    
    self.recordingIsOkayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordingIsOkayBtn.frame = CGRectMake(0, 0, 50, 50);
    [self.recordingIsOkayBtn setImage:[UIImage imageNamed:@"videoReady_42"] forState:UIControlStateNormal];
    self.recordingIsOkayBtn.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
    [self.recordingIsOkayBtnBackground addSubview:self.recordingIsOkayBtn];
    
    [self.recordingIsOkayBtn addTarget:self action:@selector(recordingIsOkayBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self getLastImage];
}

-(void)openCameraRoll {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"openCameraRoll" object:nil];
}

-(void)getLastImage {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // Chooses the photo at the last index
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            
            // The end of the enumeration is signaled by asset == nil.
            if (alAsset) {
                ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                
                [openCameraRollBtn setImage:latestPhoto forState:UIControlStateNormal];
                
                // Stop the enumerations
                *stop = YES; *innerStop = YES;
                
                
            }
        }];
    } failureBlock: ^(NSError *error) {
        // Typically you should handle an error more gracefully than this.
        NSLog(@"No groups");
    }];
}

-(void)recordBtnPressed:(UIButton *)btn {
    
    if (btn.layer.cornerRadius == 22) {
        
        [UIView animateWithDuration:0.1 animations:^{
            btn.frame = CGRectMake(15, 15, 30, 30);
            
        } completion:^(BOOL finished) {
            btn.layer.cornerRadius = 2;
            
            if (videoFinished == YES) {
                NSLog(@"starting over");
                [self initiateCamera];
                
                [self startOverRecording];
            }
            else {
            if (recordingStarted == NO) {
                recordingStarted = YES;
                videoFinished = NO;
                self.playBtnBackground.hidden = YES;
                self.recordingIsOkayBtnBackground.hidden = YES;
                openCameraRollBtn.hidden = YES;
                
                [self startThreeCountDown];
            }
            else {
                [[PBJVision sharedInstance] resumeVideoCapture];
                [self increaseProgressView];
            }
            
            }
            
            closeBtn.hidden = YES;
            flashBtn.hidden = YES;
            frontOrBackBtn.hidden = YES;
        }];
    }
    else {
        
        [self pauseProgressView];
        closeBtn.hidden = NO;
        flashBtn.hidden = NO;
        frontOrBackBtn.hidden = NO;
        
        btn.layer.cornerRadius = 22;
        
        [UIView animateWithDuration:0.1 animations:^{
            btn.frame = CGRectMake(8, 8, 44, 44);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)startOverRecording {
    
    [self startThreeCountDown];
    
    recordingStarted = NO;
    videoFinished = NO;
    
    self.playBtnBackground.hidden = YES;
    self.recordingIsOkayBtnBackground.hidden = YES;
    [screenShotImageView removeFromSuperview];
    _videoProgressView.frame = CGRectMake(0, 0, 5, 0);
    
    
    
    self.recordBtn.frame = CGRectMake(15, 15, 30, 30);
    self.recordBtn.layer.cornerRadius = 2;
    openCameraRollBtn.hidden = YES;
    
}

-(void)increaseProgressView {
    
    CGFloat currentProgress = _videoProgressView.frame.size.height;
    CGFloat labelProgress = currentProgress/self.frame.size.height*11;
    if ((int)labelProgress<10) {
        timerLabel.text = [NSString stringWithFormat:@"%i秒", (int)labelProgress];
    }
    else {
        timerLabel.text = [NSString stringWithFormat:@"%i秒", (int)labelProgress];
    }
    
    
    [self performSelector:@selector(increaseProgressView) withObject:nil afterDelay:0.1];
    
    [UIView animateWithDuration:1 animations:^{
        _videoProgressView.frame = CGRectMake(0, 0, 5, currentProgress+5);
    } completion:^(BOOL finished) {
        if (videoFinished == NO && _videoProgressView.frame.size.height >= viewHeight) {
            [self endRecording];
            
        }
    }];
}

-(void)camRollThumbNailReady {
    
    closeBtn.hidden = NO;
    flashBtn.hidden = YES;
    frontOrBackBtn.hidden = YES;
    
    recordBtn.layer.cornerRadius = 22;
    
    self.playBtnBackground.hidden = NO;
    self.recordingIsOkayBtnBackground.hidden = NO;
    
    [UIView animateWithDuration:0.1 animations:^{
        recordBtn.frame = CGRectMake(8, 8, 44, 44);
        
    } completion:^(BOOL finished) {
        
    }];
    
    videoFinished = YES;
    [CATransaction begin];
    [_videoProgressView.layer removeAllAnimations];
    [CATransaction commit];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(increaseProgressView) object:nil];
    
    UIImage *unRotatedImage = [CameraView shared].camRollThumbNail;
//    UIImage *rotatedImage = [[UIImage alloc]initWithCGImage:unRotatedImage.CGImage scale:1.0 orientation:UIImageOrientationRight];
    
//    UIImage * LandscapeImage = [UIImage imageNamed: imgname];
//    UIImage * PortraitImage = [[UIImage alloc] initWithCGImage: LandscapeImage.CGImage
//                                                         scale: 1.0
//                                                   orientation: UIImageOrientationLeft];
    
    screenShotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, self.frame.size.width, self.frame.size.height)];
    screenShotImageView.image = unRotatedImage;
    screenShotImageView.backgroundColor = [UIColor greenColor];
    [self addSubview:screenShotImageView];
    
    [self bringSubviewToFront:btnOverView];
    [self bringSubviewToFront:closeBtn];
    [self bringSubviewToFront:flashBtn];
    [self bringSubviewToFront:frontOrBackBtn];
    
    [self addFilterView];
}

-(void)endRecording {
    [SVProgressHUD showWithStatus:@"处理中"];
    closeBtn.hidden = NO;
    flashBtn.hidden = YES;
    frontOrBackBtn.hidden = YES;
    openCameraRollBtn.hidden = YES;
    
    recordBtn.layer.cornerRadius = 22;
    
    self.playBtnBackground.hidden = NO;
    self.recordingIsOkayBtnBackground.hidden = NO;
    
    [UIView animateWithDuration:0.1 animations:^{
        recordBtn.frame = CGRectMake(8, 8, 44, 44);
        
    } completion:^(BOOL finished) {
        
    }];
    
    videoFinished = YES;
    [[PBJVision sharedInstance] endVideoCapture];
    [CATransaction begin];
    [_videoProgressView.layer removeAllAnimations];
    [CATransaction commit];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(increaseProgressView) object:nil];
}

-(void)showScreenShot {
    screenShotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, self.frame.size.width, self.frame.size.height)];
    screenShotImageView.image = screenShotImage;
    screenShotImageView.backgroundColor = [UIColor greenColor];
    [self addSubview:screenShotImageView];
    
    [CameraView shared].camRollThumbNail = screenShotImage;
    
    [self bringSubviewToFront:btnOverView];
    [self bringSubviewToFront:closeBtn];
    [self bringSubviewToFront:flashBtn];
    [self bringSubviewToFront:frontOrBackBtn];
    [self bringSubviewToFront:self.playBtnBackground];
}

-(void)pauseProgressView {

    [CATransaction begin];
    [_videoProgressView.layer removeAllAnimations];
    [CATransaction commit];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(increaseProgressView) object:nil];
    
    [[PBJVision sharedInstance] pauseVideoCapture];
}

- (void)vision:(PBJVision *)vision capturedVideo:(NSDictionary *)videoDict error:(NSError *)error
{
    if (error && [error.domain isEqual:PBJVisionErrorDomain] && error.code == PBJVisionErrorCancelled) {
        NSLog(@"recording session cancelled");
        return;
    } else if (error) {
        NSLog(@"encounted an error in video capture (%@)", error);
        return;
    }
    
    NSDictionary *_currentVideo = videoDict;
    NSLog(@"_currentVideo %@", _currentVideo);
    
    screenShotImage = [[UIImage alloc]init];
    screenShotImage = [_currentVideo objectForKey:@"PBJVisionVideoThumbnailKey"];
    
    [self showScreenShot];
    
    [SVProgressHUD dismiss];
    
    NSString *videoPath = [_currentVideo  objectForKey:PBJVisionVideoPathKey];
    
    
    
    [self saveToPhoneAlbumWithPath:videoPath];
}



-(void)changePlayURL {
    videoURL = [CameraView shared].camRollURL;
    
    NSLog(@"%@ %@", videoURL, [CameraView shared].camRollURL);
}

-(void)saveToPhoneAlbumWithPath:(NSString *)videoPath {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:videoPath] completionBlock:^(NSURL *assetURL, NSError *error)
     {
         
         [CameraView shared].camRollURL = assetURL;
         
         if(error)
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil];
             [alertView show];
         }
         else
         {
             [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                 
             } failureBlock:^(NSError *error) {
                 
             }];
         }
     }];
}

-(void)playVideo {
    NSLog(@"playVideo %@", videoURL);
    
    AVAsset *avAsset;
    avAsset = [AVAsset assetWithURL:[CameraView shared].camRollURL];
    AVPlayerItem * avPlayerItem = [[AVPlayerItem alloc]initWithAsset:avAsset];
    avPlayer = [AVPlayer playerWithPlayerItem:avPlayerItem];
    avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    avPlayer.volume = 1.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                      selector:@selector(playerItemDidReachEnd:)
                                                          name:AVPlayerItemDidPlayToEndTimeNotification
                                                        object:[avPlayer currentItem]];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appCameFromBackground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
    avPlayerLayer.videoGravity = AVLayerVideoGravityResize;
    [avPlayerLayer setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.layer addSublayer:avPlayerLayer];
    avPlayer.rate = 0.3f;
    
    [avPlayer seekToTime:kCMTimeZero];
    
    [avPlayer play];
    
    self.removePlayerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.removePlayerBtn.frame = CGRectMake(self.frame.size.width/2-25+5, self.frame.size.height-40-25-80, 50, 50);
    [self.removePlayerBtn setImage:[UIImage imageNamed:@"videoExit"] forState:UIControlStateNormal];
//    self.removePlayerBtn.tintColor = [UIColor whiteColor];
//    self.removePlayerBtn.titleLabel.font = [UIFont systemFontOfSize:26 weight:0.6];
//    self.removePlayerBtn.layer.cornerRadius = 30;
//    self.removePlayerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.removePlayerBtn.layer.borderWidth = 4;
    [self.removePlayerBtn addTarget:self action:@selector(removePlayBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.removePlayerBtn];
    
    self.removePlayerBtn.transform = CGAffineTransformMakeRotation((270.0f * M_PI) / 180.0f);
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    NSLog(@"video reached an end");
//    AVPlayerItem *p = [notification object];
//    [p seekToTime:kCMTimeZero];
    
    [self.removePlayerBtn removeFromSuperview];
    [avPlayerLayer removeFromSuperlayer];
}

- (void)removePlayBtnPressed {
    
    [avPlayer pause];
    
    [self.removePlayerBtn removeFromSuperview];
    [avPlayerLayer removeFromSuperlayer];
}

-(void)recordingIsOkayBtnPressed {

    [self addFilterView];
}

-(void)addFilterView {
    
    recordBackground.hidden = YES;
    self.playBtnBackground.hidden = YES;
    _videoProgressView.hidden = YES;
    timerLabel.hidden = YES;
    
//    self.recordingIsOkayBtnBackground.frame = CGRectMake(btnOverView.frame.size.width/2-30, btnOverView.frame.size.height/2-30, 50, 50);
    
    filterControllerView = [[FilterView alloc]initWithFrame:CGRectMake(0, -110, self.frame.size.width, 110)];
    filterControllerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self addSubview:filterControllerView];
    [filterControllerView.noneFilterBtn addTarget:self action:@selector(filterNone) forControlEvents:UIControlEventTouchUpInside];
    [filterControllerView.monoFilterBtn addTarget:self action:@selector(filterMono) forControlEvents:UIControlEventTouchUpInside];
    [filterControllerView.tonalFilterBtn addTarget:self action:@selector(filterTonal) forControlEvents:UIControlEventTouchUpInside];
    [filterControllerView.noirFilterBtn addTarget:self action:@selector(filterNoir) forControlEvents:UIControlEventTouchUpInside];
    [filterControllerView.fadeFilterBtn addTarget:self action:@selector(filterFade) forControlEvents:UIControlEventTouchUpInside];
    [filterControllerView.chromeFilterBtn addTarget:self action:@selector(filterChrome) forControlEvents:UIControlEventTouchUpInside];
    [filterControllerView.processFilterBtn addTarget:self action:@selector(filterProcess) forControlEvents:UIControlEventTouchUpInside];
    [filterControllerView.transferFilterBtn addTarget:self action:@selector(filterTransfer) forControlEvents:UIControlEventTouchUpInside];
    [filterControllerView.instantFilterBtn addTarget:self action:@selector(filterInstant) forControlEvents:UIControlEventTouchUpInside];
    
    [self selectFilterBtn:filterControllerView.noneFilterBtn];
    
    [UIView animateWithDuration:0.3 animations:^{
        filterControllerView.frame = CGRectMake(0, 0, self.frame.size.width, 110);
    } completion:^(BOOL finished) {
        
    }];
    
    [self.recordingIsOkayBtn removeTarget:self action:@selector(recordingIsOkayBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.recordingIsOkayBtn addTarget:self action:@selector(removeCameraView) forControlEvents:UIControlEventTouchUpInside];
    
    [CameraView shared].isBack = YES;
}

-(void)removeFilterView {
    
    self.playBtnBackground.hidden = YES;
    self.recordingIsOkayBtnBackground.hidden = YES;
    [screenShotImageView removeFromSuperview];
    recordBackground.hidden = NO;
    self.recordingIsOkayBtnBackground.frame = CGRectMake(btnOverView.frame.size.width/2-30-80, btnOverView.frame.size.height/2-30, 60, 60);
    
    [self.recordingIsOkayBtn removeTarget:self action:@selector(removeCameraView) forControlEvents:UIControlEventTouchUpInside];
    [self.recordingIsOkayBtn addTarget:self action:@selector(recordingIsOkayBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.3 animations:^{
        filterControllerView.frame = CGRectMake(-90, 0, 90, self.frame.size.height);
    } completion:^(BOOL finished) {
        [filterControllerView removeFromSuperview];
    }];
    
    [CameraView shared].isBack = NO;
    
    [self initiateCamera];
}

//    filter = [[GPUImagePixellateFilter alloc] init];
//    filter = [[GPUImageUnsharpMaskFilter alloc] init];
//    filter = [[GPUImageSketchFilter alloc] init];

-(void)filterNone {
//    filter = [[GPUImageSoftEleganceFilter alloc]init];
//    [self filterVideoWithPath:[CameraView shared].camRollURL filterType:filter];
//    [self playVideo];
    GPUImageSaturationFilter *sat = [[GPUImageSaturationFilter alloc]init];
    sat.saturation = 1.0;
    [self filterVideoWithPath:[CameraView shared].camRollURL filterType:sat];
    [self selectFilterBtn:filterControllerView.noneFilterBtn];
}

-(void)filterMono {
    GPUImageSaturationFilter *sat = [[GPUImageSaturationFilter alloc]init];
    sat.saturation = 0.0;
    [self filterVideoWithPath:[CameraView shared].camRollURL filterType:sat];
    [self selectFilterBtn:filterControllerView.monoFilterBtn];
}
-(void)filterTonal {
    GPUImageSepiaFilter *sepia = [[GPUImageSepiaFilter alloc]init];
    [self filterVideoWithPath:[CameraView shared].camRollURL filterType:sepia];
    [self selectFilterBtn:filterControllerView.tonalFilterBtn];
}
-(void)filterNoir {
    GPUImageBrightnessFilter *brightness = [[GPUImageBrightnessFilter alloc]init];
    brightness.brightness = -0.2;
    [self filterVideoWithPath:[CameraView shared].camRollURL filterType:brightness];
    [self selectFilterBtn:filterControllerView.noirFilterBtn];
}
-(void)filterFade {
    GPUImageSaturationFilter *sat = [[GPUImageSaturationFilter alloc]init];
    sat.saturation = 0.5;
    [self filterVideoWithPath:[CameraView shared].camRollURL filterType:sat];
    [self selectFilterBtn:filterControllerView.fadeFilterBtn];
}
-(void)filterChrome {
//    GPUImageOpacityFilter *opa = [[GPUImageOpacityFilter alloc]init];
//    opa.opacity = 0.5;
//    GPUImageContrastFilter *contract = [[GPUImageContrastFilter alloc]init];
//    contract.contrast = 3.0;
    GPUImageToneCurveFilter *tone = [[GPUImageToneCurveFilter alloc]init];
    NSArray *defaultCurve = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.2, 0.1)], [NSValue valueWithCGPoint:CGPointMake(0.4, 0.3)], [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)], nil];
    tone.rgbCompositeControlPoints = defaultCurve;
    [self filterVideoWithPath:[CameraView shared].camRollURL filterType:tone];
    [self selectFilterBtn:filterControllerView.chromeFilterBtn];

}
-(void)filterProcess {
    filter = [[GPUImageVignetteFilter alloc]init];
    [self filterVideoWithPath:[CameraView shared].camRollURL filterType:filter];
    [self selectFilterBtn:filterControllerView.processFilterBtn];
}
-(void)filterTransfer {
    GPUImageContrastFilter *contract = [[GPUImageContrastFilter alloc]init];
    contract.contrast = 2.0;
    [self filterVideoWithPath:[CameraView shared].camRollURL filterType:contract];
    [self selectFilterBtn:filterControllerView.transferFilterBtn];
}
-(void)filterInstant {
//    GPUImageContrastFilter *contract = [[GPUImageContrastFilter alloc]init];
//    contract.contrast = 0.5;
    GPUImageHazeFilter *haze = [[GPUImageHazeFilter alloc]init];
    haze.distance = 0.3;
    haze.slope = -0.3;
    [self filterVideoWithPath:[CameraView shared].camRollURL filterType:haze];
    [self selectFilterBtn:filterControllerView.instantFilterBtn];
}

-(void)selectFilterBtn:(UIButton *)selected {
    NSArray *btnArray = [NSArray arrayWithObjects:filterControllerView.noneFilterBtn,filterControllerView.monoFilterBtn,filterControllerView.tonalFilterBtn,filterControllerView.noirFilterBtn,filterControllerView.fadeFilterBtn,filterControllerView.chromeFilterBtn,filterControllerView.processFilterBtn,filterControllerView.transferFilterBtn,filterControllerView.instantFilterBtn, nil];
    for (int i = 0; i < btnArray.count; i++) {
        UIButton *btn = btnArray[i];
        btn.backgroundColor = [UIColor whiteColor];
    }
    
    selected.backgroundColor = [UIColor lightGrayColor];
}

-(void)disableAllBtnsWhileFilter {
    filterControllerView.noneFilterBtn.userInteractionEnabled = NO;
    filterControllerView.monoFilterBtn.userInteractionEnabled = NO;
    filterControllerView.tonalFilterBtn.userInteractionEnabled = NO;
    filterControllerView.noirFilterBtn.userInteractionEnabled = NO;
    filterControllerView.fadeFilterBtn.userInteractionEnabled = NO;
    filterControllerView.chromeFilterBtn.userInteractionEnabled = NO;
    filterControllerView.processFilterBtn.userInteractionEnabled = NO;
    filterControllerView.transferFilterBtn.userInteractionEnabled = NO;
    filterControllerView.instantFilterBtn.userInteractionEnabled = NO;
    
    self.playBtn.userInteractionEnabled = NO;
}

-(void)enableAllBtnsWhileFilter {
    filterControllerView.noneFilterBtn.userInteractionEnabled = YES;
    filterControllerView.monoFilterBtn.userInteractionEnabled = YES;
    filterControllerView.tonalFilterBtn.userInteractionEnabled = YES;
    filterControllerView.noirFilterBtn.userInteractionEnabled = YES;
    filterControllerView.fadeFilterBtn.userInteractionEnabled = YES;
    filterControllerView.chromeFilterBtn.userInteractionEnabled = YES;
    filterControllerView.processFilterBtn.userInteractionEnabled = YES;
    filterControllerView.transferFilterBtn.userInteractionEnabled = YES;
    filterControllerView.instantFilterBtn.userInteractionEnabled = YES;
    
    self.playBtn.userInteractionEnabled = YES;
}

-(void)filterVideoWithPath:(NSURL *)videoURLForFilter filterType:(GPUImageOutput<GPUImageInput> *)filterType {
    
    [self disableAllBtnsWhileFilter];
    
    gpuImage = [[GPUImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:gpuImage];
    [self bringSubviewToFront:btnOverView];
    [self bringSubviewToFront:filterControllerView];
    
    //    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"sample_iPod" withExtension:@"m4v"];
    
    movieFile = [[GPUImageMovie alloc] initWithURL:videoURLForFilter];
    movieFile.runBenchmark = YES;
    movieFile.playAtActualSpeed = YES;

    filter = filterType;
    
    [movieFile addTarget:filter];
    
    // Only rotate the video for display, leave orientation the same for recording
    GPUImageView *filterView = (GPUImageView *)gpuImage;
    [filter addTarget:filterView];
    
    // In addition to displaying to the screen, write out a processed version of the movie to disk
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(1280.0, 720.0)];
    [filter addTarget:movieWriter];
    
    // Configure this for video from the movie file, where we want to preserve all video frames and audio samples
    movieWriter.shouldPassthroughAudio = YES;
    movieFile.audioEncodingTarget = movieWriter;
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
    
    [movieWriter startRecording];
    [movieFile startProcessing];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                             target:self
                                           selector:@selector(retrievingProgress)
                                           userInfo:nil
                                            repeats:YES];
    __weak typeof(self) weakSelf = self;
    [movieWriter setCompletionBlock:^{
        [weakSelf.filter removeTarget:weakSelf.movieWriter];
        [weakSelf.movieWriter finishRecording];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.timer invalidate];
            [weakSelf.gpuImage removeFromSuperview];
            [weakSelf.self enableAllBtnsWhileFilter];
        });
    }];
}

-(void)retrievingProgress {
    NSLog(@"retrievingProgress %f", self.movieFile.progress);
}

-(void)removeCameraView {
//    [self showEditingView];
   [[NSNotificationCenter defaultCenter]postNotificationName:@"recordingIsOkay" object:nil];
}

-(void)rotateGPUCamera {
    
    [screenShotImageView removeFromSuperview];
    self.playBtnBackground.hidden = YES;
    self.recordingIsOkayBtnBackground.hidden = YES;
    
    if ( [PBJVision sharedInstance].cameraDevice == PBJCameraDeviceBack) {
        [[PBJVision sharedInstance] setCameraDevice:PBJCameraDeviceFront];
    }
    else {
        [[PBJVision sharedInstance] setCameraDevice:PBJCameraDeviceBack];
    }
}

-(void)flashBtnPressed {
    if ([PBJVision sharedInstance].flashAvailable && [PBJVision sharedInstance].flashMode == PBJFlashModeOff) {
        [[PBJVision sharedInstance] setFlashMode:PBJFlashModeOn];
    }
    else {
        [[PBJVision sharedInstance] setFlashMode:PBJFlashModeOff];
    }
}


-(void)closeBtnPressed {
    if ([CameraView shared].isBack == YES) {
        [self removeFilterView];
    }
    else {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"closeBtnPressed" object:nil];
    }
}

-(void)showEditingView
{
    EditingView *editingView = [[EditingView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:editingView];
}

@end
