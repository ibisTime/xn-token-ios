//
//  HistoryRateVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/30.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "HistoryRateVC.h"

#import "HistoryRateTableView.h"

#import "HistoryRateModel.h"

@interface HistoryRateVC ()

@property (nonatomic, strong) HistoryRateTableView *tableView;
//暂无历史汇率
@property (nonatomic, strong) UIView *placeHolderView;

@property (nonatomic, strong) NSArray <HistoryRateModel *>*rates;

@end

@implementation HistoryRateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"历史汇率";
    //暂无历史汇率
    [self initPlaceHolderView];
    
    [self initTableView];
    //获取汇率列表
    [self requestHistoryRateList];
}

#pragma mark - Init
- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *couponIV = [[UIImageView alloc] init];
    
    couponIV.image = kImage(@"暂无订单");
    
    [self.placeHolderView addSubview:couponIV];
    [couponIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@90);
        
    }];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = @"暂无历史汇率";
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(couponIV.mas_bottom).offset(20);
        make.centerX.equalTo(couponIV.mas_centerX);
        
    }];
}

- (void)initTableView {
    
    self.tableView = [[HistoryRateTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    self.tableView.placeHolderView = self.placeHolderView;
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark - Data
- (void)requestHistoryRateList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"625282";
    helper.parameters[@"currency"] = self.currency;
    
    helper.start = 1;
    helper.limit = 20;
    
    helper.tableView = self.tableView;
    [helper modelClass:[HistoryRateModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.rates = objs;
            
            weakSelf.tableView.rates = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView beginRefreshing];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.rates = objs;
            
            weakSelf.tableView.rates = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
