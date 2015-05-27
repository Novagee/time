//
//  TopicAPIManager.h
//  TimeImprint
//
//  Created by Peng Wan on 5/25/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIConstants.h"

@interface TopicAPIManager : NSObject

+(instancetype)sharedInstance;

-(void)getHottest:(NSString *)start
            limit:(NSString *)limit
          success:(APISuccessBlock)success
          failure:(APIFailureBlock)failure;

-(void)getLatest:(NSString *)start
            limit:(NSString *)limit
          success:(APISuccessBlock)success
          failure:(APIFailureBlock)failure;

-(void)create:(NSString *)start
 topicContent:(NSString *)topicContent
      success:(APISuccessBlock)success
      failure:(APIFailureBlock)failure;

@end
