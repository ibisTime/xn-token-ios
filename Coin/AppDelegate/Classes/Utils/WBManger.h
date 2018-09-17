//
//  WBManger.h
//  Coin
//
//  Created by shaojianfei on 2018/9/15.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBManger : NSObject

+(instancetype) shareInstance;

/**
 初始化微博SDK
 */
+(void)initSDK;

/**
 openURL回调
 */
+(BOOL)handleOpenURL:(NSURL *)url;

/**
 微博登录
 */
+ (void)sendWeiboLoginRequest;
/**
 分享到微博
 
 @param content  分享的文字内容
 @param urlStr   分享的图片URL字符串
 */
+ (void)shareToWeiboWithContent:(NSString *)content
                    imageURLStr:(NSString *)urlStr;

@end
