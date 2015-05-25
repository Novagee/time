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

-(void)create:(NSDictionary *)params
      success:(APISuccessBlock)success
      failure:(APIFailureBlock)failure;

@end
