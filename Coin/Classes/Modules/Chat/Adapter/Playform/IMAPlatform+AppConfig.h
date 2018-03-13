//
//  IMAPlatform+AppConfig.h
//  TIMChat
//
//  Created by AlexiChen on 16/2/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAPlatform.h"
#import <UserNotifications/UserNotifications.h>

// 与App配置相关的操作

@interface IMAPlatform (AppConfig)<UNUserNotificationCenterDelegate>

// app 启动时配置
- (void)configOnAppLaunchWithOptions:(NSDictionary *)launchOptions;

// app 进入后台时配置
- (void)configOnAppEnterBackground;

// app 进前台时配置
- (void)configOnAppEnterForeground;

// app become active
- (void)configOnAppDidBecomeActive;

// app 注册APNS成功后
- (void)configOnAppRegistAPNSWithDeviceToken:(NSData *)data;



@end
