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

@interface AppDelegate ()

@property (nonatomic, strong) FBKVOController *chatKVOCtrl;
@property (nonatomic, copy) NSArray *cpArr;

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
    
    //初始化, 连天
    [[ChatManager sharedManager] initChat];

    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
    //消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kUserLoginNotification object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imLogin) name:kIMLoginNotification object:nil];
    
    //重新登录
    if([TLUser user].isLogin) {
        
        [[TLUser user] updateUserInfo];
        // 登录时间变更到，didBecomeActive中
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
        
    };
    return YES;
    
}

// 用户重新登录需要重新，需要重新调用此方法监听
- (void)kvoUnReadMsgToChangeTabbar {
    
    //这里监听主要是为了，tabbar上的消息提示
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

                              } else {
                                  
                                  [[self rootTabBarController].tabBar hideBadgeOnItemIndex:location];

                              }
                             
                          }];
    
}

// - - //
- (void)imLogin {
    
    
}

#pragma mark- 退出登录
- (void)loginOut {
    
    //user 退出
    [[TLUser user] loginOut];
    
    //im 退出
    [[IMAPlatform sharedInstance] logout:^{
       
      //
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

    //
    //先配置到，检查更新的VC
    if (1) {
        
        TLUpdateVC *updateVC = [[TLUpdateVC alloc] init];
        self.window.rootViewController = updateVC;

    } else {
        
        //检查更新过后再
        TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
        self.window.rootViewController = tabBarCtrl;
        
    }
    
}

- (void)pushToChatViewControllerWith:(IMAUser *)user {
    
    TLTabBarController *tab = (TLTabBarController *)self.window.rootViewController;
    [tab pushToChatViewControllerWith:user];
    
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
    
    if([TLUser user].isLogin) {

      [[TLUser user] changLoginTime];
        
    };
    
}

// iOS9 NS_DEPRECATED_IOS
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
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

@end
