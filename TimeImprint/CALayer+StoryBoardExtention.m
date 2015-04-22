//
//  CALayer+StoryBoardExtention.m
//  TimeImprint
//
//  Created by Paul on 4/19/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "CALayer+StoryBoardExtention.h"

@implementation CALayer (StoryBoardExtention)

- (void)setLayerBorderColor:(UIColor *)layerBorderColor {
    
    self.borderColor = layerBorderColor.CGColor;
    
}

- (UIColor *)layerBorderColor {
    return self.layerBorderColor;
}

- (void)setLayerShadowColor:(UIColor *)layerShadowColor {
    
    self.shadowColor = layerShadowColor.CGColor;
    
}

- (UIColor *)layerShadowColor {
    
    return self.layerShadowColor;
    
}

@end
