//
//  Session.m
//  TimeImprint
//
//  Created by Peng Wan on 6/6/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "Session.h"
#import "Profile.h"

@implementation Session

+ (Session *)sharedInstance {
    static Session *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[Session alloc] init];
    });
    
    return _sharedInstance;
}

- (void) clearSession
{
    self.user = nil;
    self.token = nil;
}

@end
