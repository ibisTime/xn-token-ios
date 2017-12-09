//
//  AppDelegate.m
//  Coin
//
//  Created by  tianlei on 2017/10/31.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AppDelegate.h"

#import "TLUIHeader.h"

#import "TLTabBarController.h"
#import "TLUser.h"

#import "UITabBar+Badge.h"

#import "AppConfig.h"
#import "IMALoginParam.h"
#import "WXApi.h"
#import "TLWXManager.h"
#import "ChatManager.h"

#import <IQKeyboardManager.h>

#import "OrderDetailVC.h"
//#import "CustomChatUIViewController.h"
#import "WaitingOrderVC.h"

@interface AppDelegate ()

@property (nonatomic, strong) FBKVOController *chatKVOCtrl;


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //服务器环境
    [AppConfig config].runEnv = RunEnvDev;
    
    //配置微信
    [self configWeChat];
    
    //配置键盘
    [self configIQKeyboard];
    
    //配置根控制器
    [self configRootViewController];
    
    //初始化 im
    [self configIM];
    [[ChatManager sharedManager] initChat];

   
    //重新登录
    if([TLUser user].isLogin) {
        
        [[TLUser user] reLogin];
        [[ChatManager sharedManager] loginIM];
        
    };
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
    //消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kIMLoginNotification object:nil];
    
    return YES;
    
}

- (void)configIM {
    
    //配置
    [[ChatManager sharedManager] loginIM];
    
    // 这里监听主要是为了，tabbar上的消息提示
    self.chatKVOCtrl = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:[IMAPlatform sharedInstance].conversationMgr
                        keyPath:@"unReadMessageCount"
                        options:NSKeyValueObservingOptionNew
                          block:^(id observer, id object, NSDictionary *change) {
                             
                              NSInteger count =  [IMAPlatform sharedInstance].conversationMgr.unReadMessageCount;
                              
                              int location = 1;
                              if (count > 0) {
                                  
                                  [[self rootTabBarController].tabBar showBadgeOnItemIndex:location];

                              } else {
                                  
                                  [[self rootTabBarController].tabBar hideBadgeOnItemIndex:location];

                              }
                             
                          }];
    
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
    [tabbarContrl.tabBar hideBadgeOnItemIndex:1];
//  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}

#pragma mark - 用户登录
- (void)userLogin {
    
    //获取消息总量
    NSInteger unReadMsgCount = [IMAPlatform sharedInstance].conversationMgr.unReadMessageCount;
    
    UITabBarController *tabBarController = [self rootTabBarController];

    if (unReadMsgCount > 0) {
        
        [tabBarController.tabBar showBadgeOnItemIndex:1];
        
    } else {
        
        [tabBarController.tabBar hideBadgeOnItemIndex:1];
        
    }
    
}

- (UITabBarController *)rootTabBarController {
    
    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    return tabBarController;
    
}


- (void)configWeChat {
    
    [[TLWXManager manager] registerApp];
}

- (void)configIQKeyboard {
    
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[OrderDetailVC class]];
    
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[WaitingOrderVC class]];

//    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[CustomChatUIViewController class]];

}

- (void)configRootViewController {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
    self.window.rootViewController = tabBarCtrl;
    
}

- (void)pushToChatViewControllerWith:(IMAUser *)user {
    
    TLTabBarController *tab = (TLTabBarController *)self.window.rootViewController;
    [tab pushToChatViewControllerWith:user];
    
}

+ (id)sharedAppDelegate {
    
    return [UIApplication  sharedApplication ].delegate;
    
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
