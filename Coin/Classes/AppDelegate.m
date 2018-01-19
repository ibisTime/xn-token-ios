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
#import "TLNetworking.h"
#import "UITabBar+Badge.h"
#import "AppConfig.h"
#import "IMALoginParam.h"
#import "WXApi.h"
#import "TLWXManager.h"
#import "TLAlipayManager.h"
#import "ChatManager.h"
#import "ChatViewController.h"
#import <IQKeyboardManager.h>
#import "RichChatViewController.h"
#import "OrderDetailVC.h"
#import "WaitingOrderVC.h"
#import "ZMChineseConvert.h"
#import "SettingModel.h"
#import "TLUpdateVC.h"
#import <ZendeskSDK/ZendeskSDK.h>
//#import "ZDKConfig.h"
#import "LangSwitcher.h"
#import <ZDCChat/ZDCChat.h>
#import "CoinUtil.h"
#import "TLPublishVC.h"
#import "RespHandler.h"
#import <NBHTTP/NBNetwork.h>
#import "TIMElemBaseTableViewCell.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#import "TLPublishInputView.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (nonatomic, strong) FBKVOController *chatKVOCtrl;
@property (nonatomic, strong) RespHandler *respHandler;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //服务器环境
    [AppConfig config].runEnv = RunEnvDev;
    self.respHandler = [[RespHandler alloc] init];
    
    [NBNetworkConfig config].respDelegate = self.respHandler;
    //2.新版本请求
    [NBNetworkConfig config].baseUrl = [AppConfig config].apiUrl;
    
    //配置微信
    [self configWeChat];
    
    //配置键盘
    [self configIQKeyboard];
    
    //配置根控制器
    [self configRootViewController];
    
    //初始化, 连天
    [[ChatManager sharedManager] initChat];
    
    //
    [self configZendesk];
    
    //初始化为繁体
    [LangSwitcher startWithTraditional];

    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginOut)
                                                 name:kUserLoginOutNotification
                                               object:nil];
    //消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLogin) name:kUserLoginNotification
                                               object:nil];
    
    //重新登录
    if([TLUser user].isLogin) {
        
        [[TLUser user] updateUserInfo];
        // 登录时间变更到，didBecomeActive中
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification
                                                            object:nil];
        
    };
    
   
    
    [[IMAPlatform sharedInstance] configOnAppLaunchWithOptions:launchOptions];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
    });
    
    //
    return YES;
    
    
}



//- (void)jpushTest:(NSDictionary *)launchOptions {
//
//
//    //Required
//    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
//    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
//    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
//
//    //
//    [JPUSHService setupWithOption:launchOptions
//                           appKey:@"d3824383346cd157a8976eb6"
//                          channel:@"iOS"
//                 apsForProduction:YES
//            advertisingIdentifier:nil];
//
//
//}




// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
//    // Required
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
//}

// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//    // Required
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler();  // 系统要求执行这个方法
//}

#pragma mark- 上传推送 token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {


    [[IMAPlatform sharedInstance] configOnAppRegistAPNSWithDeviceToken:deviceToken];

}

// 用户重新登录需要重新，需要重新调用此方法监听
- (void)kvoUnReadMsgToChangeTabbar {
    
    //这里监听主要是为了，tabbar上的消息提示, 和icon上的图标
    // 此处有坑， [IMAPlatform sharedInstance].conversationMgr 切换账户是会销毁
    self.chatKVOCtrl = [FBKVOController controllerWithObserver:self];
    [self.chatKVOCtrl observe:[IMAPlatform sharedInstance].conversationMgr
                        keyPath:@"unReadMessageCount"
                        options:NSKeyValueObservingOptionNew
                          block:^(id observer, id object, NSDictionary *change) {
                             
                              NSInteger count =  [IMAPlatform sharedInstance].conversationMgr.unReadMessageCount;
                              
                              int location = 1;
                              if (count > 0) {
                                  
                                  [[self rootTabBarController].tabBar showBadgeOnItemIndex:location];
//                                  [UIApplication sharedApplication].applicationIconBadgeNumber = count;
                                  
                              } else {
                                  
                                  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                                  [[self rootTabBarController].tabBar hideBadgeOnItemIndex:location];

                              }
                             
                          }];
    
}



#pragma mark- 退出登录
- (void)loginOut {
    
    //user 退出
    [[TLUser user] loginOut];
    
    //退出登录
    [[IMAPlatform sharedInstance] logout:^{
        
        
    } fail:^(int code, NSString *msg) {
        
        
    }];

    //
    UITabBarController *tabbarContrl = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabbarContrl.selectedIndex = 0;
    [tabbarContrl.tabBar hideBadgeOnItemIndex:1];
    //应用外数量为0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}

- (void)configZendesk {
    
    // supprot
    [[ZDKConfig instance] initializeWithAppId:@"f9ab448e1dfdb93e3b4ff1f2c2d4fb3a72140cbfd6ee10e0"
                 zendeskUrl:@"https://beicoin.zendesk.com"
                   clientId:@"mobile_sdk_client_b388fa777945f99314b7"];
    
    // 客服
    [ZDCChat initializeWithAccountKey:@"MvxwoT6827HylJtr6360QQQ5yve4Z2Ny"];

}

#pragma mark - 用户登录
- (void)userLogin {
    
    
    //zendesk
    ZDKAnonymousIdentity *identity = [ZDKAnonymousIdentity new];
    identity.name = [TLUser user].nickname;
    identity.email = [NSString stringWithFormat:@"%@",[TLUser user].email];
    [ZDKConfig instance].userIdentity = identity;
    
    // 重新登录的时候要重新，配置一下
    [self kvoUnReadMsgToChangeTabbar];
    [[ChatManager sharedManager] loginIM];
    
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

    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[RichChatViewController class]];

}

- (void)configRootViewController {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
     
    //先配置到，检查更新的VC
    if (0) {
        
        TLUpdateVC *updateVC = [[TLUpdateVC alloc] init];
        self.window.rootViewController = updateVC;

    } else {
        
        //检查更新过后再
        TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
        self.window.rootViewController = tabBarCtrl;
        
    }
    
}

//- (void)pushToChatViewControllerWith:(IMAUser *)user {
//    
//    TLTabBarController *tab = (TLTabBarController *)self.window.rootViewController;
//    [tab pushToChatViewControllerWith:user];
//    
//}

+ (id)sharedAppDelegate {
    
    return [UIApplication  sharedApplication ].delegate;
    
}

#pragma mark- 本地推送
//- (void)configLocalPushNotification {
//
//    // 创建分类，注意使用可变子类
//    UIMutableUserNotificationCategory *category = [UIMutableUserNotificationCategory new];
//    // 设置标识符，注意与发送通知设置的category标识符一致~！
//    category.identifier = @"category";
//    // 设置按钮，注意使用可变子类UIMutableUserNotificationAction
//    // 设置前台按钮，点击后能使程序回到前台的叫做前台按钮
//    UIMutableUserNotificationAction *action1 = [UIMutableUserNotificationAction new];
//    action1.identifier = @"qiantai";
//    action1.activationMode = UIUserNotificationActivationModeForeground;
//    // 设置按钮的标题，即按钮显示的文字
//    action1.title = @"呵呵";
//
//    // 设置后台按钮，点击后程序还在后台执行，如QQ的消息
//    UIMutableUserNotificationAction *action2 = [UIMutableUserNotificationAction new];
//    action2.identifier = @"houtai";
//    action2.activationMode = UIUserNotificationActivationModeBackground;
//    // 设置按钮的标题，即按钮显示的文字
//    action1.title = @"后台呵呵";
//    // 给分类设置按钮
//    [category setActions:@[action1,action2] forContext:UIUserNotificationActionContextDefault];
//
//    // 注册，请求授权的时候将分类设置给授权，注意是 NSSet 集合
//    NSSet *categorySet = [NSSet setWithObject:category];
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:categorySet];
//    // 注册通知
//    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//
//
//}


#pragma mark - 微信和芝麻认证回调
// iOS9 NS_AVAILABLE_IOS
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if ([url.host isEqualToString:@"certi.back"]) {
        
        //查询是否认证成功
        TLNetworking *http = [TLNetworking new];
        http.showView = [UIApplication sharedApplication].keyWindow;
        http.code = @"805196";
        http.parameters[@"bizNo"] = [TLUser user].tempBizNo;
        http.parameters[@"userId"] = [TLUser user].userId;
        [http postWithSuccess:^(id responseObject) {
            
            NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"isSuccess"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthResult" object:str];
            
        } failure:^(NSError *error) {
            
            
        }];
        
        return YES;
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        
        [TLAlipayManager hadleCallBackWithUrl:url];
        return YES;
        
    } else {
        
        return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];
    }
}

#pragma mark- 应用进入前台，改变登录时间
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if([TLUser user].isLogin) {

      [[TLUser user] changLoginTime];
      [[IMAPlatform sharedInstance] configOnAppDidBecomeActive];

    };
    
}

#pragma mark- 应用切后台
- (void)applicationDidEnterBackground:(UIApplication *)application  {
    
    __block UIBackgroundTaskIdentifier bgTaskID;
    bgTaskID = [application beginBackgroundTaskWithExpirationHandler:^ {
        
        //不管有没有完成，结束background_task任务
        [application endBackgroundTask: bgTaskID];
        bgTaskID = UIBackgroundTaskInvalid;
    }];
    
    
    if([[TLUser user] checkLogin]) {
        
        [[IMAPlatform sharedInstance] configOnAppEnterBackground];
        
    }
    
}

#pragma mark- 应用切前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    if([[TLUser user] checkLogin]) {

        [[IMAPlatform sharedInstance] configOnAppEnterForeground];
        
    }
    
}



@end
