//
//  QuestionAPIManager.h
//  TimeImprint
//
//  Created by Peng Wan on 5/25/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIConstants.h"

@interface QuestionAPIManager : NSObject

+(instancetype)sharedInstance;

-(void)ask:(NSString *)topicId
            askUserId:(NSString *)askUserId
          success:(APISuccessBlock)success
          failure:(APIFailureBlock)failure;

-(void)inbounds:(NSString *)start
          limit:(NSString *)limit
           type:(NSString *)type
        success:(APISuccessBlock)success
        failure:(APIFailureBlock)failure;

-(void)outbounds:(NSString *)start
          limit:(NSString *)limit
           type:(NSString *)type
        success:(APISuccessBlock)success
        failure:(APIFailureBlock)failure;

-(void)read:(NSString *)questionId
    success:(APISuccessBlock)success
    failure:(APIFailureBlock)failure;

-(void)deleteQuestion:(NSString *)questionId
              success:(APISuccessBlock)success
              failure:(APIFailureBlock)failure;

@end
