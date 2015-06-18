//
//  UtilityViewController.m
//  TimeImprint
//
//  Created by Yi Gu on 4/19/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "UtilityViewController.h"

@implementation UtilityViewController

+ (void) setupButton: (UIButton *) btn {
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 1.0;
    btn.layer.cornerRadius = 10;
}

+ (void) setupSegmentedControl: (UISegmentedControl *) segCtrl {
    segCtrl.layer.borderColor= [UIColor grayColor].CGColor;
    segCtrl.layer.cornerRadius = 0.0;
    segCtrl.layer.borderWidth = 1.5f;
    
    UIFont *font = [UIFont boldSystemFontOfSize:18.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [segCtrl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
}

+ (UIImage *)changeImage:(UIImage *)img withColor:(UIColor *)color {    
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

+ (void)changeImgToCircle: (UIImageView *)imgView {
    imgView.layer.cornerRadius = 18;
    imgView.clipsToBounds = YES;
}

+ (void)changeBtnToCircle: (UIButton *)btn {
    btn.layer.cornerRadius = 18;
    btn.clipsToBounds = YES;
}

+ (UIImage *)getImageFromStringURL:(NSString *)strURL {
    NSURL *url = [NSURL URLWithString:strURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:data];
}

+ (NSString *)getTimeFromEpoch: (NSString *)epochTime {
    NSTimeInterval seconds = [epochTime doubleValue];
    NSDate *dateEpoch = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    NSDate *dateToday = [NSDate date];
    
    NSString *formatString;
    if([self getDay:dateEpoch] == [self getDay:dateToday]){
        formatString = @"HH:mm";
    }else {
        formatString = @"yyyy年MM月dd日";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    
    return [formatter stringFromDate:dateEpoch];
}

+ (NSInteger)getDay: (NSDate *)date {
     NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    return [components day];
}



@end
