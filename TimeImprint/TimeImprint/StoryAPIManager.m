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

-(void)viewStory:(NSString *)storyId
         success:(APISuccessBlock)success
         failure:(APIFailureBlock)failure {
    NSString *strPath = [NSString stringWithFormat:@"%@/%@", STORY_DETAIL, storyId];
    [APIManager getFromPath:strPath body:@{} success:^(id successResponse) {
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

-(void)createWithQuestionID:(NSInteger)questionID
       publishTime:(NSInteger)publishTime
        happenTime:(NSInteger)happenTime
             title:(NSString *)title
          location:(NSString *)location
question_timestamp:(NSInteger)questionTime
     questioner_id:(NSInteger)questionerId
           content:(NSString *)content
            public:(BOOL)isPublic
          videoUrl:(NSString *)videoUrl
   videoPreviewUrl:(NSString *)videoPreviewUrl
         photo1Url:(NSString *)photo1Url
         photo2Url:(NSString *)photo2Url
         photo3Url:(NSString *)photo3Url
         photo4Url:(NSString *)photo4Url
           success:(APISuccessBlock)success
           failure:(APIFailureBlock)failure
{
    NSMutableDictionary *body = [[NSMutableDictionary alloc] init];
    [body setObject:[NSNumber numberWithInteger:publishTime] forKey:@"shown_at"];
    [body setObject:[NSNumber numberWithInteger:happenTime] forKey:@"happened_at"];
    if (title) {
        [body setObject:title forKey:@"title"];
    }
    if (content) {
        [body setObject:content forKey:@"content"];
    }
    [body setObject:[NSNumber numberWithBool:isPublic] forKey:@"public"];
    if (videoPreviewUrl) {
        [body setObject:videoPreviewUrl forKey:@"video_preview_pic_url"];
    }
    
    if (videoUrl) {
        [body setObject:videoUrl forKey:@"video_url"];
    }

    if (photo1Url) {
        [body setObject:photo1Url forKey:@"photo1_url"];
    }

    if (photo2Url) {
        [body setObject:photo2Url forKey:@"photo2_url"];
    }
    
    if (photo3Url) {
        [body setObject:photo3Url forKey:@"photo3_url"];
    }

    if (photo4Url) {
        [body setObject:photo4Url forKey:@"photo4_url"];
    }

    [APIManager postToPath:STORY_CREATE
                       body:body
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

-(void)deleteWithId:(NSString*)storyID
            success:(APISuccessBlock)success
            failure:(APIFailureBlock)failure{
    [APIManager deleteToPath:STORY_DELETE
                      body:@{@"story_id":storyID}
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

-(void)likeStory:(NSString *)storyId
          success:(APISuccessBlock)success
          failure:(APIFailureBlock)failure{
    [APIManager postToPath:STORY_LIKE body:@{@"id":storyId} success:^(id successResponse) {
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

-(void)unlikeStory:(NSString *)storyId
           success:(APISuccessBlock)success
           failure:(APIFailureBlock)failure{
    [APIManager postToPath:STORY_UNLIKE body:@{@"id":storyId} success:^(id successResponse) {
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
