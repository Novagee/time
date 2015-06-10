//
//  LocationTableViewCell.m
//  TimeImprint
//
//  Created by Peng Wan on 5/10/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "LocationTableViewCell.h"

@implementation LocationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (NSString *)reuseIdentifier {
    
    return @"LocationTableViewCell";
    
}

@end
