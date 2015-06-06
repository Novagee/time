//
//  Profile.h
//  TimeImprint
//
//  Created by Peng Wan on 6/5/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profile : NSObject

@property (strong, nonatomic) NSString* user_id;
@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSString* user_name;
@property (assign, nonatomic) BOOL gender;
@property (strong, nonatomic) NSString* avatar_url;
@property (strong, nonatomic) NSString* profile_pic_url;
@property (assign, nonatomic) int followers;
@property (assign, nonatomic) int following;
@property (strong, nonatomic) NSString* bio;
@property (assign, nonatomic) BOOL is_following_requesting_user;
@property (assign, nonatomic) BOOL is_followed_by_requesting_user;
@property (assign, nonatomic) int story_count;
@property (assign, nonatomic) int deleted_story_count;

@end
