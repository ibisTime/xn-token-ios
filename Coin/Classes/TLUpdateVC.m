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

@interface TLUpdateVC ()

@end

@implementation TLUpdateVC


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self updateApp];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgIV];
    bgIV.contentMode = UIViewContentModeScaleAspectFill;
    
    bgIV.image = [UIImage imageNamed:@"Launch"];
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)applicationWillEnterForeground {

    [self updateApp];

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
#warning 这种判断只适用于，第一次审核。审核通过之后，第二次提交审核这种判断要改掉
        // !!!!! 这种判断
        //1.1在审核中
        if ([resutltDict[@"resultCount"] isEqual:@0]) {

          [AppConfig config].isChecking = true;
          [self setRootVC];
           return;
        }
        
        //审核通过
        [AppConfig config].isChecking = false;
        [self setRootVC];

        // CFBundleVersion 构建版本号
        // CFBundleShortVersionString
        // CFBundleDisplayName
        
        // 本地版本
//        NSString *currentBuildVersion = [self buildVersion];
//
//        //线上版本
//        NSString *onlineBuildVersion = resutltDict[@"results"][0][@"version"];
//
//        //1.2在审核中
//        if ([currentBuildVersion floatValue] > [onlineBuildVersion floatValue]) {
//
//            [self setRootVC];
//            return;
//        }
        
        //2.2 用户正常使用
//      [self configUpdate];
 
    } abnormality:nil failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];
        [self addPlaceholderView];
        
    }];
    
    

}



- (void)tl_placeholderOperation {

    [self updateApp];

}

- (NSString *)buildVersion {
    
   return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
}

//#pragma mark - Config
- (void)configUpdate {

    //1:iOS 2:安卓
    TLNetworking *http = [[TLNetworking alloc] init];

    http.code = @"660918";
    http.parameters[@"type"] = @"ios-c";

    [http postWithSuccess:^(id responseObject) {

        GengXinModel *update = [GengXinModel mj_objectWithKeyValues:responseObject[@"data"]];

        //获取当前版本号
        NSString *currentVersion = [self buildVersion];

        if (![currentVersion isEqualToString:update.version]) {

            if ([update.forceUpdate isEqualToString:@"0"]) {

                //不强制
                [TLAlert alertWithTitle:@"更新提醒" msg:update.note confirmMsg:@"立即升级" cancleMsg:@"稍后提醒" cancle:^(UIAlertAction *action) {

                } confirm:^(UIAlertAction *action) {

                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[update.xiaZaiUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];

                }];

            } else {

                //强制
                [TLAlert alertWithTitle:@"更新提醒" message:update.note confirmMsg:@"立即升级" confirmAction:^{

                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[update.xiaZaiUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];

                }];
            }
        }

    } failure:^(NSError *error) {

    }];

}

- (void)setRootVC {
    
    //检查更新过后再
    TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarCtrl;


}



@end
