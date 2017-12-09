//
//  QuotationVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/12/7.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "QuotationVC.h"

#import "QuotationTableView.h"

#import "CoinQuotationModel.h"

@interface QuotationVC ()

@property (nonatomic, strong) QuotationTableView *tableView;

@property (nonatomic, strong) NSMutableArray <CoinQuotationModel *>*quotations;
//定时器
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation QuotationVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //定时器刷起来
    [self startTimer];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
    
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"行情";
    
    [self initTableView];
    //查询各个币种情况
    [self queryCoinQuotation];
    
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[QuotationTableView alloc] init];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        
    }];
}

- (void)startTimer {
    
    //开启定时器,实时刷新
    self.timer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(queryCoinQuotation) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

#pragma mark - Data
- (void)queryCoinQuotation {
    
    NSLog(@"定时器刷起来");

    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.isList = YES;
    
    helper.code = @"625293";
    
    helper.tableView = self.tableView;
    [helper modelClass:[CoinQuotationModel class]];
    
    [self.tableView addRefreshAction:^{

        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.quotations = objs;
            
            weakSelf.tableView.quotations = objs;
            
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
