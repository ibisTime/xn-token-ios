//
//  IMAPlatform+AppConfig.m
//  TIMChat
//
//  Created by AlexiChen on 16/2/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAPlatform+AppConfig.h"
#import <UserNotifications/UserNotifications.h>
#import "AppConfig.h"
#import "TLUser.h"

@implementation IMAPlatform (AppConfig)

// app 启动时配置
- (void)configOnAppLaunchWithOptions:(NSDictionary *)launchOptions
{
    // TODO:大部份在IMAPlatform创建的时候处理了，此处添加额外处理，用户自行添加
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(  UNAuthorizationOptionAlert
                                                 | UNAuthorizationOptionBadge
                                                 | UNAuthorizationOptionSound)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    
//                    NSLog(@"%@", settings);
                    
                }];
                //
            } else {
                // 点击不允许
                NSLog(@"注册失败");
            }
        }];
        
#endif
        
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    } else {
        //
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
        
    }
    


    
}

// app 进入后台时配置
- (void)configOnAppEnterBackground
{
    
    // 将相关的配置缓存至本地
    [[IMAPlatform sharedInstance] saveToLocal];
    
    NSUInteger unReadCount = [[IMAPlatform sharedInstance].conversationMgr unReadMessageCount];
    [UIApplication sharedApplication].applicationIconBadgeNumber = unReadCount;
    
    TIMBackgroundParam  *param = [[TIMBackgroundParam alloc] init];
//    [param setC2cUnread:(int)unReadCount];
    [param setGroupUnread:(int)unReadCount];
    
    [[TIMManager sharedInstance] doBackground:param succ:^() {
        DebugLog(@"doBackgroud Succ");
    } fail:^(int code, NSString * err) {
        DebugLog(@"Fail: %d->%@", code, err);
    }];
}

// app 进前台时配置
- (void)configOnAppEnterForeground
{
    [UIApplication.sharedApplication.windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *w, NSUInteger idx, BOOL *stop) {
        if (!w.opaque && [NSStringFromClass(w.class) hasPrefix:@"UIText"]) {
            // The keyboard sometimes disables interaction. This brings it back to normal.
            BOOL wasHidden = w.hidden;
            w.hidden = YES;
            w.hidden = wasHidden;
            *stop = YES;
        }
    }];
    
    //消息栏消息数
    NSInteger unReadCount = [[IMAPlatform sharedInstance].conversationMgr unReadMessageCount];

//    [TLUser user].unReadMsgCount = unReadCount;
    
    //清空通知栏消息
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

// app become active
- (void)configOnAppDidBecomeActive {
    
//    [[IMAPlatform sharedInstance] ];
    [[TIMManager sharedInstance] doForeground:^{
        
    } fail:^(int code, NSString *msg) {
        
    }];
}

// app 注册APNS成功后
- (void)configOnAppRegistAPNSWithDeviceToken:(NSData *)deviceToken
{
    DebugLog(@"didRegisterForRemoteNotificationsWithDeviceToken:%ld", (unsigned long)deviceToken.length);
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    [[TIMManager sharedInstance] log:TIM_LOG_INFO tag:@"SetToken" msg:[NSString stringWithFormat:@"My Token is :%@", token]];
    TIMTokenParam *param = [[TIMTokenParam alloc] init];

    if ( [AppConfig config].runEnv == RunEnvDev ||
         [AppConfig config].runEnv == RunEnvTest ) {
        
        param.busiId = 6890;

    } else {
        
        param.busiId =  6898;

    }

    
    [param setToken:deviceToken];
    
    //需要在登录之后，在进行token设置
    [[TIMManager sharedInstance] setToken:param succ:^{
       
//        NSLog(@"-----> 上传token成功 ");
    } fail:^(int code, NSString *msg) {
//        NSLog(@"-----> 上传token失败 ");
    }];
    
    TIMAPNSConfig *config = [[TIMAPNSConfig alloc] init];
    [config setOpenPush:1];
    [[TIMManager sharedInstance] setAPNS:config succ:^{
        
        
    } fail:^(int code, NSString *msg) {
        
    }];
    
    //
//    [[TIMManager sharedInstance] getAPNSConfig:^(TIMAPNSConfig *config) {
//
//
//    } fail:^(int code, NSString *msg) {
//
//
//    }];

}

#pragma mark - UNUserNotificationCenterDelegate
// iOS 10收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
    } else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// 通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)())completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        
    } else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    // Warning: UNUserNotificationCenter delegate received call to -userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: but the completion handler was never called.
    completionHandler();  // 系统要求执行这个方法
    
}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    
    return str;
}


@end
