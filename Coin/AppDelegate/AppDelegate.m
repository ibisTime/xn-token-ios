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

#import "IQKeyboardManager.h"

#import "ZMChineseConvert.h"
#import "SettingModel.h"
#import "TLUpdateVC.h"

#import "LangSwitcher.h"
#import "RespHandler.h"
#import <NBHTTP/NBNetwork.h>
#import "CoinModel.h"
#import "BuildWalletMineVC.h"
#import "TLTabBarController.h"
#import <FMDB/FMDB.h>
#import "TLDataBase.h"
#import "TLUserLoginVC.h"
#import "ZLGestureLockViewController.h"
#import <UMMobClick/MobClick.h>
#import <ZendeskSDK/ZendeskSDK.h>
#import "TLWXManager.h"
#import <UMMobClick/MobClick.h>

#import "WXApi.h"
#import "IQKeyboardManager.h"
#import <ZendeskCoreSDK/ZendeskCoreSDK.h>
#import <ZendeskProviderSDK/ZendeskProviderSDK.h>
#import <WeiboSDK.h>
#import "NSBundle+Language.h"
#import "TheInitialVC.h"

@interface AppDelegate ()<WeiboSDKDelegate>

@property (nonatomic, strong) RespHandler *respHandler;
@property (nonatomic ,assign) BOOL IsEnterBack;
@property (nonatomic, strong) NSMutableArray <DataBaseModel *>*dataBaseModels;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //    [NSThread sleepForTimeInterval:2];
    


    //服务器环境7
//    研发
    [AppConfig config].runEnv = RunEnvDev;
//    测试
//    [AppConfig config].runEnv = RunEnvTest;
//    正式
//    [AppConfig config].runEnv = RunEnvRelease;

    [AppConfig config].isChecking = NO;
#warning  //pods 更新后会导致wan币转账失败
//    [AppConfig config].isUploadCheck = YES;
    self.respHandler = [[RespHandler alloc] init];
    
//    [MobClick profileSignInWithPUID:@"UserID"];
//    [MobClick profileSignInWithPUID:@"UserID" provider:@"WB"];
    [NBNetworkConfig config].respDelegate = self.respHandler;
    //2.新版本请求
    [NBNetworkConfig config].baseUrl = [AppConfig config].apiUrl;
    
    //    配置七牛地址
    [self GetSevenCattleAddress];
    //配置键盘
    [self configIQKeyboard];

    [[TLWXManager manager] registerApp];
    [WeiboSDK registerApp:@"947817370"];
    [WeiboSDK enableDebugMode:YES];

    [self configWeibo];

    //配置友盟统计
    [self configUManalytics];
    [self configZendSdk];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //UIStatusBarStyleLightContent状态栏字体白色 UIStatusBarStyleDefault黑色

    //配置根控制器
    [self configRootViewController];
    [LangSwitcher startWithTraditional];
    
    //初始化为繁体
    //初始化数据库
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
    

        
        
        [[TLUser user] updateUserInfo];
        // 登录时间变更到，didBecomeActive中
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification
                                                            object:nil];
        

    
   
    
//czy    [[IMAPlatform sharedInstance] configOnAppLaunchWithOptions:launchOptions];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//
//    });


    //
    return YES;
    
    
}


//获取七牛地址
-(void)GetSevenCattleAddress
{
    TLNetworking *http = [TLNetworking new];
    http.code = USER_CKEY_CVALUE;
    http.parameters[SYS_KEY] = @"qiniu_domain";
    [http postWithSuccess:^(id responseObject) {
        
        
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"http://%@", responseObject[@"data"][@"cvalue"]] forKey:Get_Seven_Cattle_Address];
        
        [AppConfig config].qiniuDomain = [NSString stringWithFormat:@"http://%@", responseObject[@"data"][@"cvalue"]];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)configWeibo
{
    
    
}

- (void)configZendSdk
{
//    [ ZDKCoreLogger  setEnabled :YES ];
//    [ ZDKCoreLogger  setLogLevel :ZDKLogLevelDebug ];
//    [ZDKZendesk initializeWithAppId: @"71d2ca9aba0cccc12deebfbdd352fbae8c53cd8999dd10bc"
//                           clientId: @"mobile_sdk_client_7af3526c83d0c1999bc3"
//                         zendeskUrl: @"https://thachainhelp.zendesk.com"];
//    id<ZDKObjCIdentity> userIdentity = [[ZDKObjCAnonymous alloc] initWithName:nil email:nil];
//    [[ZDKZendesk instance] setIdentity:userIdentity];8
//
//    [ZDKSupport initializeWithZendesk: [ZDKZendesk instance]];
    
//    [ZDKLocalization localizedStringWithKey:@"en"];
    // //hc/en-us
//    [ZDKSupport initializeWithZendesk: [ZDKZendesk instance]];
//                         zendeskUrl: @"https://hzcl.zendesk.com/hc/ko"];
//    ZDKRequest
  
}

- (void)configUManalytics
{
    
    @try{
//        UMConfigInstance.appKey = @"5b73d999f29d9825200001db";//研发
        UMConfigInstance.appKey = @"5b73b2e68f4a9d21830002fd";//正式

      //一般是这样写，用于友盟后台的渠道统计，当然苹果也不会有其他渠道，写死就好
        UMConfigInstance.channelId = @"Theia"; //渠道区分
//        UMConfigInstance.channelId = @"facebook"; //渠道区分
//        UMConfigInstance.channelId = @"biyongbao"; //渠道区分

        UMConfigInstance.ePolicy =SEND_INTERVAL; //上传模式，这种为最小间隔发送90S，也可按照要求选择其他上传模式。也可不设置，在友盟后台修改。
        [MobClick startWithConfigure:UMConfigInstance];//开启SDK
        
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleShortVersionString"];
        [MobClick setAppVersion:version];
//        [MobClick setLogEnabled:YES];
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }

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
    TheInitialVC *login = [TheInitialVC new];
    
//
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:login];
    self.window.rootViewController = na;

//    login.loginSuccess = ^{
//        self.window.rootViewController = tab;
//
//    };
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
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES; // 控制整个功能是否启用。
    manager.shouldResignOnTouchOutside =YES; // 控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor =YES; // 控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    manager.toolbarManageBehaviour =IQAutoToolbarByTag;

    


}

- (void)configRootViewController {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"BOOLFORKEY"] == NO)
//    {
////        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BOOLFORKEY"];
//        TheInitialVC *initialVC = [[TheInitialVC alloc] init];
//        UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:initialVC];
////        na.isLanch = YES;
//        self.window.rootViewController = na;
//    }else
//    {
    
    
    NSDictionary *dataDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_info_dict_key"];
    
        if ([TLUser isBlankString:dataDic[@"mobile"]] == YES) {
            TheInitialVC *initialVC = [[TheInitialVC alloc] init];
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:initialVC];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLanch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.window.rootViewController = na;
//            self.window.rootViewController = initialVC;
        }else{
            TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
            self.window.rootViewController = tabBarCtrl;
        }
//    }
    
    
    
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

        if ([url.host containsString:@"response"]) {
            [WeiboSDK handleOpenURL:url delegate:self];
            }
         else {
            
            return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];
        }
        
        return YES;

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
        [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        
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
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self ];
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        if(response.statusCode == WeiboSDKResponseStatusCodeSuccess){
//            [TLAlert alertWithSucces:[LangSwitcher switchLang:@"分享成功" key:nil]];
        }else{
//            [TLAlert alertWithSucces:[LangSwitcher switchLang:@"分享失败" key:nil]];

        }
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        
    }
    
}




@end
