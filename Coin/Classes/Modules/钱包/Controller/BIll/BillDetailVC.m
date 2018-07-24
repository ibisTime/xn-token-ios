//
//  BillDetailVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BillDetailVC.h"
#import "BillDetailTableView.h"
#import "TLUIHeader.h"
#import "CoinUtil.h"

@interface BillDetailVC ()

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) BillDetailTableView *tableView;

@end

@implementation BillDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LangSwitcher switchLang:@"账单详情" key:nil];
    
    [self initTableView];
    //
    [self initHeaderView];
    
}

#pragma mark - Init
- (void)initHeaderView {
    self.view.backgroundColor = kWhiteColor;
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    topView.backgroundColor = kHexColor(@"#0848DF");
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(kHeight(66)));
    }];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.headerView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.headerView];
//    self.tableView.tableHeaderView = self.headerView;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@(kHeight(90)));
    }];
    //账单类型
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:15.0];
    textLbl.textAlignment = NSTextAlignmentCenter;
    textLbl.numberOfLines = 0;
    [self.headerView addSubview:textLbl];
    textLbl.text = _bill.bizNote;


    NSString *onlyCountStr = [CoinUtil convertToRealCoin:_bill.transAmountString coin:_bill.currency];
    CGFloat money = [onlyCountStr doubleValue];
    NSString *moneyStr = @"";
    //
    if (money > 0) {
        
        moneyStr = [NSString stringWithFormat:@"+%@ %@", onlyCountStr, _bill.currency];
        
    } else if (money <= 0) {
        
        moneyStr = [NSString stringWithFormat:@"%@ %@", onlyCountStr, _bill.currency];
        
    }
    
    //金额
    UILabel *amountLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kAppCustomMainColor
                                                      font:32.0];
    amountLbl.text = moneyStr;
    [self.headerView addSubview:amountLbl];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLineColor;
    [self.headerView addSubview:line];
    
    //
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.headerView.mas_top).offset(22.5);
//        make.centerX.equalTo(self.headerView.mas_centerX);
        make.left.equalTo(self.headerView.mas_left).offset(15);
        make.right.equalTo(self.headerView.mas_right).offset(-15);
        
    }];
    
    //
    [amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(textLbl.mas_bottom).offset(17);
        make.centerX.equalTo(self.headerView.mas_centerX);
        
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(amountLbl.mas_bottom).offset(10);
        make.left.right.equalTo(self.headerView);
        make.height.mas_equalTo(0.5);

    }];
    
//    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(SCREEN_WIDTH);
//    }];
    
    [self.headerView layoutIfNeeded];
//    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, line.bottom);
//    self.tableView.tableHeaderView = self.headerView;
    
}

- (void)initTableView {
    
    self.tableView = [[BillDetailTableView alloc] initWithFrame:CGRectMake(0, kHeight(90), kScreenWidth, kSuperViewHeight) style:UITableViewStylePlain];
    self.tableView.bill = self.bill;
    [self.view addSubview:self.tableView];
}


@end
