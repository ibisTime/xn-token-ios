//
//  TradeFlowListVC.m
//  OGC
//
//  Created by 蔡卓越 on 2018/3/14.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TradeFlowListVC.h"

//M
#import "TradeFlowModel.h"
//V
#import "TradeFlowTableView.h"

#import "CoinUtil.h"

@interface TradeFlowListVC ()
//
@property (nonatomic, strong) TradeFlowTableView *tableView;
//流水列表
@property (nonatomic, strong) NSArray <TradeFlowModel *>*flows;
//暂无流水
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation TradeFlowListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LangSwitcher switchLang:@"交易流水" key:nil];
    //
    [self initPlaceHolderView];
    //
    [self initTableView];
    //获取流水列表
    [self requestFlowList];
    //
    [self.tableView beginRefreshing];
}

#pragma mark - Init
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
    
    textLbl.text = [LangSwitcher switchLang:@"暂无流水" key:nil];
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(addressIV.mas_bottom).offset(20);
        make.centerX.equalTo(addressIV.mas_centerX);
        
    }];
    
}

- (void)initTableView {
    
    self.tableView = [[TradeFlowTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = self.placeHolderView;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data
- (void)requestFlowList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"802307";
    
    helper.tableView = self.tableView;

    helper.parameters[@"symbol"] = kOGC;
    
    [helper modelClass:[TradeFlowModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.flows = objs;
            
            weakSelf.tableView.flows = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.flows = objs;
            
            weakSelf.tableView.flows = objs;
            
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
