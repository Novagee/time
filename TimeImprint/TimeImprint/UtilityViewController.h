//
//  UtilityViewController.h
//  TimeImprint
//
//  Created by Yi Gu on 4/19/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UtilityViewController : UIViewController

+ (void) setupButton: (UIButton *) btn;

+ (void) setupSegmentedControl: (UISegmentedControl *) segCtrl;

+ (UIImage *)changeImage:(UIImage *)img withColor:(UIColor *)color;

+ (void)changeImgToCircle: (UIImageView *)imgView;

+ (void)changeBtnToCircle: (UIButton *)btn;

+ (UIImage *)getImageFromStringURL:(NSString *)strURL;

+ (NSString *) getTimeFromEpoch: (NSString *)epochTime;

+ (NSInteger)getDay: (NSDate *)date;
@end
