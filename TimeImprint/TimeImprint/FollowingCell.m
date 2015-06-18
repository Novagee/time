//
//  FollowingCell.m
//  TimeImprint
//
//  Created by Paul on 4/23/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "FollowingCell.h"
#import "Profile.h"

@interface FollowingCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameField;
@end

@implementation FollowingCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reuseIdentifier {
    
    return @"FollowingCell";
    
}

- (void)initFollowing:(Profile *)profile{
    self.nameField.text = profile.user_name;
    //todo: get avatar done
}

@end
