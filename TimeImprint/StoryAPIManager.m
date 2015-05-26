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

-(void)create:(NSDictionary *)params
               success:(APISuccessBlock)success
               failure:(APIFailureBlock)failure {
#warning todo validation on fields
    [APIManager postToPath:USER_SIGNUP
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

@end
