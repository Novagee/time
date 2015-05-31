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

-(void)createWithQuestionID:(NSInteger)questionID
       publishTime:(NSInteger)publishTime
        happenTime:(NSInteger)happenTime
             title:(NSString *)title
          location:(NSString *)location
question_timestamp:(NSInteger)questionTime
     questioner_id:(NSInteger)questionerId
           content:(NSString *)content
            public:(BOOL)idPublic
         has_video:(BOOL)hasVideo
has_video_preview_pic:(BOOL)hasVideoPreview
        has_photo1:(BOOL)hasPhoto1
        has_photo2:(BOOL)hasPhoto2
        has_photo3:(BOOL)hasPhoto3
        has_photo4:(BOOL)hasPhoto4
           success:(APISuccessBlock)success
           failure:(APIFailureBlock)failure
{

    [APIManager postToPath:STORY_CREATE
                       body:@{@"shown_at":[NSNumber numberWithInteger:publishTime],@"happened_at":[NSNumber numberWithInteger:happenTime],@"title":title,@"content":content,@"public":[NSNumber numberWithBool:idPublic], @"has_video":@NO,@"has_video_preview_pic":@NO,@"has_photo1":@NO,@"has_photo2":@NO,@"has_photo3":@NO,@"has_photo4":@NO}
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
