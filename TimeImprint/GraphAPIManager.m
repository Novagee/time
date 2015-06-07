//
//  GraphAPIManager.m
//  TimeImprint
//
//  Created by Peng Wan on 5/25/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "GraphAPIManager.h"
#import "APIConstants.h"
#import "APIManager.h"

@implementation GraphAPIManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static GraphAPIManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[GraphAPIManager alloc] init];
    });
    return  instance;
}

-(void)followUser:(NSString *)userId
          success:(APISuccessBlock)success
          failure:(APIFailureBlock)failure{
    [APIManager postToPath:GRAPH_FOLLOW body:@{@"follower_id":userId,@"followee_id":TEST_USER_ID} success:^(id successResponse) {
        if ([successResponse isKindOfClass:[NSDictionary class]]) {
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

-(void)unfollowUser:(NSString *)userId
            success:(APISuccessBlock)success
            failure:(APIFailureBlock)failure{
    [APIManager postToPath:GRAPH_UNFOLLOW body:@{@"follower_id":userId,@"followee_id":TEST_USER_ID} success:^(id successResponse) {
        if ([successResponse isKindOfClass:[NSDictionary class]]) {
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

-(void)getFollowers:(NSString *)userId
              start:(NSNumber *)start
              limit:(NSNumber *)limit
            success:(APISuccessBlock)success
            failure:(APIFailureBlock)failure{
    [APIManager getFromPath:[NSString stringWithFormat:@"%@/%@",GRAPH_FOLLOWERS,userId] body:@{@"start":start ,@"limit":limit } success:^(id successResponse) {
        if ([successResponse isKindOfClass:[NSDictionary class]]) {
            success(successResponse[@"followers"]);
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

-(void)getFollowees:(NSString *)userId
              start:(NSNumber *)start
              limit:(NSNumber *)limit
            success:(APISuccessBlock)success
            failure:(APIFailureBlock)failure{
    [APIManager getFromPath:[NSString stringWithFormat:@"%@/%@",GRAPH_FOLLOWEES,userId] body:@{@"start":start ,@"limit":limit } success:^(id successResponse) {
        if ([successResponse isKindOfClass:[NSDictionary class]]) {
            success(successResponse[@"followees"]);
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
