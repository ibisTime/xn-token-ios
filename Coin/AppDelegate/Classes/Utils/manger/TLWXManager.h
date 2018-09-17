//
//  TLWXManager.h
//  ZHCustomer
//
//  Created by  蔡卓越 on 2017/1/9.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"

@interface TLWXManager : NSObject<WXApiDelegate>

@property (nonatomic, copy) void(^wxPay)(BOOL isSuccess,int errorCode);
@property (nonatomic, copy) void(^wxShare)(BOOL isSuccess,int errorCode);

+ (instancetype)manager;
+ (BOOL)judgeAndHintInstalllWX;

- (void)registerApp;
//分享网页
+ (void)wxShareWebPageWithScene:(int)scene title:(NSString *)title desc:(NSString *)desc url:(NSString *)url;
//分享图片
+ (void)wxShareImageWithScene:(int)scene title:(NSString *)title desc:(NSString *)desc image:(UIImage *)image;

+ (void)wxShareWebPageWith:(NSString *)title desc:(NSString *)desc url:(NSString *)url;

@end
