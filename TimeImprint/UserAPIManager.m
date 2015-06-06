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

-(void)signInWithUsername:(NSString *)email
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

-(void)signUpWithUsername:(NSString *)email
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

-(void)viewProfileWithID:(NSString *)userId
                 success:(APISuccessBlock)success
                 failure:(APIFailureBlock)failure{
    [APIManager getFromPath:[NSString stringWithFormat:@"%@/%@",USER_PROFILE,userId] body:@{} success:^(id successResponse) {
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

-(void)updateProfileWithID:(NSString *)userId
                 username:(NSString *)username
                    gender:(NSString *)gender
                       bio:(NSString *)bio
                    avatar:(NSString *)avatar
                profilePic:(NSString *)profilePic
                   success:(APISuccessBlock)success
                   failure:(APIFailureBlock)failure{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if (username) {
        [param setValue:username forKeyPath:@"user_name"];
    }
    if (gender) {
        [param setValue:gender forKey:@"gender"];
    }
    if (bio) {
        [param setValue:bio forKey:@"bio"];
    }
    if (avatar) {
        [param setValue:avatar forKey:@"avatar"];
    }
    if (profilePic) {
        [param setValue:profilePic forKey:@"profile_pic"];
    }    
    
    [APIManager putToPath:[NSString stringWithFormat:@"%@/%@",USER_PROFILE,userId] body:param success:^(id successResponse) {
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
