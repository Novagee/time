//
//  UIButton+Peaches.h
//  parachute-ios-client-native
//
//  Created by Bibo on 4/4/15.
//  Copyright (c) 2015 Alminty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Peaches)

+(UIButton *)allocInitWithFrame:(CGRect)frame title:(NSString *)title tintColor:(UIColor *)tintColor font:(UIFont *)font baseView:(UIView *)baseView;

@end
