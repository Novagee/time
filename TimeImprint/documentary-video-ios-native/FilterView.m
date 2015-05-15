//
//  FilterView.m
//  documentary-video-ios-native
//
//  Created by Bibo on 4/5/15.
//  Copyright (c) 2015 Bibo. All rights reserved.
//

#import "FilterView.h"
#import "UIButton+Peaches.h"
#import "UIFont+Peaches.h"

@implementation FilterView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        y = 30;
        
        UIScrollView *filterScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-45, -105, 90, self.frame.size.width)];
        filterScroll.contentSize = CGSizeMake(90, (90)*9+30);
        [self addSubview:filterScroll];
        
        filterScroll.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        
        self.noneFilterBtn = [UIButton allocInitWithFrame:CGRectMake(10, y, 70, 70) title:@"None" tintColor:[UIColor blackColor] font:[UIFont gothamLightWithSize:16] baseView:filterScroll];
        [self addFilterBtn:self.noneFilterBtn];
        
        self.monoFilterBtn = [UIButton allocInitWithFrame:CGRectMake(10, y, 70, 70) title:@"Mono" tintColor:[UIColor blackColor] font:[UIFont gothamLightWithSize:16] baseView:filterScroll];
        [self addFilterBtn:self.monoFilterBtn];
        
        self.tonalFilterBtn = [UIButton allocInitWithFrame:CGRectMake(10, y, 70, 70) title:@"Sepia" tintColor:[UIColor blackColor] font:[UIFont gothamLightWithSize:16] baseView:filterScroll];
        [self addFilterBtn:self.tonalFilterBtn];

        self.noirFilterBtn = [UIButton allocInitWithFrame:CGRectMake(10, y, 70, 70) title:@"Noir" tintColor:[UIColor blackColor] font:[UIFont gothamLightWithSize:16] baseView:filterScroll];
        [self addFilterBtn:self.noirFilterBtn];

        self.fadeFilterBtn = [UIButton allocInitWithFrame:CGRectMake(10, y, 70, 70) title:@"Fade" tintColor:[UIColor blackColor] font:[UIFont gothamLightWithSize:16] baseView:filterScroll];
        [self addFilterBtn:self.fadeFilterBtn];

        self.chromeFilterBtn = [UIButton allocInitWithFrame:CGRectMake(10, y, 70, 70) title:@"Chrome" tintColor:[UIColor blackColor] font:[UIFont gothamLightWithSize:16] baseView:filterScroll];
        [self addFilterBtn:self.chromeFilterBtn];
        
        self.processFilterBtn = [UIButton allocInitWithFrame:CGRectMake(10, y, 70, 70) title:@"Process" tintColor:[UIColor blackColor] font:[UIFont gothamLightWithSize:16] baseView:filterScroll];
        [self addFilterBtn:self.processFilterBtn];
        
        self.transferFilterBtn = [UIButton allocInitWithFrame:CGRectMake(10, y, 70, 70) title:@"Transfer" tintColor:[UIColor blackColor] font:[UIFont gothamLightWithSize:16] baseView:filterScroll];
        [self addFilterBtn:self.transferFilterBtn];
        
        self.instantFilterBtn = [UIButton allocInitWithFrame:CGRectMake(10, y, 70, 70) title:@"Instant" tintColor:[UIColor blackColor] font:[UIFont gothamLightWithSize:16] baseView:filterScroll];
        [self addFilterBtn:self.instantFilterBtn];
    }
    return self;
}

-(void)addFilterBtn:(UIButton *)btn {
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.cornerRadius = 5;
    
    y = y+ 90-20 + 10;
}

@end
