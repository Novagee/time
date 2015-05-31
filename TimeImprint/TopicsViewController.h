//
//  TopicsViewController.h
//  TimeImprint
//
//  Created by Yi Gu on 5/10/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *topicsTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedTopics;

- (IBAction)segmentedTopicChange:(UISegmentedControl *)sender;

@end
