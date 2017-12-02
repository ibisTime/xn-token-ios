//
//  AppDelegate.m
//  Coin
//
//  Created by  tianlei on 2017/10/31.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AppDelegate.h"

#import "TLTabBarController.h"
#import "TLUser.h"

#import "AppConfig.h"
#import "IMALoginParam.h"
#import "WXApi.h"
#import "TLWXManager.h"
#import "ChatManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //服务器环境
    [self configServiceAddress];
    
    //配置微信
    [self configWeChat];
    
    //配置根控制器
    [self configRootViewController];
    
    //初始化 im
    [IMAPlatform configWith:[[IMAPlatformConfig alloc] init]];
    
    //重新登录
    if([TLUser user].isLogin) {
        
        [[TLUser user] reLogin];
        [[ChatManager sharedManager] loginIM];
        
    };
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];


    return YES;
    
}

#pragma mark- 退出登录
- (void)loginOut {
    
    //user 退出
    [[TLUser user] loginOut];
    
    //im 退出
    [[IMAPlatform sharedInstance] logout:^{
        
    } fail:^(int code, NSString *msg) {
        
        
    }];
    //
    UITabBarController *tabbarContrl = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabbarContrl.selectedIndex = 0;
    
}



#pragma mark - Config
- (void)configServiceAddress {
    
    //配置环境
    [AppConfig config].runEnv = RunEnvDev;
    
}

- (void)configWeChat {
    
    [[TLWXManager manager] registerApp];
}

- (void)configRootViewController {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
    self.window.rootViewController = tabBarCtrl;
    
}



- (void)pushToChatViewControllerWith:(IMAUser *)user
{
    
    TLTabBarController *tab = (TLTabBarController *)self.window.rootViewController;
    [tab pushToChatViewControllerWith:user];
    
}

#pragma mark - 微信回调
// iOS9 NS_AVAILABLE_IOS
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];

}

// iOS9 NS_DEPRECATED_IOS
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];
    
}

@end
