//
//  FollowingCell.h
//  TimeImprint
//
//  Created by Paul on 4/23/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//
#import "Profile.h"

@import UIKit;

@interface FollowingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIButton *unfollowButton;

+ (NSString *)reuseIdentifier;
- (void)initFollowing:(Profile *)following;
@end
