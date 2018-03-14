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
#import "WXApi.h"
#import "TLWXManager.h"
#import "TLAlipayManager.h"
#import <IQKeyboardManager.h>
#import "ZMChineseConvert.h"
#import "SettingModel.h"
#import "TLUpdateVC.h"
#import <ZendeskSDK/ZendeskSDK.h>
//#import "ZDKConfig.h"
#import "LangSwitcher.h"
#import <ZDCChat/ZDCChat.h>
#import "CoinUtil.h"
#import "RespHandler.h"
#import "TLNavigationController.h"
#import "TLUserLoginVC.h"
#import <NBHTTP/NBNetwork.h>

@interface AppDelegate ()

@property (nonatomic, strong) RespHandler *respHandler;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //服务器环境
    [AppConfig config].runEnv = RunEnvDev;
//    [AppConfig config].isUploadCheck = YES;
    self.respHandler = [[RespHandler alloc] init];
     
    [NBNetworkConfig config].respDelegate = self.respHandler;
    //2.新版本请求
    [NBNetworkConfig config].baseUrl = [AppConfig config].apiUrl;
    
    //配置微信
//    [self configWeChat];
    
    //配置键盘
    [self configIQKeyboard];
    
    //配置根控制器
    [self configRootViewController];
    
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
        
    } else {
        TLUserLoginVC *loginVC = [TLUserLoginVC new];
        
        TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
        
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    };
    
    //
    return YES;
    
    
}

#pragma mark- 上传推送 token

#pragma mark- 退出登录
- (void)loginOut {
    
    //user 退出
    [[TLUser user] loginOut];

    TLUserLoginVC *loginVC = [TLUserLoginVC new];
    
    TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
    
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
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
    //获取七牛云域名
    [[TLUser user] requestQiniuDomain];
    //zendesk
//    ZDKAnonymousIdentity *identity = [ZDKAnonymousIdentity new];
//    identity.name = [TLUser user].nickname;
//    identity.email = [NSString stringWithFormat:@"%@",[TLUser user].email];
//    [ZDKConfig instance].userIdentity = identity;
    
    // 重新登录的时候要重新，配置一下
//    [self kvoUnReadMsgToChangeTabbar];
//    [[ChatManager sharedManager] loginIM];
    
}

- (UITabBarController *)rootTabBarController {
    
    id obj = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([obj isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabBarController = (UITabBarController *)obj;
        return tabBarController;
        
    } else {
        
        return nil;
    }

}


- (void)configWeChat {
    
    [[TLWXManager manager] registerApp];
}

- (void)configIQKeyboard {
    

}

- (void)configRootViewController {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if (0) {
        //先配置到，检查更新的VC,开启更新检查
        TLUpdateVC *updateVC = [[TLUpdateVC alloc] init];
        self.window.rootViewController = updateVC;

    } else {
        
        //检查更新过后再
        TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
        self.window.rootViewController = tabBarCtrl;
        
    }
    
}

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
}

@end
