//
//  TimePickerViewController.h
//  TimeImprint
//
//  Created by Peng Wan on 5/9/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TimeType) {
    HappenTime = 1,
    PublishTime = 2,
};

@interface TimePickerViewController : UIViewController

@property (nonatomic, assign) TimeType happenedTime;

@end
