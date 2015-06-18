//
//  RecordingView.h
//  TimeImprint
//
//  Created by Paul on 5/4/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

@import UIKit;
@import AVFoundation;

@interface RecordingView : UIView

@property (strong, nonatomic) AVCaptureSession *captureSession;

@end
