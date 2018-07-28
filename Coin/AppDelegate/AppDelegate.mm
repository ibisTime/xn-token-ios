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
//#import "IMALoginParam.h"         czy
#import "WXApi.h"
#import "TLWXManager.h"
#import "TLAlipayManager.h"
//#import "ChatManager.h"           czy
//#import "ChatViewController.h"    czy
#import "IQKeyboardManager.h"
//#import "RichChatViewController.h"czy
//#import "OrderDetailVC.h"         czy
//#import "WaitingOrderVC.h"        czy
#import "ZMChineseConvert.h"
#import "SettingModel.h"
#import "TLUpdateVC.h"
#import <ZendeskSDK/ZendeskSDK.h>
//#import "ZDKConfig.h"
#import "LangSwitcher.h"
//#import <ZDCChat/ZDCChat.h>
#import "CoinUtil.h"
#import "RespHandler.h"
#import <NBHTTP/NBNetwork.h>
#import "CoinModel.h"
#import "BuildWalletMineVC.h"
#import "TLTabBarController.h"
#import <FMDB/FMDB.h>
#import "TLDataBase.h"
#import "TLUserLoginVC.h"
#import "ZLGestureLockViewController.h"
//#import "TLPublishInputView.h"      czy

@interface AppDelegate ()

//@property (nonatomic, strong) FBKVOController *chatKVOCtrl;   czy
@property (nonatomic, strong) RespHandler *respHandler;
@property (nonatomic ,copy) NSString *dataStr;
@property (nonatomic ,assign) BOOL IsEnterBack;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [NSThread sleepForTimeInterval:2];
    
    //服务器环境
    [AppConfig config].runEnv = RunEnvDev;
    [AppConfig config].isChecking = NO;
#warning  //pods 更新后会导致wan币转账失败
//    [AppConfig config].isUploadCheck = YES;
    self.respHandler = [[RespHandler alloc] init];
     
    [NBNetworkConfig config].respDelegate = self.respHandler;
    //2.新版本请求
    [NBNetworkConfig config].baseUrl = [AppConfig config].apiUrl;
    
    //配置键盘
    [self configIQKeyboard];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //UIStatusBarStyleLightContent状态栏字体白色 UIStatusBarStyleDefault黑色

    //配置根控制器
    [self configRootViewController];
    [LangSwitcher startWithTraditional];

    //初始化为繁体
    //初始化数据库
    
    ;
    if ([[TLDataBase sharedManager].dataBase open]) {
//        [ [TLDataBase sharedManager].dataBase executeUpdate:@"UPDATE THAWallet SET userId='China'"];

        NSLog(@"数据库打开成功");
    }

    //退出登录消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginOut)
                                                 name:kUserLoginOutNotification
                                               object:nil];
    //用户登录消息通知
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
    
   
    
//czy    [[IMAPlatform sharedInstance] configOnAppLaunchWithOptions:launchOptions];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
    });
    
    //
    return YES;
    
    
}

#pragma mark- 上传推送 token
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//
//czy
//    [[IMAPlatform sharedInstance] configOnAppRegistAPNSWithDeviceToken:deviceToken];
//
//}



// 用户重新登录需要重新，需要重新调用此方法监听czy
//- (void)kvoUnReadMsgToChangeTabbar {
//
//    //这里监听主要是为了，tabbar上的消息提示, 和icon上的图标
//    // 此处有坑， [IMAPlatform sharedInstance].conversationMgr 切换账户是会销毁
//    self.chatKVOCtrl = [FBKVOController controllerWithObserver:self];
//    [self.chatKVOCtrl observe:[IMAPlatform sharedInstance].conversationMgr
//                        keyPath:@"unReadMessageCount"
//                        options:NSKeyValueObservingOptionNew
//                          block:^(id observer, id object, NSDictionary *change) {
//
//                              NSInteger count =  [IMAPlatform sharedInstance].conversationMgr.unReadMessageCount;
//
//                              int location = 4;
//                              if (count > 0) {
//
//                                  [[self rootTabBarController].tabBar showBadgeOnItemIndex:location];
//
//                              } else {
//
//                                  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//                                  [[self rootTabBarController].tabBar hideBadgeOnItemIndex:location];
//
//                              }
//
//                          }];
//
//}
//
//

#pragma mark- 退出登录
- (void)loginOut {
    //user 退出
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KWalletWord];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KWalletPrivateKey];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KWalletAddress];
    [[TLUser user] loginOut];
    
    //退出登录
//    [[IMAPlatform sharedInstance] logout:^{
//
//czy
//    } fail:^(int code, NSString *msg) {
//
//
//    }];

    //
    
    UITabBarController *tabbarContrl = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    if ([tabbarContrl isKindOfClass:[TLUpdateVC class]]) {
//        return;
//    }
    if ([tabbarContrl isKindOfClass:[TLNavigationController class]]) {
        return;
    }
    if ([tabbarContrl isKindOfClass:[BuildWalletMineVC class]]) {
        return;
    }
    TLTabBarController *tab = [[TLTabBarController alloc] init];
    
//    tabbarContrl.selectedIndex = 2;
//    [tabbarContrl.tabBar hideBadgeOnItemIndex:4];
    //应用外数量为0
    TLUserLoginVC *login = [TLUserLoginVC new];
    
//
    TLNavigationController *na = [[TLNavigationController alloc] initWithRootViewController:login];
    self.window.rootViewController = na;

    login.loginSuccess = ^{
        self.window.rootViewController = tab;

    };
//    TLTabBarController *tab = [TLTabBarController new];
//    [UIApplication sharedApplication].keyWindow.rootViewController = na;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}


#pragma mark - 用户登录
- (void)userLogin {
    
    
    //zendesk czy
//    ZDKAnonymousIdentity *identity = [ZDKAnonymousIdentity new];
//    identity.name = [TLUser user].nickname;
//    identity.email = [NSString stringWithFormat:@"%@",[TLUser user].email];
//    [ZDKConfig instance].userIdentity = identity;
//
//    // 重新登录的时候要重新，配置一下
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
    
//    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[OrderDetailVC class]];
// czy
//    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[WaitingOrderVC class]];
//
//    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[RichChatViewController class]];

}

- (void)configRootViewController {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
   
//    if (![AppConfig config].isChecking) {
//        //先配置到，检查更新的VC,开启更新检查
//        BuildWalletMineVC *MineVC = [[BuildWalletMineVC alloc] init];
//        TLNavigationController *na = [[TLNavigationController alloc] initWithRootViewController:MineVC];
//        NSString *name;
//        TLDataBase *db = [TLDataBase sharedManager];
//        if ([db.dataBase open]) {
//            FMResultSet *set = [db.dataBase executeQuery:@"SELECT Mnemonics from THAWallet"];
//            while ([set next])
//            {
//                name = [set stringForColumn:@"Mnemonics"];
//
//            }
//            [set close];
//
//        }
//
//        [db.dataBase close];
////        NSString *word = [[NSUserDefaults standardUserDefaults] objectForKey:KWalletWord];
//
//    }
        if (![AppConfig config].isChecking) {
            TLUpdateVC *updateVC = [[TLUpdateVC alloc] init];
            TLNavigationController *na = [[TLNavigationController alloc] initWithRootViewController:updateVC];
            na.isLanch = YES;
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLanch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if ([TLUser user].checkLogin == NO) {
                
            }
            self.window.rootViewController = updateVC;
        }else{
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
//czy      [[IMAPlatform sharedInstance] configOnAppDidBecomeActive];

    }
//    if (self.IsEnterBack == YES) {
//        if ([TLUser user].isLogin==NO) {
//            
//            TLUserLoginVC *login = [TLUserLoginVC new];
//            TLNavigationController *na = [[TLNavigationController alloc] initWithRootViewController:login];
//            self.IsEnterBack = NO;
//            login.IsAPPJoin = YES;
//            self.window.rootViewController = na;
//            
//        }
//    }
    
    
    
    if ([TLUser user].isLogin == YES) {
        //验证手势密码
        
      NSString *pwd =  [ZLGestureLockViewController gesturesPassword];
        if (!pwd) {
            return;
        }
        ZLGestureLockViewController *vc = [ZLGestureLockViewController new];
        vc.isCheck = YES;
        TLNavigationController *na = [[TLNavigationController alloc] initWithRootViewController:vc];
        BOOL isLanch  = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLanch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (isLanch == YES) {
            return;
        }
        self.window.rootViewController = na;
        
    }
    
    
}

#pragma mark- 应用切后台
- (void)applicationDidEnterBackground:(UIApplication *)application  {
    
    //
    self.IsEnterBack = YES;
    __block UIBackgroundTaskIdentifier bgTaskID;
    bgTaskID = [application beginBackgroundTaskWithExpirationHandler:^ {
        
        //不管有没有完成，结束background_task任务
        [application endBackgroundTask: bgTaskID];
        bgTaskID = UIBackgroundTaskInvalid;
    }];
    
    
//    if([[TLUser user] checkLogin]) {
//
//        [[IMAPlatform sharedInstance] configOnAppEnterBackground];
//
//    } czy
    
}

#pragma mark- 应用切前台
- (void)applicationWillEnterForeground:(UIApplication *)application {

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLanch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *) dataFilePath//应用程序的沙盒路径
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [path objectAtIndex:0];
    return[document stringByAppendingPathComponent:@"THAWallet.sqlite"];
}



- (void)createTable
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    FMDatabase *db = [FMDatabase databaseWithPath:_dataStr];
    if(![fileManager fileExistsAtPath:_dataStr]) {
        NSLog(@"还未创建数据库，现在正在创建数据库");
        if([db open]) {
            
            [db executeUpdate:@"create table if not exists THAWallet(userId text, Mnemonics text, wanAddress text,btcAddress text,ethAddress text,ethPrivate text,btcPrivate text,wanPrivate text)"];
            
            [db close];
        }else{
            NSLog(@"database open error");
        }
    }
    NSLog(@"FMDatabase:---------%@",db);
}

@end
