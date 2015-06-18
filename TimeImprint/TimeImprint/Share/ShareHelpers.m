//
//  HFShareHelpers.m
//  HiFu
//
//  Created by Yin Xu on 9/11/14.
//  Copyright (c) 2014 HiFu.Inc. All rights reserved.
//

#import "WXApi.h"


#import "ShareHelpers.h"

@implementation ShareHelpers

+ (void)shareByWechat:(BOOL) isMoment
       andSharedTitle:(NSString *)shareTitle
           sharedBody:(NSString *)sharedBody
           thumbImage:(UIImage *)thumbImage
          sharedImage:(UIImage *)shareImage
              success:(void(^)())successBlock
              failure:(void(^)())failureBlock
{
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    
    // if the Weixin app is not installed, show alert
    //
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"无法找到微信App,请检查是否安装微信" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    req.message = WXMediaMessage.message;
    req.message.title = shareTitle;
    req.message.description = sharedBody;
    
    WXImageObject *imageObject = WXImageObject.object;
    [req.message setThumbImage:thumbImage];
    imageObject.imageData = UIImageJPEGRepresentation(shareImage, 1);
    req.message.mediaObject = imageObject;
    req.scene = isMoment ? WXSceneTimeline : WXSceneSession;
    
    if ([WXApi sendReq:req])
    {
        if (successBlock)
            successBlock();
    }
    else
    {
        if (failureBlock)
            failureBlock();
    }
}

@end
