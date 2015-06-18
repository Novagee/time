//
//  HFShareHelpers.h
//  HiFu
//
//  Created by Yin Xu on 9/11/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface ShareHelpers : NSObject

/**
 *  Share On Wechat message or moment
 *
 *  @param isMoment     determine if that's a message share or moment share
 *  @param shareTitle   title
 *  @param sharedBody   body
 *  @param thumbImage   thumb image
 *  @param shareImage   share image
 *  @param successBlock success call back
 *  @param failureBlock failure call back
 */
+ (void)shareByWechat:(BOOL)isMoment
       andSharedTitle:(NSString *)shareTitle
           sharedBody:(NSString *)sharedBody
           thumbImage:(UIImage *)thumbImage
          sharedImage:(UIImage *)shareImage
              success:(void(^)())successBlock
              failure:(void(^)())failureBlock;

@end
