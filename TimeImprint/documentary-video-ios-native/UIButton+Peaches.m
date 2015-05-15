//
//  UIButton+Peaches.m
//  parachute-ios-client-native
//
//  Created by Bibo on 4/4/15.
//  Copyright (c) 2015 Alminty. All rights reserved.
//

#import "UIButton+Peaches.h"

@implementation UIButton (Peaches)

+(UIButton *)allocInitWithFrame:(CGRect)frame title:(NSString *)title tintColor:(UIColor *)tintColor font:(UIFont *)font baseView:(UIView *)baseView {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tintColor = tintColor;
    btn.titleLabel.font = font;
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [baseView addSubview:btn];
    
    return btn;
}

@end
