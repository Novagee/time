//
//  QuestionAPIManager.m
//  TimeImprint
//
//  Created by Peng Wan on 5/25/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "QuestionAPIManager.h"
#import "APIManager.h"
#import "APIConstants.h"

@implementation QuestionAPIManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static QuestionAPIManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[QuestionAPIManager alloc] init];
    });
    return  instance;
}

-(void)ask:(NSString *)topicId
 askUserId:(NSString *)askUserId
   success:(APISuccessBlock)success
   failure:(APIFailureBlock)failure{
    [APIManager postToPath:QUESTION_ASK body:@{@"topic_id":topicId ,@"ask_user_id":askUserId } success:^(id successResponse) {
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

-(void)inbounds:(NSString *)start
          limit:(NSString *)limit
           type:(NSString *)type
        success:(APISuccessBlock)success
        failure:(APIFailureBlock)failure{
    [APIManager getFromPath:QUESTION_INBOUNDS body:@{@"start":start ,@"limit":limit,@"type":type } success:^(id successResponse) {
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

-(void)outbounds:(NSString *)start
           limit:(NSString *)limit
            type:(NSString *)type
         success:(APISuccessBlock)success
         failure:(APIFailureBlock)failure{
    [APIManager getFromPath:QUESTION_OUTBOUNDS body:@{@"start":start ,@"limit":limit,@"type":type } success:^(id successResponse) {
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

-(void)read:(NSString *)questionId
    success:(APISuccessBlock)success
    failure:(APIFailureBlock)failure{
    [APIManager postToPath:[NSString stringWithFormat:@"%@/%@",QUESTION_READ,questionId] body:@{} success:^(id successResponse) {
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

-(void)deleteQuestion:(NSString *)questionId
              success:(APISuccessBlock)success
              failure:(APIFailureBlock)failure{
    [APIManager deleteToPath:[NSString stringWithFormat:@"%@/%@",QUESTION_DELETE,questionId] body:@{} success:^(id successResponse) {
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
