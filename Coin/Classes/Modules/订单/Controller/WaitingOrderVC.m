//
//  WaitingOrderVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/26.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "WaitingOrderVC.h"

#import "CoinHeader.h"

#import "AdvertiseModel.h"

#import "TradeBuyVC.h"
#import "TradeSellVC.h"

#import <IQKeyboardManager.h>

@interface WaitingOrderVC ()

@property (nonatomic, strong) UIView *topView;
//价格
@property (nonatomic, strong) UILabel *priceLbl;
//限额
@property (nonatomic, strong) UILabel *limitAmountLbl;
//按钮
@property (nonatomic, strong) UIButton *orderBtn;
//广告
@property (nonatomic, strong) AdvertiseModel *advertise;

@end

@implementation WaitingOrderVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
    
    [self queryAdvertiseDetail];
    
}

#pragma mark - Init
- (void)initSubviews {
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    
    self.topView.backgroundColor = kWhiteColor;
    
    //报价
    self.priceLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    [self.topView addSubview:self.priceLbl];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@(15));
        
    }];
    
    //限额
    self.limitAmountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    
    [self.topView addSubview:self.limitAmountLbl];
    [self.limitAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.priceLbl.mas_left);
        make.top.equalTo(self.priceLbl.mas_bottom).offset(10);
        
    }];
    
    //按钮
    UIButton *orderBtn = [UIButton buttonWithTitle:@"" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:15.0 cornerRadius:5];
    
    [orderBtn addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.topView addSubview:orderBtn];
    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-15));
        make.width.equalTo(@80);
        make.height.equalTo(@30);
        
    }];
    
    self.orderBtn = orderBtn;
    
    _tableView.tableHeaderView = self.topView;

}

#pragma mark - Setting
- (void)setOrder:(OrderModel *)order {
    
    _order = order;
    
    self.title = self.order.isBuy ? @"购买订单": @"出售订单";
    
}

#pragma mark - Events
- (void)clickButton {
    
    if (self.order.isBuy) {
        
        TradeBuyVC *buyVC = [TradeBuyVC new];
        buyVC.adsCode = self.advertise.code;
        buyVC.type = TradeBuyPositionTypeTrade;
        [self.navigationController pushViewController:buyVC animated:YES];
        
    } else {
        
        TradeSellVC *sellVC = [TradeSellVC new];
        
        sellVC.adsCode = self.advertise.code;
        sellVC.type = TradeBuyPositionTypeTrade;

        [self.navigationController pushViewController:sellVC animated:YES];
    }
}

#pragma mark - Data
- (void)queryAdvertiseDetail {
    
    CoinWeakSelf;
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625226";
    http.showView = self.view;
    
    http.parameters[@"adsCode"] = self.order.adsCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.advertise = [AdvertiseModel tl_objectWithDictionary:responseObject[@"data"]];
        
        //价格
        self.priceLbl.text = [NSString stringWithFormat:@"报价: %@ CNY", [self.advertise.truePrice convertToSimpleRealMoney]];
        //限额
        self.limitAmountLbl.text = [NSString stringWithFormat:@"限额: %@-%@ CNY",[self.advertise.minTrade convertToSimpleRealMoney], [self.advertise.maxTrade convertToSimpleRealMoney]];
        
        NSString *btnTitle = [self.advertise.status isEqualToString:@"1"] ? (self.order.isBuy ? @"购买": @"出售"): @"已下架";
        
        [self.orderBtn setTitle:btnTitle forState:UIControlStateNormal];
        
        UIColor *bgColor = [self.advertise.status isEqualToString:@"1"] ? kThemeColor: kPlaceholderColor;
        
        [self.orderBtn setBackgroundColor:bgColor forState:UIControlStateNormal];
        
        self.orderBtn.enabled = [self.advertise.status isEqualToString:@"1"] ? YES: NO;
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
