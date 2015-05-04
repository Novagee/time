//
//  RecordingView.m
//  TimeImprint
//
//  Created by Paul on 5/4/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "RecordingView.h"

@implementation RecordingView

+ (Class)layerClass {
    
    return [AVCaptureVideoPreviewLayer class];
    
}

// Configure the session

- (void)setCaptureSession:(AVCaptureSession *)captureSession {
    
    ((AVCaptureVideoPreviewLayer *)self.layer).session = captureSession;
    
}

- (AVCaptureSession *)captureSession {
    
    return ((AVCaptureVideoPreviewLayer *)self.layer).session;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
