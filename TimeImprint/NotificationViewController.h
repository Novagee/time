//
//  NotificationViewController.h
//  TimeImprint
//
//  Created by Yi Gu on 5/15/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableNotification;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedNotification;

- (IBAction)segmentQAChange:(UISegmentedControl *)sender;

@end
