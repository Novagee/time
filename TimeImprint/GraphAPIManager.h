//
//  GraphAPIManager.h
//  TimeImprint
//
//  Created by Peng Wan on 5/25/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIConstants.h"

@interface GraphAPIManager : NSObject

+(instancetype)sharedInstance;

-(void)followUser:(NSString *)userId
          success:(APISuccessBlock)success
          failure:(APIFailureBlock)failure;

-(void)unfollowUser:(NSString *)userId
            success:(APISuccessBlock)success
            failure:(APIFailureBlock)failure;

-(void)getFollowers:(NSString *)userId
              start:(NSNumber *)start
              limit:(NSNumber *)limit
            success:(APISuccessBlock)success
            failure:(APIFailureBlock)failure;

-(void)getFollowees:(NSString *)userId
              start:(NSNumber *)start
              limit:(NSNumber *)limit
            success:(APISuccessBlock)success
            failure:(APIFailureBlock)failure;

@end
