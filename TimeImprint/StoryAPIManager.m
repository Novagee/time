//
//  StoryAPIManager.m
//  TimeImprint
//
//  Created by Peng Wan on 5/24/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "StoryAPIManager.h"
#import "APIManager.h"
#import "APIConstants.h"

@implementation StoryAPIManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static StoryAPIManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[StoryAPIManager alloc] init];
    });
    return  instance;
}

-(void)viewWithStoryId:(NSString *)storyId
               success:(APISuccessBlock)success
               failure:(APIFailureBlock)failure{
    [APIManager getFromPath:[NSString stringWithFormat:@"%@/%@",STORY_DETAIL, storyId]
                       body:@{}
                   success:^(id successResponse) {
                       
                       if ([successResponse isKindOfClass:[NSDictionary class]]) {
                           success(successResponse);
                       } else {
                           NSDictionary *detail = @{NSLocalizedDescriptionKey:kResponseNotDictoryError};
                           NSError *e = [NSError errorWithDomain:@"InvalidArgumentErrorDomain"
                                                            code:422
                                                        userInfo:detail];
                           failure(nil, e);
                       }
                   }
                   failure:^(id failureResponse, NSError *error) {
                       failure(failureResponse, error);
                   }
     ];
}

-(void)create:(NSDictionary *)params
      success:(APISuccessBlock)success
      failure:(APIFailureBlock)failure{
    [APIManager postToPath:STORY_CREATE
                      body:params
                   success:^(id successResponse) {
                       
                       if ([successResponse isKindOfClass:[NSDictionary class]]) {
                           success(successResponse);
                       } else {
                           NSDictionary *detail = @{NSLocalizedDescriptionKey:kResponseNotDictoryError};
                           NSError *e = [NSError errorWithDomain:@"InvalidArgumentErrorDomain"
                                                            code:422
                                                        userInfo:detail];
                           failure(nil, e);
                       }
                   }
                   failure:^(id failureResponse, NSError *error) {
                       failure(failureResponse, error);
                   }
     ];
}

-(void)deleteWithStoryId:(NSString *)storyId
                 success:(APISuccessBlock)success
                 failure:(APIFailureBlock)failure{
    [APIManager deleteToPath:STORY_DELETE
                        body:@{@"id":storyId}
                   success:^(id successResponse) {
                       
                       if ([successResponse isKindOfClass:[NSDictionary class]]) {
                           success(successResponse);
                       } else {
                           NSDictionary *detail = @{NSLocalizedDescriptionKey:kResponseNotDictoryError};
                           NSError *e = [NSError errorWithDomain:@"InvalidArgumentErrorDomain"
                                                            code:422
                                                        userInfo:detail];
                           failure(nil, e);
                       }
                   }
                   failure:^(id failureResponse, NSError *error) {
                       failure(failureResponse, error);
                   }
     ];
}

-(void)like:(NSString *)storyId
    success:(APISuccessBlock)success
    failure:(APIFailureBlock)failure{
    [APIManager getFromPath:STORY_LIKE
                        body:@{@"id":storyId}
                     success:^(id successResponse) {
                         
                         if ([successResponse isKindOfClass:[NSDictionary class]]) {
                             success(successResponse);
                         } else {
                             NSDictionary *detail = @{NSLocalizedDescriptionKey:kResponseNotDictoryError};
                             NSError *e = [NSError errorWithDomain:@"InvalidArgumentErrorDomain"
                                                              code:422
                                                          userInfo:detail];
                             failure(nil, e);
                         }
                     }
                     failure:^(id failureResponse, NSError *error) {
                         failure(failureResponse, error);
                     }
     ];
}

-(void)unlike:(NSString *)storyId
      success:(APISuccessBlock)success
      failure:(APIFailureBlock)failure{
    [APIManager getFromPath:STORY_UNLIKE
                       body:@{@"id":storyId}
                    success:^(id successResponse) {
                        
                        if ([successResponse isKindOfClass:[NSDictionary class]]) {
                            success(successResponse);
                        } else {
                            NSDictionary *detail = @{NSLocalizedDescriptionKey:kResponseNotDictoryError};
                            NSError *e = [NSError errorWithDomain:@"InvalidArgumentErrorDomain"
                                                             code:422
                                                         userInfo:detail];
                            failure(nil, e);
                        }
                    }
                    failure:^(id failureResponse, NSError *error) {
                        failure(failureResponse, error);
                    }
     ];
}

-(void)comment:(NSString *)storyId
       content:(NSString *)content
     replyToId:(NSString *)replyToId
       success:(APISuccessBlock)success
       failure:(APIFailureBlock)failure{
    [APIManager postToPath:STORY_COMMENT
                       body:@{@"id":storyId, @"content":content, @"reply_to_id":replyToId}
                    success:^(id successResponse) {
                        
                        if ([successResponse isKindOfClass:[NSDictionary class]]) {
                            success(successResponse);
                        } else {
                            NSDictionary *detail = @{NSLocalizedDescriptionKey:kResponseNotDictoryError};
                            NSError *e = [NSError errorWithDomain:@"InvalidArgumentErrorDomain"
                                                             code:422
                                                         userInfo:detail];
                            failure(nil, e);
                        }
                    }
                    failure:^(id failureResponse, NSError *error) {
                        failure(failureResponse, error);
                    }
     ];
}

-(void)ack:(NSString *)storyId
  actionId:(NSString *)actionId
  accessId:(NSString *)accessId
 accessKey:(NSString *)accessKey
       url:(NSString *)url
   success:(APISuccessBlock)success
   failure:(APIFailureBlock)failure{
    [APIManager putToPath:STORY_ACK
                      body:@{@"story_id":storyId, @"action_id":actionId , @"access_id":accessId , @"access_key":accessKey , @"url":url}
                   success:^(id successResponse) {
                       
                       if ([successResponse isKindOfClass:[NSDictionary class]]) {
                           success(successResponse);
                       } else {
                           NSDictionary *detail = @{NSLocalizedDescriptionKey:kResponseNotDictoryError};
                           NSError *e = [NSError errorWithDomain:@"InvalidArgumentErrorDomain"
                                                            code:422
                                                        userInfo:detail];
                           failure(nil, e);
                       }
                   }
                   failure:^(id failureResponse, NSError *error) {
                       failure(failureResponse, error);
                   }
     ];

}


@end
