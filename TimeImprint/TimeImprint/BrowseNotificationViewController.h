//
//  BrowseNotificationViewController.h
//  TimeImprint
//
//  Created by Yi Gu on 4/15/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseNotificationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *notificationTableView;

@end
