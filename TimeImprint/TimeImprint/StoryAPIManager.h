//
//  StoryAPIManager.h
//  TimeImprint
//
//  Created by Peng Wan on 5/24/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIConstants.h"

@interface StoryAPIManager : NSObject

+(instancetype)sharedInstance;

-(void)viewStory:(NSString *)storyId
         success:(APISuccessBlock)success
         failure:(APIFailureBlock)failure;

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
                    failure:(APIFailureBlock)failure;

-(void)deleteWithId:(NSString*)storyID
                    success:(APISuccessBlock)success
                    failure:(APIFailureBlock)failure;

-(void)likeStory:(NSString *)storyId
         success:(APISuccessBlock)success
         failure:(APIFailureBlock)failure;

-(void)unlikeStory:(NSString *)storyId
           success:(APISuccessBlock)success
           failure:(APIFailureBlock)failure;

@end
