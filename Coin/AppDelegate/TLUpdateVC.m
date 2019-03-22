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
#import "CountryModel.h"
#import "ZLGestureLockViewController.h"
#import "NSString+Check.h"
@interface TLUpdateVC ()
{
    NSInteger select;
}
@property (nonatomic,strong) NSMutableArray <CountryModel *>*countrys;

@end

@implementation TLUpdateVC


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    if (select == 100) {
        TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarCtrl;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor];
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgIV];
    bgIV.contentMode = UIViewContentModeScaleAspectFill;
    
    bgIV.image = [UIImage imageNamed:@"Launch"];
    [self setPlaceholderViewTitle:[LangSwitcher switchLang:@"加载失败" key:nil] operationTitle:[LangSwitcher switchLang:@"加载失败" key:nil]];

    
    [self configUpdate];
    
//    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
//    BOOL isChoose = [[NSUserDefaults standardUserDefaults] boolForKey:@"chooseCoutry"];
//
//    if (isChoose == YES) {
//        [self configUpdate];
//
//    }else{
//
//        [self loadData];
//
//    }

    // 由于无法通过，审核。如果为强制更新
}



-(NSString *)getWANIP
{
    //通过淘宝的服务来定位WAN的IP，否则获取路由IP没什么用
    NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
    
    NSData *data = [NSData dataWithContentsOfURL:ipURL];
    if (data == nil) {
        return @"0086";
    }
    NSDictionary *ipDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]; 
    NSString *ipStr = nil;
    if (ipDic && [ipDic[@"code"] integerValue] == 0) { //获取成功
        ipStr = ipDic[@"data"][@"country_id"];
    }
    return (ipStr ? ipStr : @"");
    
}
- (void)loadData
{
    
//
//
//    TLNetworking *net = [TLNetworking new];
//    net.showView = self.view;
//    net.code = @"801120";
//    net.isLocal = YES;
//    net.ISparametArray = YES;
//    net.parameters[@"status"] = @"1";
//    [net postWithSuccess:^(id responseObject) {
//        self.countrys = [CountryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
////        self.countrys = [CountryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
//
////
//
//        for (int i = 0; i < self.countrys.count; i++) {
//
//            if ([dic isEqualToString:self.countrys[i].interSimpleCode]) {
//                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.countrys[i]];
//
//                [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"chooseModel"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
////
//                NSString *str = self.countrys[i].interSimpleCode;
//                if ([str isEqualToString:@"CN"] || [str hasPrefix:@"CN"]) {
//                    [LangSwitcher changLangType:LangTypeSimple];
//                }else if ([str isEqualToString:@"KR"])
//                {
//                    [LangSwitcher changLangType:LangTypeKorean];
//
//
//                }else{
//
//                    [LangSwitcher changLangType:LangTypeEnglish];
//
//                }
//
//            }else{
//
//                //
//                [LangSwitcher changLangType:LangTypeEnglish];
//
//            }
//
//
    
        [self configUpdate];

        
        //        for (int i = 0; i < self.countrys.count; i++) {
        //
        //            CountryModel *model = self.countrys[i];
        //            NSString *code =[TLUser user].interCode;
        //            if (code == model.interCode) {
        //                NSString *url = [model.pic convertImageUrl];
        //                [self.pic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kImage(@"中国国旗")];
        //                self.PhoneCode.text = [NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]];
        //            }
        //        }
        
        //        [self.tableView reloadData];
        //        NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"data"]];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthResult" object:str];
        
//
//    } failure:^(NSError *error) {
//
//        [self configUpdate];
//
    
    
    
}



- (void)applicationWillEnterForeground {

//    [self updateApp];
    //    [self updateApp];

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
        [self removePlaceholderView];
        //获取当前版本号
        NSString *currentVersion = [self version];

       
        if ([currentVersion integerValue] < [update.version integerValue]) {

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





- (void)setRootVC {
    
    //检查更新过后再
//    BuildWalletMineVC * mineVC = [[BuildWalletMineVC alloc] init];
    
    
//
//    if ([TLUser isBlankString:dataDic[@"userId"]] == YES) {
//        if ([TLUser isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:MNEMONIC]] == YES) {
//            TheInitialVC *initialVC = [[TheInitialVC alloc] init];
//            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:initialVC];
//
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLanch"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            self.window.rootViewController = na;
//        }else
//        {
//            TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
//            self.window.rootViewController = tabBarCtrl;
//        }
//
//    }else{
//        TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
//        self.window.rootViewController = tabBarCtrl;
    
    
    
    TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
//    TLNavigationController *na = [[TLNavigationController alloc] initWithRootViewController:mineVC];
    
    
    
    if([TLUser isBlankString:[TLUser user].userId] == YES) {
        
        
        if ([TLUser isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:MNEMONIC]] == YES) {
            TheInitialVC *initialVC = [[TheInitialVC alloc] init];
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:initialVC];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLanch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [UIApplication sharedApplication].keyWindow.rootViewController = na;
        }else
        {
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarCtrl;
        }
        return;
    }
    ZLGestureLockViewController *vc = [ZLGestureLockViewController new];
    vc.isCheck = YES;
    
    TLNavigationController *na = [[TLNavigationController alloc] initWithRootViewController:vc];
//    TLNavigationController *na = [[TLNavigationController alloc] initWithRootViewController:vc];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *word = [ZLGestureLockViewController gesturesPassword];
    if (word.length >0) {
        select = 100;
        [self presentViewController:na animated:YES completion:nil];

//
    }else{
        
        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarCtrl;

    }
}


//  本地更新
////  本地更新
 - (void)goBcoinWeb:(NSString *)var{
    
    NSString *urlStr = [var stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
     NSURL *url = [NSURL URLWithString:urlStr];
     [[UIApplication sharedApplication] openURL:url];
}


//  app storeapp store
//- (void)goBcoinWeb:(NSString *)var{
//   NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/m-help/id1436959010?mt=8"]];
//    [[UIApplication sharedApplication]openURL:url];


//}


@end
