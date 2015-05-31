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
@end
