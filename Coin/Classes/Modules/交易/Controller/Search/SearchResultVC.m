//
//  SearchResultVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "SearchResultVC.h"

#import "AdvertiseModel.h"

#import "TradeTableView.h"

#import "TradeBuyVC.h"
#import "TradeSellVC.h"

@interface SearchResultVC ()<RefreshDelegate>

@property (nonatomic, strong) TradeTableView *tableView;
//广告列表
@property (nonatomic, strong) NSMutableArray <AdvertiseModel *>*advertises;

//暂无交易
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation SearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索结果";
    //暂无搜索结果
    [self initPlaceHolderView];
    //
    [self initTableView];
    //获取搜索结果
    [self getSearchResult];
    //添加通知
    [self addNotification];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[TradeTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = self.placeHolderView;
    
    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *searchIV = [[UIImageView alloc] init];
    
    searchIV.image = kImage(@"暂无订单");
    
    searchIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:searchIV];
    [searchIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@90);
        
    }];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = @"暂无搜索结果";
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(searchIV.mas_bottom).offset(20);
        make.centerX.equalTo(searchIV.mas_centerX);
        
    }];
}

- (void)addNotification {
    
    //信任/取消信任
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSearchResult) name:kTrustNotification object:nil];
}

#pragma mark - Data

- (void)getSearchResult {
    
    if (self.searchType == SearchTypeAdvertise) {
        
        [self refreshAdvertise];
        
    } else {
        
        [self refreshUser];
    }
}

- (void)refreshAdvertise {
    
    CoinWeakSelf;

    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
        
    helper.code = @"625228";
    helper.start = 1;
    helper.limit = 20;
    helper.parameters[@"coin"] = @"ETH";
    helper.parameters[@"minPrice"] = self.minPrice;
    helper.parameters[@"maxPrice"] = self.maxPrice;
    helper.parameters[@"payType"] = self.payType;
    helper.parameters[@"tradeType"] = self.advertiseType;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[AdvertiseModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray <AdvertiseModel *>*objs, BOOL stillHave) {
            
            weakSelf.advertises = objs;
            
            weakSelf.tableView.advertises = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView beginRefreshing];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.advertises = objs;
            
            weakSelf.tableView.advertises = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)refreshUser {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"625229";
    helper.isList = YES;
    
    helper.parameters[@"nickName"] = self.nickName;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[AdvertiseModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray <AdvertiseModel *>*objs, BOOL stillHave) {
            
            weakSelf.advertises = objs;
            
            weakSelf.tableView.advertises = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView beginRefreshing];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - RefreshDelegate

- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.advertiseType isEqualToString:kTradeTypeBuy]) {
        
        TradeSellVC *sellVC = [TradeSellVC new];
        
        sellVC.advertise = self.advertises[indexPath.row];
        
        sellVC.type = TradeSellPositionTypeTrade;
        
        [self.navigationController pushViewController:sellVC animated:YES];
        
    } else if ([self.advertiseType isEqualToString:kTradeTypeSell]) {
        
        TradeBuyVC *buyVC = [TradeBuyVC new];
        
        buyVC.advertise = self.advertises[indexPath.row];
        
        buyVC.type = TradeBuyPositionTypeTrade;
        
        [self.navigationController pushViewController:buyVC animated:YES];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
