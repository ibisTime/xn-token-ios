//
//  QQManager.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

@interface QQManager : NSObject<QQApiInterfaceDelegate>

@property (nonatomic, copy) void(^qqShare)(BOOL isSuccess,int errorCode);

+ (instancetype)manager;
//注册APP
- (void)registerApp;
//分享

/**
 分享网页
 @param scene 类别（QQ好友还是QQ空间）
 @param title 分享标题
 @param desc 分享描述
 @param url 分享链接
 @param previewImage 预览图片
 */
+ (void)qqShareWebPageWithScene:(int)scene title:(NSString *)title desc:(NSString *)desc url:(NSString *)url previewImage:(NSString *)previewImageUrl;
/**
 分享图片
 @param scene 类别（QQ好友还是QQ空间）
 @param title 分享标题
 @param desc 分享描述
 @param image 分享图片
 */
+ (void)qqShareImageWithScene:(int)scene title:(NSString *)title desc:(NSString *)desc image:(UIImage *)image;

//登录

@end
