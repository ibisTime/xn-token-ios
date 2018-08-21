//
//  QuotationListVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "QuotationListVC.h"

#import "QuotationListTableView.h"

#import "QuotationModel.h"

@interface QuotationListVC ()

@property (nonatomic, strong) QuotationListTableView *tableView;
//coinName
@property (nonatomic, copy) NSString *coinName;
//行情列表
@property (nonatomic, strong) NSArray <QuotationModel *>*quotations;

@end

@implementation QuotationListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView];
    //获取行情列表
    [self requestQuotationList];
    
    [self.tableView beginRefreshing];

}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[QuotationListTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Setting
- (void)setQuototationType:(QuotationListType)quototationType {
    
    _quototationType = quototationType;
    
    self.coinName = quototationType == QuotationListTypeBTC ? @"BTC": @"ETH";
    
    self.title = [NSString stringWithFormat:@"%@行情", self.coinName];
}

#pragma mark - Data
- (void)requestQuotationList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.isList = YES;
    
    helper.code = @"625291";
    helper.parameters[@"coin"] = self.coinName;
    
    helper.tableView = self.tableView;
    [helper modelClass:[QuotationModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.quotations = objs;
            
            weakSelf.tableView.quotations = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
