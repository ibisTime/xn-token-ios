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
#import "ChatManager.h"
#import "NSNumber+Extension.h"
#import "NSString+Check.h"
#import "UILabel+Extension.h"
#import "UIBarButtonItem+convience.h"
#import "UIButton+EnLargeEdge.h"
#import "APICodeMacro.h"

#import "TLUserLoginVC.h"
#import "TLNavigationController.h"
#import "HomePageVC.h"

@interface TradeBuyVC ()

@property (nonatomic, strong) TradeBuyView *tradeView;

@property (nonatomic, strong) BuyConfirmView *confirmView;
//model
@property (nonatomic, strong) OrderPriceModel *priceModel;
//定时器
@property (nonatomic, strong) NSTimer *timer;
//行情列表
//@property (nonatomic, strong) NSArray <QuotationModel *>*quotations;
@property (nonatomic, strong) AdvertiseModel *advertise;

@end

@implementation TradeBuyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [LangSwitcher switchLang:@"购买" key:nil]
   ;
    
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
        //广告剩余可用余额
        weakSelf.tradeView.leftAmount = self.advertise.leftCountString;
        //
        NSString *text = [LangSwitcher switchLang:@"历史交易" key:nil];
        NSString *history = [self.advertise.userStatistics convertTotalTradeCount];
        //历史交易
        UILabel *lbl = self.tradeView.lblArr[3];
        [lbl labelWithString:[NSString stringWithFormat:@"%@\n%@", history, text] title:text font:Font(12.0) color:kTextColor2];
        
        // ----------------- //


        
        //是我的广告，并且广告在交易区
        if ([self.advertise.userId isEqualToString:[TLUser user].userId]
            && self.type == TradeBuyPositionTypeMyPublish) {
            
            //下架
            [self addOffItem];
        }
        
        //获取交易提醒
        [self requestTradeRemind];
        //添加通知
        [self addNotification];
        
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
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark - Init

- (void)addOffItem {
    
    if ([self.advertise.status isEqualToString:@"1"] ||
        [self.advertise.status isEqualToString:@"2"]) {
        
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
            
            //待下单
            [self willCommitOrder];
            
        }break;
          
        case TradeBuyTypeBuy: {
            
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
            
        case TradeBuyTypeHomePage:
        {
            HomePageVC *homePageVC = [HomePageVC new];
            
            homePageVC.userId = self.advertise.userId;
            
            homePageVC.advCode = self.advertise.code;
            
            [self.navigationController pushViewController:homePageVC animated:YES];
            
        }break;
            
        default:
            break;
    }
}





- (void)confirmOrder {
    
    CoinWeakSelf;
    
    NSString *num = [self.tradeView.tradeNum convertToSysCoin];
    
    NSString *price = [self.advertise.truePrice convertToRealMoneyWithNum:3];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625240";
    http.showView = self.view;
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
            //刷新订单列表
            [[NSNotificationCenter defaultCenter] postNotificationName:kOrderListRefresh object:nil];
            
        });
        
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)userlogin {
    
    self.tradeView.userId = [TLUser user].userId;
    
    //获取余额
//    [self getLeftAmount];

}

//下架广告
- (void)advertiseOff {
    
    CoinWeakSelf;
    
    [TLAlert alertWithTitle:@"提示" msg:@"您确定要下架此广告?" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
        
    } confirm:^(UIAlertAction *action) {
        
        [weakSelf requestAdvertiseOff];
    }];
    
}

#pragma mark - 获取交易提醒
- (void)requestTradeRemind {
    
    TLNetworking *http = [TLNetworking new];
    http.code = USER_CKEY_CVALUE;
    http.parameters[@"key"] = @"trade_remind";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *remark = responseObject[@"data"][@"remark"];
        self.tradeView.tradeTextLbl.text = remark;
        self.tradeView.tradeRemind = responseObject[@"data"][@"cvalue"];
        
    } failure:^(NSError *error) {
        
        
    }];
}







//我要购买开始聊天，提交交易订单(待下单状态)
- (void)willCommitOrder {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625247";
    http.parameters[@"adsCode"] = self.advertise.code;
    http.parameters[@"buyUser"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *errorCode = responseObject[@"errorCode"];
        
        if ([errorCode isEqualToString:@"0"]) {
            
            NSString *orderCode = responseObject[@"data"][@"code"];
            //联系对方
            [self goChatWithGroupId:orderCode];
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
        
    } failure:^(NSError *error) {
        
    }];
}


//#pragma mark- ads_联系对方
//- (void)pushToChatVCWithGroupId:(NSString *)groupId {
//
//    //对方
//    TradeUserInfo *friendUserInfo = self.advertise.user;
//
//    //
//    IMAUser *user = [[IMAUser alloc] initWith:self.advertise.userId];
//    user.nickName = friendUserInfo.nickname;
//    user.icon = [friendUserInfo.photo convertImageUrl];
//    user.remark = friendUserInfo.nickname;
//    user.userId = self.advertise.userId;
//
//    //我
//    ChatUserProfile *userInfo = [ChatUserProfile sharedUser];
//    userInfo.minePhoto = [TLUser user].photo;
//    userInfo.mineNickName = [TLUser user].nickname;
//    userInfo.friendPhoto = [friendUserInfo.photo convertImageUrl];
//    userInfo.friendNickName = friendUserInfo.nickname;
//
////    ChatViewController *chatVC = [[CustomChatUIViewController alloc] initWith:user];
////
//
//    // 此处应该拿到订单号，进行 群组查找
//    IMAGroup *currentGroup = [[ChatManager sharedManager] getGroupByGroupId:<#(NSString *)#>];
//    ChatViewController *chatVC = [[ChatViewController alloc] initWith:user];
//    chatVC.userInfo = userInfo;
//
//    [self.navigationController pushViewController:chatVC animated:YES];
//}


@end
