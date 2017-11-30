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

#import "WXApi.h"
#import "TLWXManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //服务器环境
    [self configServiceAddress];
    
    //初始化IMAPlatform
    [self initIMAPlatform];
    
    //配置微信
    [self configWeChat];
    
    //配置根控制器
    [self configRootViewController];

    return YES;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Config
- (void)configServiceAddress {
    
    //配置环境
    [AppConfig config].runEnv = RunEnvTest;
}

- (void)configWeChat {
    
    [[TLWXManager manager] registerApp];
}

- (void)configRootViewController {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //
    TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
    self.window.rootViewController = tabBarCtrl;
    
    //重新登录
    if([TLUser user].isLogin) {
        
        [[TLUser user] reLogin];
        
    };
    
}

- (void)initIMAPlatform {
    
    [IMAPlatform configWith:nil];
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
