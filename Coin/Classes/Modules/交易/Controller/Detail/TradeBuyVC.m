//
//  TradeBuyVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TradeBuyVC.h"

#import "TradeBuyView.h"
#import "BuyConfirmView.h"

#import "CurrencyModel.h"
#import "OrderPriceModel.h"
#import "QuotationModel.h"
#import "IMAUser.h"

#import "NSNumber+Extension.h"
#import "NSString+Check.h"
#import "UILabel+Extension.h"
#import "UIBarButtonItem+convience.h"
#import "UIButton+EnLargeEdge.h"
#import "APICodeMacro.h"

#import "TLUserLoginVC.h"
#import "TLNavigationController.h"

@interface TradeBuyVC ()

@property (nonatomic, strong) TradeBuyView *tradeView;

@property (nonatomic, strong) BuyConfirmView *confirmView;
//model
@property (nonatomic, strong) OrderPriceModel *priceModel;
//定时器
@property (nonatomic, strong) NSTimer *timer;
//行情列表
@property (nonatomic, strong) NSArray <QuotationModel *>*quotations;

@end

@implementation TradeBuyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"购买";
    [self initTradeView];
    
    //查询用户的交易量
    [self queryTradeNum];
    
    if ([TLUser user].userId) {
        //获取余额
//        [self getLeftAmount];
        //查询信任关系
        [self queryAdvertiseDetail];
        
    }
    //是我的广告，并且广告在交易区
    if ([self.advertise.userId isEqualToString:[TLUser user].userId] && self.type == TradeBuyPositionTypeMyPublish) {
        
        //下架
        [self addOffItem];
    }
    
    //获取交易提醒
    [self requestTradeRemind];
    
    [self addNotification];
    
    //开启定时器,实时刷新
    self.timer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(queryAdvertiseDetail) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
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
    
    if ([self.advertise.status isEqualToString:@"1"] || [self.advertise.status isEqualToString:@"2"]) {
        
        [UIBarButtonItem addRightItemWithTitle:@"下架" titleColor:kTextColor frame:CGRectMake(0, 0, 40, 44) vc:self action:@selector(advertiseOff)];
        
    }
}

- (void)initTradeView {
    
    CoinWeakSelf;
    
    self.tradeView = [[TradeBuyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    self.tradeView.advertise = self.advertise;
    
    if ([TLUser user].userId) {
        
        self.tradeView.userId = [TLUser user].userId;
    }

    self.tradeView.tradeBlock = ^(TradeBuyType tradeType) {
        
        [weakSelf tradeEventsWithType:tradeType];
    };
    
    [self.view addSubview:self.tradeView];
}

- (BuyConfirmView *)confirmView {
    
    if (!_confirmView) {
        
        CoinWeakSelf;
        
        _confirmView = [[BuyConfirmView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
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
- (void)tradeEventsWithType:(TradeBuyType)type {
    
    CoinWeakSelf;
    
    switch (type) {
        case TradeBuyTypeTrust:
        {
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
                
                TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
                
                loginVC.loginSuccess = ^(){
                    
                    [weakSelf tradeEventsWithType:TradeBuyTypeTrust];
                };
                
                [self presentViewController:nav animated:YES completion:nil];
                
                return;
            }
            
            [self trustUser];
            
        }break;
            
        case TradeBuyTypeCancelTrust:
        {
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
                
                TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
                
                loginVC.loginSuccess = ^(){
                    
                    [weakSelf tradeEventsWithType:TradeBuyTypeTrust];
                };
                
                [self presentViewController:nav animated:YES completion:nil];
                
                return;
            }
            
            [self cancelTrustUser];

        }break;
            
        case TradeBuyTypeLink:
        {
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
                
                TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
                
                loginVC.loginSuccess = ^(){
                    
                    [weakSelf tradeEventsWithType:TradeBuyTypeTrust];
                };
                
                [self presentViewController:nav animated:YES completion:nil];
                
                return;
            }
            
            //对方
            TradeUserInfo *friendUserInfo = self.advertise.user;
            
            IMAUser *user = [[IMAUser alloc] initWith:self.advertise.userId];
            
            user.nickName = friendUserInfo.nickname;
            user.icon = [friendUserInfo.photo convertImageUrl];
            user.remark = friendUserInfo.nickname;
            user.userId = self.advertise.userId;
            //我
            ChatUserProfile *userInfo = [ChatUserProfile sharedUser];
            
            userInfo.minePhoto = [TLUser user].photo;
            userInfo.mineNickName = [TLUser user].nickname;
            userInfo.friendPhoto = [friendUserInfo.photo convertImageUrl];
            userInfo.friendNickName = friendUserInfo.nickname;
            
            ChatViewController *chatVC = [[CustomChatUIViewController alloc] initWith:user];
            
            chatVC.userInfo = userInfo;
            
            [self.navigationController pushViewController:chatVC animated:YES];
            //待下单
            [self willCommitOrder];
            
        }break;
          
        case TradeBuyTypeBuy:
        {
            
            if (![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
                
                TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
                
                loginVC.loginSuccess = ^(){
                    
                    [weakSelf tradeEventsWithType:TradeBuyTypeTrust];
                };
                
                [self presentViewController:nav animated:YES completion:nil];
                
                return;
            }
            
            if (![self.tradeView.ethTF.text valid]) {
                
                [TLAlert alertWithInfo:@"请输入购买金额"];
                return ;
                
            }
            
            self.priceModel = [OrderPriceModel new];
            
            self.priceModel.price = [self.advertise.truePrice convertToSimpleRealMoney];
            
            self.priceModel.amount = self.tradeView.cnyTF.text;
            
            self.priceModel.num = self.tradeView.ethTF.text;
            
            self.confirmView.priceModel = self.priceModel;
            
            [self.confirmView show];
            
        }break;
            
        default:
            break;
    }
}

- (void)trustUser {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805110";
    http.parameters[@"toUser"] = self.advertise.userId;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"信任成功"];
        
        [self queryAdvertiseDetail];

        [self.tradeView.trustBtn setTitle:@"取消信任" forState:UIControlStateHighlighted];

        [[NSNotificationCenter defaultCenter] postNotificationName:kTrustNotification object:nil];

    } failure:^(NSError *error) {
        
        
    }];
}

- (void)cancelTrustUser {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805111";
    http.parameters[@"toUser"] = self.advertise.userId;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"取消成功"];
        
        [self queryAdvertiseDetail];
        
        [self.tradeView.trustBtn setTitle:@"+ 信任" forState:UIControlStateHighlighted];

        [[NSNotificationCenter defaultCenter] postNotificationName:kTrustNotification object:nil];

    } failure:^(NSError *error) {
        
        
    }];
}

- (void)confirmOrder {
    
    CoinWeakSelf;
    
    NSString *num = [self.tradeView.tradeNum convertToSysCoin];
    
    NSString *price = [self.advertise.truePrice convertToRealMoneyWithNum:3];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625240";
    http.parameters[@"adsCode"] = self.advertise.code;
    http.parameters[@"buyUser"] = [TLUser user].userId;
    http.parameters[@"count"] = num;
    http.parameters[@"tradeAmount"] = self.tradeView.tradeAmount;
    http.parameters[@"tradePrice"] = price;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"下单成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            weakSelf.tabBarController.selectedIndex = 1;
            
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];

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
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625224";
    http.parameters[@"adsCode"] = self.advertise.code;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"下架成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kAdvertiseOff object:nil];
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - Data
- (void)requestTradeRemind {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_CKEY_CVALUE;
    http.parameters[@"key"] = @"trade_remind";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.tradeView.tradeRemind = responseObject[@"data"][@"cvalue"];
        
        [self.tradeView.tradeRemindBtn setTitle:responseObject[@"data"][@"remark"] forState:UIControlStateNormal];
        
        [self.tradeView.tradeRemindBtn setTitleRight];

    } failure:^(NSError *error) {
        
        
    }];
}


- (void)getLeftAmount {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"802503";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.isList = YES;
    helper.isCurrency = YES;
    
    [helper modelClass:[CurrencyModel class]];
    
    [helper refresh:^(NSMutableArray <CurrencyModel *>*objs, BOOL stillHave) {
        
        [objs enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
           
            if ([obj.currency isEqualToString:@"ETH"]) {
                
                weakSelf.tradeView.leftAmount = obj.amountString;
            }
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)queryTradeNum {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625255";
    http.parameters[@"userId"] = self.advertise.userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *text = @"历史交易";
        
        NSString *numStr = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"totalTradeCount"]];
        
        NSString *realNum = [numStr convertToSimpleRealCoin];

        CGFloat historyNum = [[realNum convertToRealMoneyWithNum:8] doubleValue];

        //判断个数
        NSString *history = @"";
        
        if (historyNum == 0) {
            
            history = @"0 ETH";
            
        } else if (historyNum > 0 && historyNum < 0.5) {
            
            history = @"0-0.5 ETH";
            
        } else if (historyNum > 0.5 && historyNum < 1) {
            
            history = [NSString stringWithFormat:@"%@+ ETH", [realNum convertToRealMoneyWithNum:1]];
            
        } else if (historyNum >= 1) {
            
            history = [NSString stringWithFormat:@"%.0lf+ ETH", historyNum];
        }
        
        //历史交易
        UILabel *lbl = self.tradeView.lblArr[3];
        
        [lbl labelWithString:[NSString stringWithFormat:@"%@\n%@", history, text] title:text font:Font(12.0) color:kTextColor2];
        

    } failure:^(NSError *error) {
        
    }];
}

- (void)queryAdvertiseDetail {
    
    CoinWeakSelf;
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625226";
    
    http.parameters[@"adsCode"] = self.advertise.code;
    
    if ([TLUser user].isLogin) {
        
        http.parameters[@"userId"] = [TLUser user].userId;
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        AdvertiseModel *advertise = [AdvertiseModel tl_objectWithDictionary:responseObject[@"data"]];
        
        weakSelf.tradeView.advertise = advertise;

        weakSelf.tradeView.truePrice = advertise.truePrice;
        
        weakSelf.tradeView.isTrust = [advertise.isTrust integerValue] == 0 ? NO: YES;
        //广告剩余可用余额
        weakSelf.tradeView.leftAmount = advertise.leftCountString;

        
    } failure:^(NSError *error) {
        
    }];
}

//我要购买开始聊天，提交交易订单(待下单状态)
- (void)willCommitOrder {
    
    TLNetworking *http = [TLNetworking new];
    
    http.isShowMsg = NO;
    
    http.code = @"625247";
    http.parameters[@"adsCode"] = self.advertise.code;
    http.parameters[@"buyUser"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
