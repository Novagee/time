//
//  Session.h
//  TimeImprint
//
//  Created by Peng Wan on 6/6/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"
@interface Session : NSObject

+ (Session *)sharedInstance;

@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) Profile* user;

@end
