//
//  BrowseFollowViewController.h
//  TimeImprint
//
//  Created by Yi Gu on 4/19/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseFollowViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UITableView *followTableView;
@property (weak, nonatomic) IBOutlet UITableView *wechatTableView;
@property (weak, nonatomic) IBOutlet UIButton *wechatInviteBtn;

@property (strong, nonatomic) IBOutlet UISegmentedControl *followSegCtrl;
- (IBAction)changeSource:(UISegmentedControl *)sender;

@end
