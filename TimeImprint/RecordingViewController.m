//
//  RecordingViewController.m
//  TimeImprint
//
//  Created by Paul on 5/3/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "RecordingViewController.h"
#import "MainViewController.h"
#import "RecordingView.h"

@interface RecordingViewController ()

#pragma mark - Mask View Properties

@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (assign, nonatomic, getter = isExitRecording) BOOL exitRecording;

#pragma mark - Recording Controls Properties

@property (weak, nonatomic) IBOutlet UIView *recordingControls;
@property (weak, nonatomic) IBOutlet UIButton *flashlightButton;
@property (weak, nonatomic) IBOutlet UIButton *assetButton;
@property (weak, nonatomic) IBOutlet UIImageView *assetButtonImage;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

#pragma mark - Video Recording's Properties

@property (nonatomic) dispatch_queue_t captureSessionQueue;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;

@property (weak, nonatomic) IBOutlet RecordingView *recordingView;

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDeviceInput *captureDeviceInput;
@property (strong, nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;

@property (assign, nonatomic, getter=isDeviceAuthorizated) BOOL deviceAuthorization;

@end

@implementation RecordingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Configure video recording
    //
    [self configureCaptureSession];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    _maskView.hidden = NO;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    // Hide mask view with fade animation
    //
    //[self configureMaskView];
    
    // Add observer to device rotation
    //
    [[UIDevice currentDevice]beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didOrientationChanged:)
                                                name:UIDeviceOrientationDidChangeNotification
                                              object:nil];
    
    // Configure the device orientation
    //
    [self rotateDeviceOrientation:UIInterfaceOrientationLandscapeRight];
    
    dispatch_async(self.captureSessionQueue, ^{
        
        [self.captureSession startRunning];
        
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIDeviceOrientationDidChangeNotification
                                                 object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Interface Orientation Methods

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    _maskView.hidden = YES;
    
}

- (void)didOrientationChanged:(NSNotification *)notification {
    
    if (! self.isExitRecording) {
        ((MainViewController *)self.tabBarController).lockScreenRotation = YES;
    }

}

- (void)rotateDeviceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    [[UIDevice currentDevice]setValue:@(interfaceOrientation) forKey:@"orientation"];
    [[UIApplication sharedApplication]setStatusBarOrientation:interfaceOrientation];
    
}

- (NSUInteger)supportedInterfaceOrientations {

    return UIInterfaceOrientationLandscapeRight;
    
}

- (BOOL)shouldAutorotate {
    
    return YES;
    
}

#pragma mark - Video Recording Methods

- (void)configureCaptureSession {
    
    _captureSession = [[AVCaptureSession alloc]init];
    
    _recordingView.captureSession = self.captureSession;
    
    // Let the "start recording" prepare on background, because it may block the thread if you put it in the main thread and cause
    // the UI not response
    //
    _captureSessionQueue = dispatch_queue_create("SessionQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(self.captureSessionQueue, ^{
        
        _backgroundRecordingID = UIBackgroundTaskInvalid;
        
        // Configure the video device with a back position camera
        //
        AVCaptureDevice *videoDevice = [self captureDeviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        
        // Cofigure the camera capture input
        //
        NSError *errorForVideoDevice = nil;
        
        _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&errorForVideoDevice];
        
        if ([self.captureSession canAddInput:self.captureDeviceInput]) {
            [_captureSession addInput:self.captureDeviceInput];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                ((AVCaptureVideoPreviewLayer *)self.recordingView.layer).connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
                
            });
        }
        
        // Configure the audio capture input
        //
        NSError *errorForAudioDevice = nil;
        
        AVCaptureDevice *audioDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio].firstObject;
        
        AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&errorForAudioDevice];
        
        if ([self.captureSession canAddInput:audioDeviceInput]) {
            [_captureSession addInput:audioDeviceInput];
        }
        
        // Configure the file output
        //
        _captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc]init];
        
        if ([self.captureSession canAddOutput:self.captureMovieFileOutput]) {
            [_captureSession addOutput:self.captureMovieFileOutput];
            
            AVCaptureConnection *captureConnection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            
            if ([captureConnection isVideoStabilizationSupported]) {
                
            }
            
        }
        
    });
    
}

- (AVCaptureDevice *)captureDeviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)devicePosition {
    
    NSArray *captureDevices = [AVCaptureDevice devicesWithMediaType:mediaType];

    for (AVCaptureDevice *device in captureDevices) {
        
        if (device.position == devicePosition) {
            return device;
        }
        
    }
    
    NSLog(@"No vvalid device for recording");
    
    return nil;
}

- (void)checkDeviceAuthorization {
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                             completionHandler:^(BOOL granted) {
        
                                 if (granted) {
                                     _deviceAuthorization = YES;
                                 }
                                 
                             }];
    
}

#pragma mark - Mask View Methods

- (void)configureMaskView {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 - 0.618f
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             _maskView.alpha = 0.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             _maskView.hidden = YES;
                             
                         }];
    });
    
}

#pragma mark - Control's Action

- (IBAction)closeButtonTouchUpInside:(id)sender {
    
    // Use this special flag to handle the fucking tabBarController rotation
    //
    _exitRecording = YES;
    ((MainViewController *)self.tabBarController).lockScreenRotation = NO;
    
    [self rotateDeviceOrientation:UIInterfaceOrientationPortrait];

    self.tabBarController.tabBar.hidden = NO;
    [self.tabBarController setSelectedIndex:0];
    
}

- (IBAction)switchCaptureDevicePostionButtonTouchUpInside:(id)sender {
    
    
    
}

- (IBAction)flashLightButtonTouchUpInside:(id)sender {


    
}

- (IBAction)recordingControlButtonTouchUpInside:(id)sender {
    
}

- (IBAction)assetButtonTouchUpInside:(id)sender {
    
}

@end
