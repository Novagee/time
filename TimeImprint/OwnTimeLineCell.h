//
//  OwnTimeLineCell.h
//  TimeImprint
//
//  Created by Paul on 4/20/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"

@interface OwnTimeLineCell : UITableViewCell

@property(assign, nonatomic) BOOL liked;

+ (NSString *)reuseIdentifier;

- (void)initStory:(Story *)story;

@end
