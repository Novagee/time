//
//  CameraViewController.m
//  documentary-video-ios-native
//
//  Created by Bibo on 3/29/15.
//  Copyright (c) 2015 Bibo. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController
@synthesize cameraView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotifications];
    [self setupViewController];
}

-(void)viewDidAppear:(BOOL)animated {
//    [self recordingIsOkay];
}

-(void)addNotifications {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recordingIsOkay) name:@"recordingIsOkay" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openCameraRoll) name:@"openCameraRoll" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeBtnPressed) name:@"closeBtnPressed" object:nil];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotateDeviceChangeNotification:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

-(void)setupViewController {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    openCamera = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    openCamera.frame = CGRectMake(100, 100, self.view.frame.size.width-200, 50);
    [openCamera setTitle:@"打开相机" forState:UIControlStateNormal];
    [openCamera addTarget:self action:@selector(closeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openCamera];
    
    cameraView = [[CameraView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:cameraView];
    cameraViewIsPresent = YES;
    
    shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:shadowView];
    
    lockLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height)];
    lockLabel.backgroundColor = [UIColor clearColor];
    lockLabel.textColor = [UIColor whiteColor];
    lockLabel.textAlignment = NSTextAlignmentCenter;
    lockLabel.text = @"      横拍才是王道";
    [shadowView addSubview:lockLabel];
    lockLabel.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
    
    UIImageView *rotateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 80, self.view.frame.size.width-160, self.view.frame.size.width-160)];
    rotateImageView.image = [UIImage imageNamed:@"flipDiagram"];
    [shadowView addSubview:rotateImageView];
    
}

-(void)recordingIsOkay {
    
//    openCamera.hidden = YES;
//    [self closeBtnPressed];
    
    EditingViewController *vc = [[EditingViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)closeBtnPressed {
    
    if (cameraViewIsPresent == YES) {
        cameraViewIsPresent = NO;
        [UIView animateWithDuration:0.3 animations:^{
            cameraView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
    else {
        cameraView = [[CameraView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:cameraView];
        cameraViewIsPresent = YES;
    }
}

-(void)didRotateDeviceChangeNotification:(NSNotification *)notification
{
    if (viewRotated == YES) {
        shadowView.hidden = YES;
    }
    
    viewRotated = YES;
}

-(void)openCameraRoll {
    UIImagePickerController *picker= [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeVideo,nil];
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [SVProgressHUD showWithStatus:@"处理中"];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:(NSString *)kUTTypeVideo] ||
        [type isEqualToString:(NSString *)kUTTypeMovie])
    {
        urlvideo = [info objectForKey:UIImagePickerControllerMediaURL];
        [self addVideoScreenshotToCameraView];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addVideoScreenshotToCameraView {
    
    [CameraView shared].camRollThumbNail = [self loadImage];
    [CameraView shared].camRollURL = urlvideo;
    [[CameraView shared] changePlayURL];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"camRollThumbNailReady" object:nil];
    [SVProgressHUD dismiss];
}

- (UIImage*)loadImage {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:urlvideo options:nil];
    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 60);
    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
    
    return [[UIImage alloc] initWithCGImage:imgRef];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
