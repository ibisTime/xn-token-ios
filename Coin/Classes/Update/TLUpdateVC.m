//
//  TLUpdateVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/8/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLUpdateVC.h"
#import "TLNetworking.h"
#import "TLProgressHUD.h"
#import "AppConfig.h"
#import "GengXinModel.h"
#import "TLTabBarController.h"
#import "AppConfig.h"
#import "BuildWalletMineVC.h"
#import "TLUserLoginVC.h"
@interface TLUpdateVC ()

@end

@implementation TLUpdateVC


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
//    [self updateApp];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgIV];
    bgIV.contentMode = UIViewContentModeScaleAspectFill;
    
    bgIV.image = [UIImage imageNamed:@"Launch"];
    [self setPlaceholderViewTitle:[LangSwitcher switchLang:@"加载失败" key:nil] operationTitle:[LangSwitcher switchLang:@"加载失败" key:nil]];

//    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    // 由于无法通过，审核。如果为强制更新
    [self configUpdate];
}

- (void)applicationWillEnterForeground {

//    [self updateApp];
    [self configUpdate];

}

- (void)updateApp {
    
    NSString *appId = @"1264435742"; //test
//    NSString *appId = @"1321457016";
    //
    [TLProgressHUD showWithStatus:nil];
    //获取版本
    [TLNetworking GET:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appId]
           parameters:nil
              success:^(NSString *msg, id data) {
        
        [TLProgressHUD dismiss];
        [self removePlaceholderView];
        
        NSDictionary *resutltDict = data;
//#warning 这种判断只适用于，第一次审核。审核通过之后，第二次提交审核这种判断要改掉
////        // !!!!! 这种判断
////        //1.1在审核中
//        if ([resutltDict[@"resultCount"] isEqual:@0]) {
//
//          [AppConfig config].isChecking = true;
//          [self setRootVC];
//           return;
//        }
//
//        //审核通过
//        [AppConfig config].isChecking = false;
//        [self setRootVC];

        // CFBundleVersion 构建版本号
        // CFBundleShortVersionString
        // CFBundleDisplayName
        
        // 本地版本
        NSString *currentBuildVersion = [self version];

        //线上版本
        NSString *onlineBuildVersion = resutltDict[@"results"][0][@"version"];

        //1.2在审核中
        if ([currentBuildVersion floatValue] > [onlineBuildVersion floatValue]) {

            [self setRootVC];
            return;
        }

        //2.2 用户正常使用
      [self configUpdate];
 
    } abnormality:nil failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];
        [self addPlaceholderView];
        
    }];
    
    

}



- (void)tl_placeholderOperation {

//    [self updateApp];
    [self configUpdate];

}

- (NSString *)version {
    
   return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
}

//#pragma mark - Config
- (void)configUpdate {

    //1:iOS 2:安卓
    TLNetworking *http = [[TLNetworking alloc] init];

    http.code = @"660918";
    http.parameters[@"type"] = @"ios-c";

    [http postWithSuccess:^(id responseObject) {

        GengXinModel *update = [GengXinModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self removePlaceholderView];
        //获取当前版本号
        NSString *currentVersion = [self version];

        if (![currentVersion isEqualToString:update.version]) {

            if ([update.forceUpdate isEqualToString:@"0"]) {

                //不强制
                [TLAlert alertWithTitle:[LangSwitcher switchLang:@"更新提示" key:nil] msg:update.note confirmMsg:[LangSwitcher switchLang:@"立即升级" key:nil] cancleMsg:[LangSwitcher switchLang:@"稍后提醒" key:nil] cancle:^(UIAlertAction *action) {

                    [self setRootVC];

                } confirm:^(UIAlertAction *action) {

//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[update.xiaZaiUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
                      [self goBcoinWeb:update.downloadUrl];
                }];

            } else {

                //强制
                [TLAlert alertWithTitle:[LangSwitcher switchLang:@"更新提醒" key:nil] message:update.note confirmMsg:[LangSwitcher switchLang:@"立即升级" key:nil] confirmAction:^{

//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[update.xiaZaiUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
                    [self goBcoinWeb:update.downloadUrl];


                }];
            }
        } else {
            
            [self setRootVC];
            
        }

    } failure:^(NSError *error) {

        [self addPlaceholderView];
    }];

}

- (void)goBcoinWeb:(NSString *)var {
    
    NSString *urlStr = [var stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
      [[UIApplication sharedApplication] openURL:url];
}

- (void)setRootVC {
    
    //检查更新过后再
//    BuildWalletMineVC * mineVC = [[BuildWalletMineVC alloc] init];
    
    TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
//    TLNavigationController *na = [[TLNavigationController alloc] initWithRootViewController:mineVC];
    if( ![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [TLUserLoginVC new];
        
        loginVC.loginSuccess = ^{
            
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarCtrl;

        };
        CoinWeakSelf;
        loginVC.NeedLogin = YES;
        loginVC.loginFailed = ^{
            [weakSelf setRootVC];

        };
        
        TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];

        [self presentViewController:nav animated:YES completion:nil];
    }

    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarCtrl;

}



@end
