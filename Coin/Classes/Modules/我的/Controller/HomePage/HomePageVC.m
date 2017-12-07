//
//  HomePageVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/12/7.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "HomePageVC.h"

#import "HomePageHeaderView.h"

#import "AdvertiseModel.h"

#import "UILabel+Extension.h"

#import "TLUserLoginVC.h"
#import "TLNavigationController.h"

@interface HomePageVC ()

@property (nonatomic, strong) HomePageHeaderView *headerView;

@property (nonatomic, strong) AdvertiseModel *advertise;

@end

@implementation HomePageVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //头部
    [self initHeaderView];
    //查询用户的交易量
    [self queryTradeNum];
    //查询信任关系
    [self queryAdvertiseDetail];
}

#pragma mark - Init
- (void)initHeaderView {
    
    CoinWeakSelf;
    
    self.headerView = [[HomePageHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(14 + kNavigationBarHeight) + 250)];
    
    self.headerView.pageBlock = ^(HomePageType type) {
        
        [weakSelf homePageEventsWithType:type];
    };
    
    [self.view addSubview:self.headerView];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark - Events
- (void)homePageEventsWithType:(HomePageType)type {
    
    CoinWeakSelf;
    
    switch (type) {
        case HomePageTypeTrust:
        {
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
                
                TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
                
                loginVC.loginSuccess = ^(){
                    
                    [weakSelf homePageEventsWithType:HomePageTypeTrust];
                };
                
                [self presentViewController:nav animated:YES completion:nil];
                
                return;
            }
            
            [self trustUser];
            
        }break;
            
        case HomePageTypeCancelTrust:
        {
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
                
                TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
                
                loginVC.loginSuccess = ^(){
                    
                    [weakSelf homePageEventsWithType:HomePageTypeCancelTrust];
                };
                
                [self presentViewController:nav animated:YES completion:nil];
                
                return;
            }
            
            [self cancelTrustUser];
            
        }break;
            
        case HomePageTypeBlackList:
        {
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
                
                TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
                
                loginVC.loginSuccess = ^(){
                    
                    [weakSelf homePageEventsWithType:HomePageTypeBlackList];
                };
                
                [self presentViewController:nav animated:YES completion:nil];
                
                return;
            }
            
            [self addBlackList];
        };
            
        case HomePageTypeCancelBlackList:
        {
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
                
                TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
                
                loginVC.loginSuccess = ^(){
                    
                    [weakSelf homePageEventsWithType:HomePageTypeCancelBlackList];
                };
                
                [self presentViewController:nav animated:YES completion:nil];
                
                return;
            }
            
            [self cancelBlackList];
            
        }break;
            
        case HomePageTypeBack:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }break;
            
        default:
            break;
    }
}

- (void)trustUser {
    
    //0:黑名单 1:信任
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805110";
    http.showView = self.view;
    http.parameters[@"toUser"] = self.advertise.userId;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"信任成功"];
        
        [self queryAdvertiseDetail];
        
        [self.headerView.trustBtn setTitle:@"取消信任" forState:UIControlStateHighlighted];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kTrustNotification object:nil];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)cancelTrustUser {
    
    //0:黑名单 1:信任
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805111";
    http.showView = self.view;
    http.parameters[@"toUser"] = self.advertise.userId;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"type"] = @"1";

    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"取消信任成功"];
        
        [self queryAdvertiseDetail];
        
        [self.headerView.trustBtn setTitle:@"+ 信任" forState:UIControlStateHighlighted];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kTrustNotification object:nil];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)addBlackList {
    
    //0:黑名单 1:信任
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805110";
    http.showView = self.view;
    http.parameters[@"toUser"] = self.advertise.userId;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"type"] = @"0";
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"黑名单添加成功"];
        
        [self queryAdvertiseDetail];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)cancelBlackList {
    
    //0:黑名单 1:信任
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805111";
    http.showView = self.view;
    http.parameters[@"toUser"] = self.advertise.userId;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"type"] = @"0";
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"取消黑名单成功"];
        
        [self queryAdvertiseDetail];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Data
- (void)queryTradeNum {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625255";
    http.parameters[@"userId"] = self.userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *text = @"历史交易";
        
        NSString *numStr = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"totalTradeCount"]];
        
        NSString *realNum = [numStr convertToSimpleRealCoin];
        
        CGFloat historyNum = [[realNum convertToRealMoneyWithNum:8] doubleValue];
        
        //判断个数
        NSString *history = @"";
        
        if (historyNum == 0) {
            
            history = @"0 ETH";
            
        } else if (historyNum > 0 && historyNum <= 0.5) {
            
            history = @"0-0.5 ETH";
            
        } else if (historyNum > 0.5 && historyNum <= 1) {
            
            history = [NSString stringWithFormat:@"0.5-1 ETH"];
            
        } else if (historyNum > 1) {
            
            history = [NSString stringWithFormat:@"%.0lf+ ETH", historyNum];
        }
        
        //历史交易
        UILabel *lbl = [self.headerView viewWithTag:1403];
        
        [lbl labelWithString:[NSString stringWithFormat:@"%@\n%@", history, text] title:text font:Font(12.0) color:kTextColor2 lineSpace:5];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)queryAdvertiseDetail {
    
    CoinWeakSelf;
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625226";
    
    http.parameters[@"adsCode"] = self.advCode;
    
    if ([TLUser user].isLogin) {
        
        http.parameters[@"userId"] = [TLUser user].userId;
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        self.advertise = [AdvertiseModel tl_objectWithDictionary:responseObject[@"data"]];
        
        weakSelf.headerView.advertise = self.advertise;
        
        weakSelf.headerView.isTrust = [self.advertise.isTrust integerValue] == 0 ? NO: YES;
        
        weakSelf.headerView.isBlack = [self.advertise.isBlackList integerValue] == 0 ? NO: YES;
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
