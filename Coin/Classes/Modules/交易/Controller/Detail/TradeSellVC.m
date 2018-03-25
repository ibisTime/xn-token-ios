//
//  TradeSellVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TradeSellVC.h"

#import "TradeSellView.h"
#import "SellConfirmView.h"

#import "CurrencyModel.h"
#import "OrderPriceModel.h"
#import "QuotationModel.h"
#import "IMAUser.h"
#import "CoinUtil.h"
#import "NSNumber+Extension.h"
#import "NSString+Check.h"
#import "UILabel+Extension.h"
#import "UIBarButtonItem+convience.h"
#import "APICodeMacro.h"

#import "TLUserLoginVC.h"
#import "TLNavigationController.h"
#import "HomePageVC.h"

@interface TradeSellVC ()

@property (nonatomic, strong) TradeSellView *tradeView;

@property (nonatomic, strong) SellConfirmView *confirmView;
//model
@property (nonatomic, strong) OrderPriceModel *priceModel;
//定时器
@property (nonatomic, strong) NSTimer *timer;
//行情列表
//@property (nonatomic, strong) NSArray <QuotationModel *>*quotations;
@property (nonatomic, strong) AdvertiseModel *advertise;
@end

@implementation TradeSellVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"出售";
    
    // ----------先获取广告详情
    CoinWeakSelf;
    TLNetworking *http = [TLNetworking new];
    http.code = @"625226";
    http.showView = self.view;
    http.parameters[@"adsCode"] = self.adsCode;
    if ([TLUser user].isLogin) {
        
        http.parameters[@"userId"] = [TLUser user].userId;
    }
    [http postWithSuccess:^(id responseObject) {
        
        self.advertise = [AdvertiseModel tl_objectWithDictionary:responseObject[@"data"]];
        
        //
        [self initTradeView];
        
        weakSelf.tradeView.advertise = self.advertise;
        weakSelf.tradeView.truePrice = self.advertise.truePrice;
        
        
//        if ([[TLUser user] checkLogin]) {
//            //已登录
//            self.leftAmountLbl.text = [NSString stringWithFormat:@"可用余额: %@ ETH", [_leftAmount convertToSimpleRealCoin]];
//
//        } else {
//            //未登录
//            self.leftAmountLbl.text = [NSString stringWithFormat:@"广告剩余可交易量: %@ ETH", [_leftAmount convertToSimpleRealCoin]];
//
//        }
        //广告剩余可用余额
        weakSelf.tradeView.leftInfo = @"--";
        
        //获取交易提醒
        [self requestTradeRemind];
        //添加通知
        [self addNotification];
        
        if ([[TLUser user] checkLogin]) {
            
            [self getLeftAmount];
            
        } else {
            
            weakSelf.tradeView.leftInfo = [NSString stringWithFormat:@"广告剩余可交易量: %@ %@", [CoinUtil convertToRealCoin:self.advertise.leftCountString coin:_advertise.tradeCoin], self.advertise.tradeCoin];
//            [CoinUtil convertToRealCoin:self.advertise.leftCountString coin:_advertise.tradeCoin]
            
        }
        
        //开启定时器,实时刷新
        //        self.timer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(queryAdvertiseDetail) userInfo:nil repeats:YES];
        //
        //        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        
        
    } failure:^(NSError *error) {
        
        
        
    }];
    
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.tradeView.scrollView.contentSize = CGSizeMake(kScreenWidth, self.tradeView.tradePromptView.yy + 10);
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [self.timer invalidate];
    
    self.timer = nil;
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserLoginNotification object:nil];
    
}

#pragma mark - Init

- (void)addOffItem {
    
    if ([self.advertise.status isEqualToString:kTradeOrderStatusPayed] ||
        [self.advertise.status isEqualToString:kTradeOrderStatusReleased]) {
        
        [UIBarButtonItem addRightItemWithTitle:@"下架" titleColor:kTextColor frame:CGRectMake(0, 0, 40, 44) vc:self action:@selector(advertiseOff)];
        
    }
}


- (void)initTradeView {
    
    CoinWeakSelf;
    
    self.tradeView = [[TradeSellView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    self.tradeView.advertise = self.advertise;
    
    if ([TLUser user].userId) {
        
        self.tradeView.userId = [TLUser user].userId;
    }
    
    self.tradeView.tradeBlock = ^(TradeSellType tradeType) {
        
        [weakSelf tradeEventsWithType:tradeType];
    };
    
    [self.view addSubview:self.tradeView];
}

- (SellConfirmView *)confirmView {
    
    if (!_confirmView) {
        
        CoinWeakSelf;
        
        _confirmView = [[SellConfirmView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _confirmView.confirmBlock = ^{
            
            [weakSelf confirmOrder];
        };
        
    }
    
    return _confirmView;
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userlogin) name:kUserLoginNotification object:nil];
    
}

#pragma mark - Events
- (void)tradeEventsWithType:(TradeSellType)type {
    
    CoinWeakSelf;
    
    switch (type) {
            
        case TradeSellTypeLink:
        {
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
                
                TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
                
                //                loginVC.loginSuccess = ^(){
                //
                //                    [weakSelf tradeEventsWithType:TradeSellTypeTrust];
                //                };
                
                [self presentViewController:nav animated:YES completion:nil];
                
                return;
            }
            
            //待下单
            [self willCommitOrder];
            
        }break;
            
        case TradeSellTypeSell:
        {
            
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
                
                TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
                
                //                loginVC.loginSuccess = ^(){
                //
                //                    [weakSelf tradeEventsWithType:TradeSellTypeTrust];
                //                };
                
                [self presentViewController:nav animated:YES completion:nil];
                
                return;
            }
            
            if (![self.tradeView.ethTF.text valid]) {
                
                [TLAlert alertWithInfo:@"请输入出售金额"];
                return ;
                
            }
            
            self.priceModel = [OrderPriceModel new];
            self.priceModel.price = [self.advertise.truePrice convertToSimpleRealMoney];
            self.priceModel.amount = self.tradeView.cnyTF.text;
            self.priceModel.num = self.tradeView.ethTF.text;
            self.priceModel.coin = self.advertise.tradeCoin;
            self.confirmView.priceModel = self.priceModel;
            
            [self.confirmView show];
            
        }break;
            
        case TradeSellTypeHomePage:
        {
            HomePageVC *homePageVC = [HomePageVC new];
            
            homePageVC.userId = self.advertise.userId;
            homePageVC.coinModel = [CoinUtil getCoinModel:self.advertise.tradeCoin];
            [self.navigationController pushViewController:homePageVC animated:YES];
            
        }break;
            
        default:
            break;
    }
}



- (void)confirmOrder {
    
    CoinWeakSelf;
    
    NSString *num = [CoinUtil convertToSysCoin:self.tradeView.tradeNum
                                          coin:self.advertise.tradeCoin];
    NSString *price = [self.advertise.truePrice convertToRealMoneyWithNum:3];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625241";
    http.showView = self.view;
    http.parameters[@"adsCode"] = self.advertise.code;
    http.parameters[@"sellUser"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"count"] = num;
    http.parameters[@"tradeAmount"] = self.tradeView.tradeAmount;
    http.parameters[@"tradePrice"] = price;

    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"下单成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            weakSelf.tabBarController.selectedIndex = 1;
            
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            //刷新订单列表
            [[NSNotificationCenter defaultCenter] postNotificationName:kOrderListRefresh object:nil];
        });
        
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)userlogin {
    
    self.tradeView.userId = [TLUser user].userId;
    
    //获取余额
    [self getLeftAmount];
    
    if ([self.advertise.userId isEqualToString:[TLUser user].userId]) {
        //查询信任关系
        [self queryAdvertiseDetail];
        
    }
}

//下架广告
- (void)advertiseOff {
    
    CoinWeakSelf;
    
    [TLAlert alertWithTitle:[LangSwitcher switchLang:@"提示" key:nil]
                        msg:[LangSwitcher switchLang:@"您确定要下架此广告?" key:nil]
                 confirmMsg:[LangSwitcher switchLang:@"确认" key:nil]
                  cancleMsg:[LangSwitcher switchLang:@"取消" key:nil]
                     cancle:^(UIAlertAction *action) {
                         
                         
                     } confirm:^(UIAlertAction *action) {
                         
                         [weakSelf requestAdvertiseOff];
                     }];
    
}

#pragma mark - Data

- (void)requestTradeRemind {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_CKEY_CVALUE;
    http.parameters[SYS_KEY] = @"trade_remind";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *remark = responseObject[@"data"][@"remark"];
        
        self.tradeView.tradeTextLbl.text = remark;
        
        self.tradeView.tradeRemind = responseObject[@"data"][@"cvalue"];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)getLeftAmount {
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"802503";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.isList = YES;
    helper.isCurrency = YES;
    [helper modelClass:[CurrencyModel class]];
    [helper refresh:^(NSMutableArray <CurrencyModel *>*objs, BOOL stillHave) {
        
        [objs enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            if ([obj.currency isEqualToString:self.advertise.tradeCoin]) {
                
                NSString *leftStr = [CoinUtil convertToRealCoin:[obj.amountString subNumber:obj.frozenAmountString] coin:self.advertise.tradeCoin];
                self.tradeView.leftInfo = [NSString stringWithFormat:@"可用余额: %@ %@",leftStr,self.advertise.tradeCoin];
            }
            
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}


- (void)queryAdvertiseDetail {
    
    CoinWeakSelf;
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"625226";
//    http.showView = self.view;
    http.parameters[@"adsCode"] = self.advertise.code;
    if ([TLUser user].isLogin) {
        
        http.parameters[@"userId"] = [TLUser user].userId;
        
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        AdvertiseModel *advertise = [AdvertiseModel tl_objectWithDictionary:responseObject[@"data"]];
        
        weakSelf.tradeView.truePrice = advertise.truePrice;
        
        //        weakSelf.tradeView.isTrust = [advertise.isTrust integerValue] == 0 ? NO: YES;
        
        weakSelf.tradeView.advertise = advertise;
        //广告剩余可用余额
        //        weakSelf.tradeView.leftAmount = advertise.leftCountString;
        
    } failure:^(NSError *error) {
        
    }];
}

//我要购买开始聊天，提交交易订单(待下单状态)
- (void)willCommitOrder {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625248";
    http.showView = self.view;
    http.parameters[@"adsCode"] = self.advertise.code;
    http.parameters[@"sellUser"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;

    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *errorCode = responseObject[@"errorCode"];
        
        if ([errorCode isEqualToString:@"0"]) {
            
            NSString *orderCode = responseObject[@"data"][@"code"];
            
            //联系对方
            [self goChatWithGroupId:orderCode toUser:self.advertise.user];
            
            //刷新订单列表
            [[NSNotificationCenter defaultCenter] postNotificationName:kOrderListRefresh object:nil];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//下架广告
- (void)requestAdvertiseOff {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625224";
    http.showView = self.view;
    http.parameters[@"adsCode"] = self.advertise.code;
    http.parameters[@"userId"] = [TLUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"下架成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kAdvertiseOff object:nil];
        
        //
    } failure:^(NSError *error) {
        
    }];
    
    //
}

@end
