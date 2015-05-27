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

-(void)viewWithStoryId:(NSString *)storyId
               success:(APISuccessBlock)success
               failure:(APIFailureBlock)failure;

-(void)create:(NSDictionary *)params
      success:(APISuccessBlock)success
      failure:(APIFailureBlock)failure;

-(void)deleteWithStoryId:(NSString *)storyId
                 success:(APISuccessBlock)success
                 failure:(APIFailureBlock)failure;

-(void)like:(NSString *)storyId
    success:(APISuccessBlock)success
    failure:(APIFailureBlock)failure;

-(void)unlike:(NSString *)storyId
      success:(APISuccessBlock)success
      failure:(APIFailureBlock)failure;

-(void)comment:(NSString *)storyId
       content:(NSString *)content
     replyToId:(NSString *)replyToId
       success:(APISuccessBlock)success
       failure:(APIFailureBlock)failure;

-(void)ack:(NSString *)storyId
  actionId:(NSString *)actionId
  accessId:(NSString *)accessId
 accessKey:(NSString *)accessKey
       url:(NSString *)url
   success:(APISuccessBlock)success
   failure:(APIFailureBlock)failure;

@end
