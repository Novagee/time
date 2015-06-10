//
//  EditingView.h
//  documentary-video-ios-native
//
//  Created by Bibo on 4/7/15.
//  Copyright (c) 2015 Bibo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditingView : UIView <UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate>
{
    UIScrollView *backgroundScrollView;
    CGFloat y;
}

@property (nonatomic, strong) UIImageView *videoImage;
@property (nonatomic, strong) UIImageView *photoImageOne;
@property (nonatomic, strong) UIImageView *photoImageTwo;
@property (nonatomic, strong) UIImageView *photoImageThree;
@property (nonatomic, strong) UIImageView *photoImageFour;
@property (nonatomic, strong) UIButton *publishBtn;
@property (nonatomic, strong) UITextField *titleTextfield;
@property (nonatomic, strong) UISwitch *pricacyToggle;
@property (nonatomic, strong) UIButton *privacyBtn;
@property (nonatomic, assign) BOOL isPublic;
@property (nonatomic, strong) UITextView *aboutBox;

@end
