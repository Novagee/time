//
//  UserAPIManager.m
//  TimeImprint
//
//  Created by Peng Wan on 5/24/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "UserAPIManager.h"
#import "APIManager.h"

@implementation UserAPIManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static UserAPIManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[UserAPIManager alloc] init];
    });
    return  instance;
}

-(void)signInWithEmail:(NSString *)email
              password:(NSString *)password
                device:(NSString *)device
               success:(APISuccessBlock)success
               failure:(APIFailureBlock)failure {
    
    [APIManager postToPath:USER_SIGNIN
                             body:@{@"email":email, @"password":password, @"device_info":device}
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

-(void)signUpWithEmail:(NSString *)email
              password:(NSString *)password
                gender:(NSString *)gender
                avatar:(NSString *)avatar
               success:(APISuccessBlock)success
               failure:(APIFailureBlock)failure {
    
    [APIManager postToPath:USER_SIGNUP
                      body:@{@"email":email, @"password":password, @"gender":gender, @"avatar":avatar}
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
