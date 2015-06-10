//
//  TimelineAPIManager.h
//  TimeImprint
//
//  Created by Peng Wan on 5/25/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIConstants.h"

@interface TimelineAPIManager : NSObject

+(instancetype)sharedInstance;

-(void)getTimelineWithUser:(NSString *)userId
                   storyId:(NSString *)storyId
                     limit:(NSNumber *)limit
                   success:(APISuccessBlock)success
                   failure:(APIFailureBlock)failure;

-(void)getTimelineWithTopic:(NSString *)topicId
                    storyId:(NSString *)storyId
                      limit:(NSNumber *)limit
                    success:(APISuccessBlock)success
                    failure:(APIFailureBlock)failure;

-(void)getNewsFeedWithStoryId:(NSString *)storyId
                        limit:(NSNumber *)limit
                      success:(APISuccessBlock)success
                      failure:(APIFailureBlock)failure;

-(void)getDiscoveryWithStoryId:(NSString *)storyId
                         limit:(NSNumber *)limit
                       success:(APISuccessBlock)success
                       failure:(APIFailureBlock)failure;

-(void)getTaggedWithStoryId:(NSString *)storyId
                         limit:(NSNumber *)limit
                       success:(APISuccessBlock)success
                       failure:(APIFailureBlock)failure;

@end
