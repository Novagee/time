//
//  BrowseDetailViewController.h
//  TimeImprint
//
//  Created by Yi Gu on 4/19/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKVideoPlayer.h"

@interface BrowseDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, VKVideoPlayerDelegate>

@property (strong, nonatomic) NSString *story_id;

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *postedDate;
@property (strong, nonatomic) IBOutlet UILabel *likeCount;
@property (strong, nonatomic) IBOutlet UILabel *commentCount;
@property (strong, nonatomic) IBOutlet UILabel *shareCount;

@property (strong, nonatomic) IBOutlet UITableView *browseDetailTableView;

@property (weak, nonatomic) IBOutlet UIButton *browseDetailLikeBtn;
@property (weak, nonatomic) IBOutlet UIButton *browseDetailCommentBtn;
@property (weak, nonatomic) IBOutlet UIButton *browseDetailShareBtn;

@property (nonatomic, strong) VKVideoPlayer* player;

- (IBAction)browseDetailLike:(UIButton *)sender;
- (IBAction)browseDetailComment:(UIButton *)sender;
- (IBAction)browseDetailShare:(UIButton *)sender;

- (IBAction)goBackToNewsFeed:(UIButton *)sender;
@end
