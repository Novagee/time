//
//  APIManager.h
//  TimeImprint
//
//  Created by Peng Wan on 5/24/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIConstants.h"

@interface APIManager : NSObject

+ (void)getFromPath:(NSString*)path
               body:(NSDictionary*)body
            success:(APISuccessBlock)success
            failure:(APIFailureBlock)failure;

+ (void)postToPath:(NSString*)path
              body:(NSDictionary*)body
           success:(APISuccessBlock)success
           failure:(APIFailureBlock)failure;

+ (void)putToPath:(NSString *)path
             body:(NSDictionary *)body
          success:(APISuccessBlock)success
          failure:(APIFailureBlock)failure;

+ (void)deleteToPath:(NSString *)path
                body:(NSDictionary *)body
             success:(APISuccessBlock)success
             failure:(APIFailureBlock)failure;

@end
