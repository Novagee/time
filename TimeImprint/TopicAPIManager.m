//
//  TopicAPIManager.m
//  TimeImprint
//
//  Created by Peng Wan on 5/25/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "TopicAPIManager.h"
#import "APIManager.h"
#import "APIConstants.h"

@implementation TopicAPIManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static TopicAPIManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[TopicAPIManager alloc] init];
    });
    return  instance;
}

-(void)getHottest:(NSString *)start
            limit:(NSString *)limit
          success:(APISuccessBlock)success
          failure:(APIFailureBlock)failure{
    [APIManager getFromPath:TOPIC_HOTTEST body:@{@"start":start ,@"limit":limit } success:^(id successResponse) {
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

-(void)getLatest:(NSString *)start
           limit:(NSString *)limit
         success:(APISuccessBlock)success
         failure:(APIFailureBlock)failure{
    [APIManager getFromPath:TOPIC_LATEST body:@{@"start":start ,@"limit":limit } success:^(id successResponse) {
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

-(void)create:(NSString *)start
 topicContent:(NSString *)topicContent
      success:(APISuccessBlock)success
      failure:(APIFailureBlock)failure{
    [APIManager postToPath:TOPIC_CREATE body:@{@"topic_content":topicContent } success:^(id successResponse) {
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

@end
