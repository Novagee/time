//
//  AddPhotoCollectionViewCell.m
//  documentary-video-ios-native
//
//  Created by Bibo on 4/16/15.
//  Copyright (c) 2015 Bibo. All rights reserved.
//

#import "AddPhotoCollectionViewCell.h"

@implementation AddPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor darkGrayColor];
        
        self.photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.photoImageView.image = [UIImage new];
        [self addSubview:self.photoImageView];
        
        self.imageCheckMark = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-25, 5, 20, 20)];
        self.imageCheckMark.image = [UIImage imageNamed:@"preferences-check-off@2x.png"];
        [self addSubview:self.imageCheckMark];
    }
    return self;
}

@end
