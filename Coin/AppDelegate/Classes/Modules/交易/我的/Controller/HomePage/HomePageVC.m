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
#import "UserRelationModel.h"

#import "UILabel+Extension.h"

#import "TLUserLoginVC.h"
#import "TLNavigationController.h"
#import "APICodeMacro.h"
#import "CoinUtil.h"

@interface HomePageVC ()

@property (nonatomic, strong) HomePageHeaderView *headerView;
////广告
//@property (nonatomic, strong) AdvertiseModel *advertise;
//用户关系
@property (nonatomic, strong) UserRelationModel *relation;

@end

@implementation HomePageVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_coinModel) {
        _coinModel = [CoinUtil shouldDisplayCoinModelArray][0];
    }
    // Do any additional setup after loading the view.
    
    //头部
    [self initHeaderView];
    
    // 获取用户信息
    [self queryCurrentUserInfo];

    if ([TLUser user].userId) {
        
        if (![self.userId isEqualToString:[TLUser user].userId]) {
            
            //查询用户关系
            [self queryUserRelation];
        }
    }
}

- (void)queryCurrentUserInfo {
    
    TLNetworking *http = [TLNetworking new];
    http.code = USER_INFO;
    http.parameters[@"userId"] = self.userId;
    [http postWithSuccess:^(id responseObject) {
        
        UserInfo *currentUser = [UserInfo tl_objectWithDictionary:responseObject[@"data"]];
        self.headerView.currentUser = currentUser;
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark - Init
- (void)initHeaderView {
    
    CoinWeakSelf;
    
    self.headerView = [[HomePageHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(14 + kNavigationBarHeight) + 250)];
    
    self.headerView.pageBlock = ^(HomePageType type) {
        
        [weakSelf homePageEventsWithType:type];
    };
    
    self.headerView.userId = self.userId;
    
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
        }break;
            
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
    http.parameters[@"toUser"] = self.userId;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"信任成功" key:nil]];
        
        [self queryUserRelation];

        [[NSNotificationCenter defaultCenter] postNotificationName:kTrustNotification object:nil];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)cancelTrustUser {
    
    //0:黑名单 1:信任
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805111";
    http.showView = self.view;
    http.parameters[@"toUser"] = self.userId;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"type"] = @"1";

    [http postWithSuccess:^(id responseObject) {
        
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"取消信任成功" key:nil]];
        
        [self queryUserRelation];

        [[NSNotificationCenter defaultCenter] postNotificationName:kTrustNotification object:nil];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)addBlackList {
    
    //0:黑名单 1:信任
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805110";
    http.showView = self.view;
    http.parameters[@"toUser"] = self.userId;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"type"] = @"0";
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"黑名单添加成功" key:nil]];
        
        [self queryUserRelation];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)cancelBlackList {
    
    //0:黑名单 1:信任
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805111";
    http.showView = self.view;
    http.parameters[@"toUser"] = self.userId;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"type"] = @"0";
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"取消黑名单成功" key:nil]];
        
        [self queryUserRelation];

    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Data

//- (void)queryAdvertiseDetail {
//
//    CoinWeakSelf;
//
//    TLNetworking *http = [TLNetworking new];
//
//    http.code = @"625226";
//    http.showView = self.view;
//
//    http.parameters[@"adsCode"] = self.advCode;
//
//    if ([TLUser user].isLogin) {
//
//        http.parameters[@"userId"] = [TLUser user].userId;
//    }
//
//    [http postWithSuccess:^(id responseObject) {
//
//        self.advertise = [AdvertiseModel tl_objectWithDictionary:responseObject[@"data"]];
//
//        weakSelf.headerView.advertise = self.advertise;
//
//    } failure:^(NSError *error) {
//
//    }];
//}

- (void)queryUserRelation {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625256";
    http.showView = self.view;
    http.parameters[@"master"] = self.userId;
    http.parameters[@"visitor"] = [TLUser user].userId;
    http.parameters[@"currency"] = _coinModel.symbol;
    
    [http postWithSuccess:^(id responseObject) {
        UserRelationModel *userRelationModel = [UserRelationModel tl_objectWithDictionary:responseObject[@"data"]];
        [userRelationModel setCoinModel:_coinModel];
        self.headerView.relation = userRelationModel;
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
