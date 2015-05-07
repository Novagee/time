//
//  CameraEngine.h
//  Encoder Demo
//
//  Created by Geraint Davies on 19/02/2013.
//
//  Updated by Paul on 5/6/15.
//
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

@import AVFoundation;
@import AssetsLibrary;
@import UIKit;

@interface CameraEngine : NSObject

@property (atomic, readwrite) BOOL isRecording;
@property (atomic, readwrite) BOOL isPaused;

@property (strong, nonatomic) AVCaptureSession *captureSession;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (assign, nonatomic) AVCaptureDevicePosition captureDevicePosition;

@property (assign, nonatomic) NSInteger recordingTime;

+ (instancetype)shareEngine;

- (void)configureEngineOnPosition:(AVCaptureDevicePosition)captureDevicePosition;

- (void)shutdownEngine;

- (void)startRecording;
- (void)pauseRecording;
- (void)endRecording;
- (void)resumeRecording;

- (void)changeCaptureDevicePosition;

@end
