//
//  MainViewController.h
//  TimeImprint
//
//  Created by Paul on 5/5/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITabBarController

@property (assign, nonatomic, getter = isLockScreenRotation) BOOL lockScreenRotation;

@end
