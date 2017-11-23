//
//  IMAAppDelegate.m
//  TIMChat
//
//  Created by AlexiChen on 16/2/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAAppDelegate.h"
#import "TLNavigationController.h"
#import "TLUserLoginVC.h"

@implementation IMAAppDelegate

void uncaughtExceptionHandler(NSException*exception){
    DebugLog(@"CRASH: %@", exception);
    DebugLog(@"Stack Trace: %@",[exception callStackSymbols]);
}

- (void)configAppLaunch
{
    [super configAppLaunch];
//    [[IMAPlatform sharedInstance] configOnAppLaunch];
}



- (void)applicationDidEnterBackground:(UIApplication *)application
{
    __block UIBackgroundTaskIdentifier bgTaskID;
    bgTaskID = [application beginBackgroundTaskWithExpirationHandler:^ {
        
        //不管有没有完成，结束background_task任务
        [application endBackgroundTask: bgTaskID];
        bgTaskID = UIBackgroundTaskInvalid;
    }];
    
    [[IMAPlatform sharedInstance] configOnAppEnterBackground];
    

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[IMAPlatform sharedInstance] configOnAppEnterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[IMAPlatform sharedInstance] configOnAppDidBecomeActive];
}


-(void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[IMAPlatform sharedInstance] configOnAppRegistAPNSWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    DebugLog(@"didFailToRegisterForRemoteNotificationsWithError:%@", error.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // 处理推送消息
    DebugLog(@"userinfo:%@",userInfo);
    DebugLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
}


// 进入登录界面
// 用户可重写
- (void)enterLoginUI
{
    TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];

    [self presentViewController:loginVC animated:YES completion:nil];
}


//==================================
// URL Scheme处理
//- (BOOL)application:(UIApplication*)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    if ([url.scheme compare:QQ_OPEN_SCHEMA] == NSOrderedSame)
//    {
//        return [TencentOAuth HandleOpenURL:url];
//    }
//    else if([url.scheme compare:WX_APP_ID] == NSOrderedSame)
//    {
//        if ([self.window.rootViewController conformsToProtocol:@protocol(WXApiDelegate)])
//        {
//            id<WXApiDelegate> lgv = (id<WXApiDelegate>)self.window.rootViewController;
//            [WXApi handleOpenURL:url delegate:lgv];
//
//        }
//    }
//
//    return YES;
//}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    if ([url.scheme compare:QQ_OPEN_SCHEMA] == NSOrderedSame)
//    {
////        return [TencentOAuth HandleOpenURL:url];
//    }
//    else if([url.scheme compare:WX_APP_ID] == NSOrderedSame)
//    {
//        if ([self.window.rootViewController conformsToProtocol:@protocol(WXApiDelegate)])
//        {
//            id<WXApiDelegate> lgv = (id<WXApiDelegate>)self.window.rootViewController;
//            [WXApi handleOpenURL:url delegate:lgv];
//        }
//    }
//
//    return YES;
//}



@end
