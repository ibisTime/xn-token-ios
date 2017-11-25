//
//  RateDescVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "RateDescVC.h"

#import "RateDescTableView.h"

@interface RateDescVC ()

@property (nonatomic, strong) RateDescTableView *tableView;

@property (nonatomic, strong) NSArray <RateModel *>*rates;

@end

@implementation RateDescVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"汇率概述";
    
    [self initTableView];
    //获取汇率列表
    [self requestRateList];
    
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[RateDescTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark - Data
- (void)requestRateList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.isList = YES;
    
    helper.code = @"625281";
//    helper.parameters[@"coin"] = self.coinName;
    
    helper.tableView = self.tableView;
    [helper modelClass:[RateModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.rates = objs;
            
            weakSelf.tableView.rates = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView beginRefreshing];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
