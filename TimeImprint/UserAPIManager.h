//
//  UserAPIManager.h
//  TimeImprint
//
//  Created by Peng Wan on 5/24/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIConstants.h"

@interface UserAPIManager : NSObject

+(instancetype)sharedInstance;

-(void)signInWithEmail:(NSString *)email
              password:(NSString *)password
                device:(NSString *)device
               success:(APISuccessBlock)success
               failure:(APIFailureBlock)failure;

-(void)signUpWithEmail:(NSString *)email
              password:(NSString *)password
                gender:(NSString *)gender
                avatar:(NSString *)avatar
               success:(APISuccessBlock)success
               failure:(APIFailureBlock)failure;

@end
