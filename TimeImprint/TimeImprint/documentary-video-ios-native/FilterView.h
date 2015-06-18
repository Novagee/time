//
//  FilterView.h
//  documentary-video-ios-native
//
//  Created by Bibo on 4/5/15.
//  Copyright (c) 2015 Bibo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterView : UIView
{
    CGFloat y;
}
@property (nonatomic, strong) UIButton *noneFilterBtn;
@property (nonatomic, strong) UIButton *monoFilterBtn;
@property (nonatomic, strong) UIButton *tonalFilterBtn;
@property (nonatomic, strong) UIButton *noirFilterBtn;
@property (nonatomic, strong) UIButton *fadeFilterBtn;
@property (nonatomic, strong) UIButton *chromeFilterBtn;
@property (nonatomic, strong) UIButton *processFilterBtn;
@property (nonatomic, strong) UIButton *transferFilterBtn;
@property (nonatomic, strong) UIButton *instantFilterBtn;

@end
