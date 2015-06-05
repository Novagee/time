//
//  TimelineAPIManager.m
//  TimeImprint
//
//  Created by Peng Wan on 5/25/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "TimelineAPIManager.h"
#import "APIConstants.h"
#import "APIManager.h"

@implementation TimelineAPIManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static TimelineAPIManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[TimelineAPIManager alloc] init];
    });
    return  instance;
}

-(void)getTimelineWithUser:(NSString *)userId
                   storyId:(NSString *)storyId
                     limit:(NSNumber *)limit
                   success:(APISuccessBlock)success
                   failure:(APIFailureBlock)failure{
    [APIManager getFromPath:[NSString stringWithFormat:@"%@/%@",TIMELINE_BY_USER,userId] body:@{@"from_story_id":storyId ,@"limit":limit } success:^(id successResponse) {
        if ([successResponse isKindOfClass:[NSDictionary class]]) {
            success(successResponse[@"stories"]);
        } else {
            NSDictionary *detail = @{NSLocalizedDescriptionKey:kResponseNotDictoryError};
            NSError *e = [NSError errorWithDomain:@"InvalidArgumentErrorDomain"
                                             code:422
                                         userInfo:detail];
            failure(nil, e);
        }
    } failure:^(id failureResponse, NSError *error) {
        failure(failureResponse, error);
    }];
}

-(void)getTimelineWithTopic:(NSString *)topicId
                    storyId:(NSString *)storyId
                      limit:(NSNumber *)limit
                    success:(APISuccessBlock)success
                    failure:(APIFailureBlock)failure{
    [APIManager getFromPath:[NSString stringWithFormat:@"%@/%@",TIMELINE_BY_TOPIC,topicId] body:@{@"from_story_id":storyId ,@"limit":limit } success:^(id successResponse) {
        if ([successResponse isKindOfClass:[NSArray class]]) {
            success(successResponse);
        } else {
            NSDictionary *detail = @{NSLocalizedDescriptionKey:kResponseNotDictoryError};
            NSError *e = [NSError errorWithDomain:@"InvalidArgumentErrorDomain"
                                             code:422
                                         userInfo:detail];
            failure(nil, e);
        }
    } failure:^(id failureResponse, NSError *error) {
        failure(failureResponse, error);
    }];
}

-(void)getNewsFeedWithStoryId:(NSString *)storyId
                        limit:(NSNumber *)limit
                      success:(APISuccessBlock)success
                      failure:(APIFailureBlock)failure{
    [APIManager getFromPath:TIMELINE_NEWSFEED body:@{@"from_story_id":storyId ,@"limit":limit } success:^(id successResponse) {
        if ([successResponse isKindOfClass:[NSArray class]]) {
            success(successResponse);
        } else {
            NSDictionary *detail = @{NSLocalizedDescriptionKey:kResponseNotDictoryError};
            NSError *e = [NSError errorWithDomain:@"InvalidArgumentErrorDomain"
                                             code:422
                                         userInfo:detail];
            failure(nil, e);
        }
    } failure:^(id failureResponse, NSError *error) {
        failure(failureResponse, error);
    }];

}

-(void)getDiscoveryWithStoryId:(NSString *)storyId
                         limit:(NSNumber *)limit
                       success:(APISuccessBlock)success
                       failure:(APIFailureBlock)failure{
    [APIManager getFromPath:TIMELINE_DISCOVERY body:@{@"from_story_id":storyId ,@"limit":limit } success:^(id successResponse) {
        if ([successResponse isKindOfClass:[NSArray class]]) {
            success(successResponse);
        } else {
            NSDictionary *detail = @{NSLocalizedDescriptionKey:kResponseNotDictoryError};
            NSError *e = [NSError errorWithDomain:@"InvalidArgumentErrorDomain"
                                             code:422
                                         userInfo:detail];
            failure(nil, e);
        }
    } failure:^(id failureResponse, NSError *error) {
        failure(failureResponse, error);
    }];

}

-(void)getTaggedWithStoryId:(NSString *)storyId
                      limit:(NSNumber *)limit
                    success:(APISuccessBlock)success
                    failure:(APIFailureBlock)failure{
    [APIManager getFromPath:TIMELINE_TAGGED body:@{@"from_story_id":storyId ,@"limit":limit } success:^(id successResponse) {
        if ([successResponse isKindOfClass:[NSArray class]]) {
            success(successResponse);
        } else {
            NSDictionary *detail = @{NSLocalizedDescriptionKey:kResponseNotDictoryError};
            NSError *e = [NSError errorWithDomain:@"InvalidArgumentErrorDomain"
                                             code:422
                                         userInfo:detail];
            failure(nil, e);
        }
    } failure:^(id failureResponse, NSError *error) {
        failure(failureResponse, error);
    }];
}

@end
