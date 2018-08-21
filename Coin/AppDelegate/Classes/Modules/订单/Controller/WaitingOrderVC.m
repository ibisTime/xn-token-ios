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

/**
 ——里面只用到了，订单的广告编号
 */
@property (nonatomic, strong) OrderModel *order;

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
    
    if (!self.orderCode) {
        [TLAlert alertWithInfo:@"请传入 orderCode"];
        return;
    }
    
    // 在该控制器中，只处理待交易的订单
    [self initSubviews];
    
    //首先查询订单详情
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"625251";
    http.parameters[@"code"] = self.orderCode;
    [http postWithSuccess:^(id responseObject) {
        
        //
        [self lazyLoadChatData];
        self.order = [OrderModel tl_objectWithDictionary:responseObject[@"data"]];
        [self queryAdvertiseDetail];

    } failure:^(NSError *error) {
        
    }];

    
    
}



#pragma mark - Setting
- (void)setOrder:(OrderModel *)order {
    
    _order = order;
    
//    self.title = self.order.isBuy ? [LangSwitcher switchLang:@"购买订单" key:nil] :
//                                    [LangSwitcher switchLang:@"出售订单" key:nil];
    
    if ([order.sellUser equalsString:[TLUser user].userId]) {
        // 出售订单
        self.title = _order.buyUserInfo.nickname;
        
    } else {
        
        // 购买订单
        self.title = _order.sellUserInfo.nickname;

    }
    
}

#pragma mark - 点击 购买 或者 出售按钮
- (void)clickButton {
    
    if (self.order.isBuy) {
        
        TradeBuyVC *buyVC = [TradeBuyVC new];
        buyVC.adsCode = self.advertise.code;
//        buyVC.type = TradeBuyPositionTypeTrade;
        [self.navigationController pushViewController:buyVC animated:YES];
        
    } else {
        
        TradeSellVC *sellVC = [TradeSellVC new];
        sellVC.adsCode = self.advertise.code;
//        sellVC.type = TradeSellPositionTypeTrade;
        [self.navigationController pushViewController:sellVC animated:YES];
    }
    
    //
    
    //
}

#pragma mark - Data
- (void)queryAdvertiseDetail {
    
    //
    CoinWeakSelf;
    TLNetworking *http = [TLNetworking new];
    http.code = @"625226";
    http.showView = self.view;
    http.parameters[@"adsCode"] = self.order.adsCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.advertise = [AdvertiseModel tl_objectWithDictionary:responseObject[@"data"]];
        
        //价格
        self.priceLbl.text = [NSString stringWithFormat:@"报价: %@ CNY", [self.advertise.truePrice convertToSimpleRealMoney]];
        self.priceLbl.text = [LangSwitcher switchLang:self.priceLbl.text key:nil];
        
        //限额
        self.limitAmountLbl.text = [NSString stringWithFormat:@"限额: %@-%@ CNY",[self.advertise.minTrade convertToSimpleRealMoney], [self.advertise.maxTrade convertToSimpleRealMoney]];
        self.limitAmountLbl.text = [LangSwitcher switchLang:self.limitAmountLbl.text key:nil];

        NSString *btnTitle = nil;
        UIColor *bgColor = nil;
        
        if ([[TLUser user].userId equalsString: self.advertise.userId]) {
            //我发布的广告，代下单
            self.orderBtn.hidden = YES;
            return ;
        }
        
        if ([self.advertise.status isEqualToString:kAdsStatusShangJia]) {
            
            //
            bgColor = kThemeColor;
            self.orderBtn.enabled = YES;
            btnTitle = self.order.isBuy ? @"购买": @"出售";
            
        } else {
            
            //
            bgColor = kPlaceholderColor;
            self.orderBtn.enabled = NO;
            btnTitle = @"已下架";

        }
        
      
        [self.orderBtn setTitle:[LangSwitcher switchLang:btnTitle key:nil] 
                        forState:UIControlStateNormal];
        
        //
        [self.orderBtn setBackgroundColor:bgColor forState:UIControlStateNormal];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Init
- (void)initSubviews {
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    self.topView.backgroundColor = kWhiteColor;
    self.topView.userInteractionEnabled = YES;
    
    //
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickButton)];
    [self.topView addGestureRecognizer:tap];
    
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

@end
