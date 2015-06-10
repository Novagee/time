//
//  CameraViewController.h
//  documentary-video-ios-native
//
//  Created by Bibo on 3/29/15.
//  Copyright (c) 2015 Bibo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SVProgressHUD.h"
#import "EditingViewController.h"

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UILabel *lockLabel;
    BOOL viewRotated;
    UIButton *openCamera;
    NSURL *urlvideo;
    BOOL cameraViewIsPresent;
    UIView *shadowView;
}

@property (nonatomic, strong) CameraView *cameraView;

@end

