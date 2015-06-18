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
#import "NewStoryViewController.h"
#import "VIdeoAssetsViewController.h"

#import "RecordingView.h"
#import "CameraEngine.h"


typedef NS_ENUM(NSInteger, kRecordButtonStatus) {

    kRecordButtonStatusNormal = 0,
    kRecordButtonStatusPause = 1,
    kRecordButtonStatusRecording = 2,
    kRecordButtonStatusPlayback = 3
    
};

static void * RecordingContext = &RecordingContext;

@interface RecordingViewController () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>

#pragma mark - Mask View Properties

@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (assign, nonatomic, getter = isExitRecording) BOOL exitRecording;

#pragma mark - Recording Controls Properties

@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIButton *assetButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIView *recordingControls;
@property (weak, nonatomic) IBOutlet UIButton *flashlightButton;
@property (weak, nonatomic) IBOutlet UIButton *playBackStopButton;
@property (weak, nonatomic) IBOutlet UIButton *playBackPlayButton;
@property (weak, nonatomic) IBOutlet UIImageView *assetButtonImage;
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
    
    [self configureControlsStatusVia:kRecordButtonStatusNormal];
    
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
                             [[CameraEngine shareEngine]startRecording];
                             
                             // Just for UI, it should change image better
                             //
                             [self configureControlsStatusVia:kRecordButtonStatusRecording];
                             
                             // Ready to display the timer and the progress layer
                             //
                             [self configureVideoTimeLayer];
                             [self configureRecordingTimerWithTime:0];
                             
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

- (void)configureRecordingTimerWithTime:(NSInteger)time {
    
    _recordingTime = time;
    
    _recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                       target:self
                                                     selector:@selector(handleRecordingTimer)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void)stopRecordingTimer {
    
    [_recordingTimer invalidate];
    
}

- (void)handleRecordingTimer {
    
    if ([CameraEngine shareEngine].recordingTime == 10.0f) {
        
        // End recording here
        // ...
        [[CameraEngine shareEngine]endRecording];
        
        [_recordingTimer invalidate];
        
        return ;
    }
    
    if (self.recordingTime == 3.0f) {
        
    }
    
    _videoTimeLayer.strokeEnd = [CameraEngine shareEngine].recordingTime/10.0f;
    [_videoTimeLayer setNeedsDisplay];
    
    [CameraEngine shareEngine].recordingTime += 1.0f;
    
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

- (void)configureControlsStatusVia:(kRecordButtonStatus)recordStatus {
    
    switch (recordStatus) {
        case kRecordButtonStatusNormal:
        {
            _flashlightButton.hidden = NO;
            _assetButton.hidden = NO;
            _assetButtonImage.hidden = NO;
            _exitButton.hidden = NO;
            _playBackPlayButton.hidden = YES;
            _playBackStopButton.hidden = YES;
            
            _recordButton.hidden = NO;
            [_recordButton setImage:[UIImage imageNamed:@"record_60"] forState:UIControlStateNormal];
            
            _recordCompleteButton.hidden = YES;
        }
            break;
            
        case kRecordButtonStatusRecording:
        {
            _flashlightButton.hidden = YES;
            _assetButton.hidden = YES;
            _assetButtonImage.hidden = YES;
            _exitButton.hidden = YES;
            _playBackPlayButton.hidden = YES;
            _playBackStopButton.hidden = YES;
            
            _recordButton.hidden = NO;
            [_recordButton setImage:[UIImage imageNamed:@"recordPause_60"] forState:UIControlStateNormal];
            
            _recordCompleteButton.hidden = NO;
            [_recordCompleteButton setImage:[UIImage imageNamed:@"videoReady_42"] forState:UIControlStateNormal];
        }
            break;
        
        case kRecordButtonStatusPause:
        {
            _flashlightButton.hidden = NO;
            _assetButton.hidden = YES;
            _assetButtonImage.hidden = YES;
            _exitButton.hidden = NO;
            _playBackPlayButton.hidden = NO;
            _playBackStopButton.hidden = YES;
            
            _recordButton.hidden = NO;
            [_recordButton setImage:[UIImage imageNamed:@"record_60"] forState:UIControlStateNormal];
            
            _recordCompleteButton.hidden = NO;
        }
            break;
            
        case kRecordButtonStatusPlayback:
        {
            _flashlightButton.hidden = YES;
            _assetButton.hidden = YES;
            _assetButtonImage.hidden = YES;
            _exitButton.hidden = YES;
            _playBackPlayButton.hidden = YES;
            _playBackStopButton.hidden = NO;
            
            _recordButton.hidden = YES;
            [_recordButton setImage:[UIImage imageNamed:@"record_60"] forState:UIControlStateNormal];
            
            _recordCompleteButton.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    
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
    
    [[CameraEngine shareEngine] changeCaptureDevicePosition];
    
    if ([CameraEngine shareEngine].captureDevicePosition == AVCaptureDevicePositionFront) {
        
        _flashlightButton.hidden = YES;
        
    }
    else {
        
        _flashlightButton.hidden = NO;
        
    }
    
}

- (IBAction)flashLightButtonTouchUpInside:(id)sender {

    
}

- (IBAction)recordingControlButtonTouchUpInside:(id)sender {

    UIButton *button = (UIButton *)sender;
    
    if (button.tag == kRecordButtonStatusNormal) {
        
        [self configureBackwardTimer];
        button.tag = kRecordButtonStatusRecording;
        
    }
    else if (button.tag == kRecordButtonStatusRecording){
        
        [[CameraEngine shareEngine] pauseRecording];
        button.tag = kRecordButtonStatusPause;
        
        [self configureControlsStatusVia:kRecordButtonStatusPause];
        [self stopRecordingTimer];
        
    }
    else {
        
        [[CameraEngine shareEngine]resumeRecording];
        button.tag = kRecordButtonStatusRecording;
        
        [self configureControlsStatusVia:kRecordButtonStatusRecording];
        [self configureRecordingTimerWithTime:[CameraEngine shareEngine].recordingTime];
        
    }
    
}

- (IBAction)assetButtonTouchUpInside:(id)sender {
    
    VIdeoAssetsViewController *videoAssetsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"videoAssetsView"];
    [self.navigationController pushViewController:videoAssetsViewController animated:YES];
    
}

- (IBAction)recordingCompleteButtonTouchUpInside:(id)sender {

    [[CameraEngine shareEngine]endRecording];
    
//    NewStoryViewController *newStoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"new_story"];
//    
//    [self.navigationController pushViewController:newStoryViewController animated:YES];
//    [self presentViewController:newStoryViewController animated:YES completion:nil];

}

- (IBAction)playBackPlayButtonTouchUpInside:(id)sender {
    
    [self configureControlsStatusVia:kRecordButtonStatusPlayback];
    
}

- (IBAction)playBackStopButtonTouchUpInside:(id)sender {
    
    [self configureControlsStatusVia:kRecordButtonStatusPause];
    
}

@end
