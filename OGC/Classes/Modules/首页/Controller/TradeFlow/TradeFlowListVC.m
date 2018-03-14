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

@interface TradeFlowListVC ()
//
@property (nonatomic, strong) TradeFlowTableView *tableView;
//流水列表
@property (nonatomic, strong) NSArray <TradeFlowModel *>*flows;

@end

@implementation TradeFlowListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LangSwitcher switchLang:@"交易流水" key:nil];
    //
    [self initTableView];
    //获取流水列表
    [self requestFlowList];
    //
    [self.tableView beginRefreshing];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[TradeFlowTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data
- (void)requestFlowList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"802107";
    
    helper.tableView = self.tableView;
    
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
