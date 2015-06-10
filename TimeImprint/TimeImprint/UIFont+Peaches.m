//
//  UIFont+Peaches.m
//  parachute-ios-client-native
//
//  Created by Bibo on 4/4/15.
//  Copyright (c) 2015 Alminty. All rights reserved.
//

#import "UIFont+Peaches.h"

@implementation UIFont (Peaches)

+(UIFont *) gothamBoldWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Gillsans-Bold" size:size];
}

+(UIFont *) gothamBookWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Gillsans" size:size];
}

+(UIFont *) gothamLightWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Gillsans-Light" size:size];
}

@end
