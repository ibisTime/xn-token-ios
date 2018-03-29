//
//  HomeVC.m
//  OGC
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "HomeVC.h"

//M
#import "StoreModel.h"
#import "CountInfoModel.h"
//V
#import "StoreTableView.h"
#import "HomeHeaderView.h"
#import "TLProgressHUD.h"
//C
#import "TradeFlowListVC.h"
#import "StoreListVC.h"
#import "GoodMallVC.h"
#import "PosMiningVC.h"

@interface HomeVC ()
//头部
@property (nonatomic, strong) HomeHeaderView *headerView;
//
@property (nonatomic,strong) NSMutableArray <BannerModel *>*bannerRoom;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.title = [LangSwitcher switchLang:@"首页" key:nil];
    //获取banner列表
    [self requestBannerList];
    
}

#pragma mark - Init


- (HomeHeaderView *)headerView {
    
    if (!_headerView) {
        
        CoinWeakSelf;
        //头部
        _headerView = [[HomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(185) + 305)];
        
        _headerView.headerBlock = ^(HomeEventsType type, NSInteger index) {
            
            [weakSelf headerViewEventsWithType:type index:index];
        };
        
        [self.view addSubview:_headerView];
    }
    return _headerView;
}

#pragma mark - HeaderEvents
- (void)headerViewEventsWithType:(HomeEventsType)type index:(NSInteger)index {
    
    switch (type) {
            
        case HomeEventsTypeBanner:
        {
            
        }break;
            
        case HomeEventsTypeStatistics:
        {
            TradeFlowListVC *flowVC = [TradeFlowListVC new];
            
            [self.navigationController pushViewController:flowVC animated:YES];
            
        }break;
            
        case HomeEventsTypeStore:
        {
            StoreListVC *storeVC = [StoreListVC new];
            
            [self.navigationController pushViewController:storeVC animated:YES];
            
        }break;
            
        case HomeEventsTypeGoodMall:
        {
            GoodMallVC *mallVC = [GoodMallVC new];
            
            [self.navigationController pushViewController:mallVC animated:YES];
        }break;
            
        case HomeEventsTypePosMining:
        {
            PosMiningVC *posMiningVC = [PosMiningVC new];
            
            [self.navigationController pushViewController:posMiningVC animated:YES];
        }break;
            
        default:
            break;
    }
}

#pragma mark - Data

- (void)requestBannerList {
    
    [TLProgressHUD show];

    TLNetworking *http = [TLNetworking new];
    
    http.isUploadToken = NO;
    http.code = @"805806";
    http.parameters[@"location"] = @"app_home";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.bannerRoom = [BannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.headerView.banners = self.bannerRoom;
        
        //获取官方钱包总量，已空投量
        [self requestCountInfo];
        
    } failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];
    }];
    
}

/**
 获取官方钱包总量，已空投量
 */
- (void)requestCountInfo {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"802108";
    
    [http postWithSuccess:^(id responseObject) {
        
        CountInfoModel *countInfo = [CountInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.headerView.countInfo = countInfo;
        
        [TLProgressHUD dismiss];

    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
