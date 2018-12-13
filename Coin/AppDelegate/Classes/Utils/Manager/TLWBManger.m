//
//  TLWBManger.m
//  Coin
//
//  Created by shaojianfei on 2018/9/15.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WeiboSDK.h>
#import "AppDelegate.h"
#import "TLWBManger.h"

@interface TLWBManger()
@property (nonatomic ,copy) NSString *image;
@property (nonatomic, strong) WBMessageObject *messageObject;

@end
@implementation TLWBManger
+ (void)sinaShareWithImage: (UIImage *)image {
    WBMessageObject *message = [WBMessageObject message];
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(image, 1.0);
    
    message.imageObject = imageObject;
//    imageObject.
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
//    WBWebpageObject *webpage = [WBWebpageObject object];
//    webpage.webpageUrl = url;
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"www.baidu.com";
    authRequest.scope = @"all";

    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    if (![WeiboSDK sendRequest:request]) {
        NSLog(@"打开失败");
    }
}

+(void)sinaShareWithUrl:(NSString *)url
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = url;
    
//    WBHttpRequest *HttpRequest = [WBHttpRequest ]
//    WBImageObject *imageObject = [WBImageObject object];
//    imageObject.imageData = UIImageJPEGRepresentation(image, 1.0);
//    imageObject
//    message.imageObject = imageObject;
    //    imageObject.
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
//    WBWebpageObject *webpage = [WBWebpageObject object];
//    webpage.webpageUrl = url;
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"www.baidu.com";
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    if (![WeiboSDK sendRequest:request]) {
        NSLog(@"打开失败");
    }
}

@end
