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

#import "NSNumber+Extension.h"
#import "NSString+Check.h"
#import "UILabel+Extension.h"

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
        [self getLeftAmount];
    }

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

#pragma mark - Init

- (void)initTradeView {
    
    CoinWeakSelf;
    
    self.tradeView = [[TradeBuyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    self.tradeView.advertise = self.advertise;
    
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
        
        self.tradeView.trustBtn.selected = YES;

        [self.tradeView.trustBtn setTitle:@"取消信任" forState:UIControlStateHighlighted];

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
        
        self.tradeView.trustBtn.selected = NO;
        
        [self.tradeView.trustBtn setTitle:@"+ 信任" forState:UIControlStateHighlighted];

    } failure:^(NSError *error) {
        
        
    }];
}

- (void)confirmOrder {
    
    CoinWeakSelf;
    
    NSString *num = [self.tradeView.ethTF.text convertToSysCoin];
    
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
            
            [weakSelf.navigationController popViewControllerAnimated:YES];

        });
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - Data
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
        
        NSString *num = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"totalTradeCount"]];
        
        //历史交易
        UILabel *lbl = self.tradeView.lblArr[3];
        
        [lbl labelWithString:[NSString stringWithFormat:@"%@\n%@", num, text] title:text font:Font(12.0) color:kTextColor2];
        

    } failure:^(NSError *error) {
        
    }];
}

- (void)queryAdvertiseDetail {
    
    CoinWeakSelf;
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625226";
    
    http.parameters[@"adsCode"] = self.advertise.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        AdvertiseModel *advertise = [AdvertiseModel tl_objectWithDictionary:responseObject[@"data"]];
        
        weakSelf.tradeView.truePrice = advertise.truePrice;
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
