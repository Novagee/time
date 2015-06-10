//
//  AskWhoViewController.h
//  TimeImprint
//
//  Created by Yi Gu on 5/11/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskWhoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *strTopic;

@property (strong, nonatomic) IBOutlet UILabel *labelTopic;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedSocial;
@property (weak, nonatomic) IBOutlet UITableView *tableFriends;
@property (weak, nonatomic) IBOutlet UIView *viewSelectedFriends;

- (IBAction)segmentedSocialChange:(UISegmentedControl *)sender;
@end
