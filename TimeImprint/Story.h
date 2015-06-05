//
//  Story.h
//  TimeImprint
//
//  Created by Kelvin Lam on 6/4/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJKeyValue.h"

@interface Story : NSObject

@property (strong, nonatomic) NSString* story_id;
@property (strong, nonatomic) NSString* content;
@property (strong, nonatomic) NSString* happened_at;
@property (strong, nonatomic) NSString* location;
@property (assign, nonatomic) BOOL public;
@property (strong, nonatomic) NSString* question_id;
@property (strong, nonatomic) NSString* question_timestamp;
@property (strong, nonatomic) NSString* shown_at;
@property (strong, nonatomic) NSString* title;

@end
