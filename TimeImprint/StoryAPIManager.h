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
                    failure:(APIFailureBlock)failure;

@end
