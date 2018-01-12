//
//  TLWXManager.h
//  ZHCustomer
//
//  Created by  蔡卓越 on 2017/1/9.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLWXManager : NSObject

+ (instancetype)manager;
+ (BOOL)judgeAndHintInstalllWX;

- (void)registerApp;

+ (void)wxShareWebPageWithScene:(int)scene title:(NSString *)title desc:(NSString *)desc url:(NSString *)url;

+ (void)wxShareWebPageWith:(NSString *)title desc:(NSString *)desc url:(NSString *)url;
@property (nonatomic, copy) void(^wxPay)(BOOL isSuccess,int errorCode);
@property (nonatomic, copy) void(^wxShare)(BOOL isSuccess,int errorCode);



/**
 分享图片到微信
 */
+ (void)wxShareImgWith:(NSString *)title scene:(int)scene desc:(NSString *)desc image:(UIImage *)img;


@end
