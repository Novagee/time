//
//  CameraView.h
//  documentary-video-ios-native
//
//  Created by Bibo on 3/29/15.
//  Copyright (c) 2015 Bibo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <PBJVision.h>
#import "GPUImage.h"
#import "FilterView.h"
#import "EditingView.h"

@interface CameraView : UIView <PBJVisionDelegate>
{
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    AVCaptureDevice *device;
    UIImage *newImage;
    NSData *newImageData;
    
    GPUImageVideoCamera *videoCamera;
    
//    GPUImageMovieWriter *movieWriter;
    //ohshit
    //womailegebiao
    
    
    GPUImageView *gpuImageView;
    GPUImageMovie *movieFile;
    
    GPUImageMovie *_movieFile;
    GPUImageOutput<GPUImageInput> *_sketchFilter;
    
    UIView *btnOverView;
    CGFloat viewHeight;
    BOOL videoFinished;
    BOOL recordingStarted;
    
    AVPlayer *avPlayer;
    AVPlayerLayer *avPlayerLayer;
    NSURL *videoURL;
    
    UIImage *screenShotImage;
    UIButton *recordBackground;
    UIImageView *screenShotImageView;
    UILabel *timerLabel;
    UIButton *openCameraRollBtn;
    FilterView *filterControllerView;
    
}

+ (CameraView *)shared;

-(void)changePlayURL;

@property (nonatomic,retain) GPUImageView *gpuImage;
@property (nonatomic, strong) GPUImageMovieWriter *writer;
@property (nonatomic, strong) NSURL *camRollURL;

@property (nonatomic, strong) UIImage *camRollThumbNail;
@property(nonatomic, retain) UIView *previewView;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property(nonatomic, retain) UIView *vImagePreview;
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic,retain)    GPUImageMovie *movieFile;
@property (nonatomic,retain)    GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic,retain)    GPUImageMovieWriter *movieWriter;

@property (nonatomic,retain) NSTimer * timer;

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *frontOrBackBtn;
@property (nonatomic, strong) UIButton *flashBtn;
@property (nonatomic, strong) UIButton *recordBtn;

@property (nonatomic, strong) UIView *playBtnBackground;
@property (nonatomic, strong) UIView *recordingIsOkayBtnBackground;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *recordingIsOkayBtn;

@property (nonatomic, strong) UIButton *removePlayerBtn;

@property (nonatomic, strong) UIView *videoProgressView;
@property (nonatomic, readwrite) BOOL isBack;

@end
