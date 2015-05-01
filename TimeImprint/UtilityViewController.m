//
//  UtilityViewController.m
//  TimeImprint
//
//  Created by Yi Gu on 4/19/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "UtilityViewController.h"

@implementation UtilityViewController

+ (void) setupButton: (UIButton *) btn {
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 1.0;
    btn.layer.cornerRadius = 10;
}

+ (void) setupSegmentedControl: (UISegmentedControl *) segCtrl {
    segCtrl.layer.borderColor= [UIColor grayColor].CGColor;
    segCtrl.layer.cornerRadius = 0.0;
    segCtrl.layer.borderWidth = 1.5f;
    
    UIFont *font = [UIFont boldSystemFontOfSize:18.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [segCtrl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
}

@end
