//
//  APIManager.m
//  TimeImprint
//
//  Created by Peng Wan on 5/24/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "APIManager.h"
#import "APIConstants.h"
#import "AFNetworking.h"

@implementation APIManager

+ (void)getFromPath:(NSString *)path
               body:(NSDictionary *)body
            success:(APISuccessBlock)success
            failure:(APIFailureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@/%@", BASE_URL, path];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET"
                                                                                 URLString:url
                                                                                parameters:body
                                                                                     error:NULL];
    NSString *header = [NSString stringWithFormat:@"%@", TEST_TOKEN];
    if (header) {
        [request setValue:header forHTTPHeaderField:@"auth_key"];
    }
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         success(responseObject);
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         failure(operation.responseObject, error);
                                     }];
    [manager.operationQueue addOperation:operation];
}

+ (void)postToPath:(NSString *)path
              body:(NSDictionary *)body
           success:(APISuccessBlock)success
           failure:(APIFailureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@/%@", BASE_URL, path];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:url
                                                                                parameters:body
                                                                                     error:NULL];
    NSString *header = [NSString stringWithFormat:@"%@", TEST_TOKEN];
    if (header) {
        [request setValue:header forHTTPHeaderField:@"auth_key"];
    }
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         success(responseObject);
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         failure(operation.responseObject, error);
                                     }
     ];
    [manager.operationQueue addOperation:operation];
}

+(void)putToPath:(NSString*)path
            body:(NSDictionary*)body
         success:(APISuccessBlock)success
         failure:(APIFailureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@/%@", BASE_URL, path];
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT"
                                                                                 URLString:url
                                                                                parameters:body
                                                                                     error:NULL];
    NSString *header = [NSString stringWithFormat:@"%@", TEST_TOKEN];
    if (header) {
        [request setValue:header forHTTPHeaderField:@"auth_key"];
    }
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         success(responseObject);
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         failure(operation.responseObject, error);
                                     }];
    [manager.operationQueue addOperation:operation];
}

+ (void)deleteToPath:(NSString *)path
                body:(NSDictionary *)body
             success:(APISuccessBlock)success
             failure:(APIFailureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@/%@", BASE_URL, path];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"DELETE"
                                                                                 URLString:url
                                                                                parameters:body
                                                                                     error:NULL];
    NSString *header = [NSString stringWithFormat:@"%@", TEST_TOKEN];
    if (header) {
        [request setValue:header forHTTPHeaderField:@"auth_key"];
    }
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         success(responseObject);
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         failure(operation.responseObject, error);
                                     }];
    [manager.operationQueue addOperation:operation];
}

@end
