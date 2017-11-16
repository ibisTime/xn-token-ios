//
//  BillDetailVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BillDetailVC.h"
#import "BillDetailTableView.h"

@interface BillDetailVC ()

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) BillDetailTableView *tableView;

@end

@implementation BillDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账单详情";
    
    [self initTableView];
    //
    [self initHeaderView];
    
}

#pragma mark - Init
- (void)initHeaderView {
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 107)];
    
    self.tableView.tableHeaderView = self.headerView;
    //账单类型
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    textLbl.text = _bill.bizNote;
    
    [self.headerView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.headerView.mas_centerX);
        make.top.equalTo(@22.5);
        
    }];
    
    long long money = [_bill.transAmount longLongValue];

    NSString *moneyStr = @"";
    
    if (money > 0) {
        
        moneyStr = [NSString stringWithFormat:@"+%@", [_bill.transAmount convertToSimpleRealCoin]];
        
    } else if (money <= 0) {
        
        moneyStr = [NSString stringWithFormat:@"%@", [_bill.transAmount convertToSimpleRealCoin]];
        
    }
    
    //金额
    UILabel *amountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kThemeColor font:32.0];
    
    amountLbl.text = moneyStr;
    
    [self.headerView addSubview:amountLbl];
    [amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.headerView.mas_centerX);
        make.top.equalTo(textLbl.mas_bottom).offset(17);
        
    }];
    //分割线
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [self.headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
}

- (void)initTableView {
    
    self.tableView = [[BillDetailTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStylePlain];
    
    self.tableView.bill = self.bill;
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
