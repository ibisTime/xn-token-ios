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
#import "StoreDetailVC.h"
#import "TradeFlowListVC.h"

@interface HomeVC ()<RefreshDelegate>
//头部
@property (nonatomic, strong) HomeHeaderView *headerView;
//店铺
@property (nonatomic, strong) StoreTableView *tableView;
//
@property (nonatomic,strong) NSMutableArray <BannerModel *>*bannerRoom;
//暂无店铺
@property (nonatomic, strong) UIView *placeHolderView;
//
@property (nonatomic, strong) NSArray <StoreModel *>*stores;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LangSwitcher switchLang:@"首页" key:nil];
    //
    [self initPlaceHolderView];
    //获取店铺列表
    [self requestStoreList];
    //
    [self.tableView beginRefreshing];
}

#pragma mark - Init
- (StoreTableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[StoreTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.placeHolderView = self.placeHolderView;
        _tableView.refreshDelegate = self;
        
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(0);
        }];
        
    }
    return _tableView;
}

- (HomeHeaderView *)headerView {
    
    if (!_headerView) {
        
        CoinWeakSelf;
        //头部
        _headerView = [[HomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(185) + 120)];
        
        _headerView.headerBlock = ^(HomeEventsType type, NSInteger index) {
            
            [weakSelf headerViewEventsWithType:type index:index];
        };
    }
    return _headerView;
}

- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *addressIV = [[UIImageView alloc] init];
    addressIV.image = kImage(@"暂无订单");
    addressIV.centerX = kScreenWidth/2.0;
    [self.placeHolderView addSubview:addressIV];
    [addressIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@90);
        
    }];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = [LangSwitcher switchLang:@"暂无店铺" key:nil];
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(addressIV.mas_bottom).offset(20);
        make.centerX.equalTo(addressIV.mas_centerX);
        
    }];
    
}

#pragma mark - HeaderEvents
- (void)headerViewEventsWithType:(HomeEventsType)type index:(NSInteger)index {
    
    switch (type) {
        case HomeEventsTypeStatistics:
        {
            TradeFlowListVC *flowVC = [TradeFlowListVC new];
            
            [self.navigationController pushViewController:flowVC animated:YES];
            
        }break;
            
        default:
            break;
    }
}

#pragma mark - Data
- (void)requestStoreList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"625327";
//    helper.isList = YES;
    helper.parameters[@"orderColumn"] = @"ui_order";
    helper.parameters[@"orderDir"] = @"asc";
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[StoreModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.stores = objs;
            
            weakSelf.tableView.stores = objs;
            //获取banner列表
            [weakSelf requestBannerList];
            //获取官方钱包总量，已空投量
            [weakSelf requestCountInfo];
            
        } failure:^(NSError *error) {
            
            [TLProgressHUD dismiss];
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.stores = objs;
            
            weakSelf.tableView.stores = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)requestBannerList {
    
    [TLProgressHUD show];

    TLNetworking *http = [TLNetworking new];
    
    http.isUploadToken = NO;
    http.code = @"805806";
    http.parameters[@"location"] = @"app_home";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.bannerRoom = [BannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.headerView.banners = self.bannerRoom;
        
        self.tableView.tableHeaderView = self.headerView;

    } failure:^(NSError *error) {
        
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
        
        self.tableView.tableHeaderView = self.headerView;

        [self.tableView reloadData_tl];

        [TLProgressHUD dismiss];

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StoreModel *store = self.stores[indexPath.row];
    
    StoreDetailVC *detailVC = [StoreDetailVC new];
    
    detailVC.code = store.code;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
