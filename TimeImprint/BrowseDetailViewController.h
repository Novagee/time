//
//  BrowseDetailViewController.h
//  TimeImprint
//
//  Created by Yi Gu on 4/19/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *topView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) IBOutlet UITableView *browseDetailTableView;

@property (weak, nonatomic) IBOutlet UIButton *browseDetailLikeBtn;
@property (weak, nonatomic) IBOutlet UIButton *browseDetailCommentBtn;
@property (weak, nonatomic) IBOutlet UIButton *browseDetailShareBtn;

- (IBAction)browseDetailLike:(UIButton *)sender;
- (IBAction)browseDetailComment:(UIButton *)sender;
- (IBAction)browseDetailShare:(UIButton *)sender;

@end
