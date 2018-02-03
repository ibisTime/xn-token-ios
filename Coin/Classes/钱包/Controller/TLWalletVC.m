//
//  TLWalletVC.m
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLWalletVC.h"

#import "CoinHeader.h"

#import "WalletHeaderView.h"
#import "WalletTableView.h"

#import "CurrencyModel.h"

#import "NSString+Extension.h"
#import "NSString+Check.h"

#import "RechargeCoinVC.h"
#import "WithdrawalsCoinVC.h"
#import "BillVC.h"
#import "TLPwdRelatedVC.h"
#import "RateDescVC.h"
#import "ZMAuthVC.h"
#import <CDCommon/UIScrollView+TLAdd.h>
#import "CoinUtil.h"

@interface TLWalletVC ()<RefreshDelegate>

@property (nonatomic, strong) WalletHeaderView *headerView;

@property (nonatomic, strong) WalletTableView *tableView;

@property (nonatomic, strong) NSArray <CurrencyModel *>*currencys;

@end

@implementation TLWalletVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"钱包";
    
    //tableView
    [self initTableView];
    //列表查询我的币种
    [self getMyCurrencyList];
    //通知
    [self addNotification];
    
}

#pragma mark - Init

- (WalletHeaderView *)headerView {
    
    if (!_headerView) {
        
        CoinWeakSelf;
        
        _headerView = [[WalletHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150 + kStatusBarHeight + 50)];
        
        _headerView.headerBlock = ^{
            
            RateDescVC *descVC = [RateDescVC new];
            
            [weakSelf.navigationController pushViewController:descVC animated:YES];
        };
        
    }
    return _headerView;
}

- (void)initTableView {
    
    self.tableView = [[WalletTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight)
                                                      style:UITableViewStyleGrouped];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.refreshDelegate = self;
//    [self.tableView adjustsContentInsets];
    [self.view addSubview:self.tableView];
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userlogin) name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(withDrawCoinSuccess) name:kWithDrawCoinSuccess object:nil];
}

#pragma mark - Events

- (void)userlogin {
    
    [self getMyCurrencyList];
    
}

- (void)withDrawCoinSuccess {
    
    [self getMyCurrencyList];
    
}

#pragma mark - Data
- (void)queryTotalAmount {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"802503";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *cnyStr = [responseObject[@"data"][@"totalAmountCNY"] convertToSimpleRealMoney];
        
        self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"￥%@", cnyStr];
        
        NSString *usdStr = [responseObject[@"data"][@"totalAmountUSD"] convertToSimpleRealMoney];
        
        self.headerView.usdAmountLbl.text = [NSString stringWithFormat:@"%@USD", usdStr];
        
        NSString *hkdStr = [responseObject[@"data"][@"totalAmountHKD"] convertToSimpleRealMoney];
        
        self.headerView.hkdAmountLbl.text = [NSString stringWithFormat:@"%@HKD", hkdStr];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)getMyCurrencyList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"802503";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"token"] = [TLUser user].token;
    helper.isList = YES;
    helper.isCurrency = YES;
    helper.tableView = self.tableView;
    [helper modelClass:[CurrencyModel class]];
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            //去除没有的币种
            
            NSMutableArray <CurrencyModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                CurrencyModel *currencyModel = (CurrencyModel *)obj;
                if ([[CoinUtil shouldDisplayCoinArray] indexOfObject:currencyModel.currency ] != NSNotFound ) {
                    
                    [shouldDisplayCoins addObject:currencyModel];
                }
                
            }];
            
            //
            weakSelf.currencys = shouldDisplayCoins;
            weakSelf.tableView.currencys = shouldDisplayCoins;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
        //查询美元汇率
        [weakSelf searchRateWithCurrency:@"USD"];
        //查询港元汇率
        [weakSelf searchRateWithCurrency:@"HKD"];
        //查询总资产
        [weakSelf queryTotalAmount];
        
    }];
    
    [self.tableView beginRefreshing];
    
}

- (void)searchRateWithCurrency:(NSString *)currency {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625280";
    
    http.parameters[@"currency"] = currency;
    
    [http postWithSuccess:^(id responseObject) {
        
        if ([currency isEqualToString:@"USD"]) {
            
            self.headerView.usdRate = responseObject[@"data"][@"rate"];
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - RefreshDelegate
- (void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index {
    
    CoinWeakSelf;
    
    NSInteger tag = (sender.tag - 1200)%100;
    
    CurrencyModel *currencyModel = self.currencys[index];
    
    switch (tag) {
        case 0:
        {
            RechargeCoinVC *coinVC = [RechargeCoinVC new];
            coinVC.currency = currencyModel;
            [self.navigationController pushViewController:coinVC animated:YES];
            
        }break;
            
        case 1:
        {
            [self clickWithdrawWithCurrency:currencyModel];
            
        }break;
            
        case 2:
        {
            
            BillVC *billVC = [BillVC new];
            billVC.accountNumber = currencyModel.accountNumber;
            billVC.billType = BillTypeAll;
            [self.navigationController pushViewController:billVC animated:YES];
            
        }break;
            
        case 3:
        {
            
            BillVC *billVC = [BillVC new];
            billVC.accountNumber = currencyModel.accountNumber;
            billVC.billType = BillTypeFrozen;
            [self.navigationController pushViewController:billVC animated:YES];
            
        }break;
            
        default:
            break;
    }
}

- (void)clickWithdrawWithCurrency:(CurrencyModel *)currencyModel {
    
    CoinWeakSelf;
    
    //判断是否认证身份
    if (![[TLUser user].realName valid]) {
        
        ZMAuthVC *zmAuthVC = [ZMAuthVC new];
        
        zmAuthVC.title = [LangSwitcher switchLang:@"实名认证" key:nil];
        
        zmAuthVC.success = ^{
            
            //实名认证成功后，判断是否设置资金密码
            if ([[TLUser user].tradepwdFlag isEqualToString:@"0"]) {
                
                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"实名认证成功, 请设置资金密码" key:nil]];
                
            } else {
                
                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"实名认证成功" key:nil]];
            }
            
            [weakSelf clickWithdrawWithCurrency:currencyModel];
            
        };
        
        [self.navigationController pushViewController:zmAuthVC animated:YES];
        
        return ;
    }
    
    //实名认证成功后，判断是否设置资金密码
    if ([[TLUser user].tradepwdFlag isEqualToString:@"0"]) {
        
        TLPwdType pwdType = TLPwdTypeSetTrade;
        TLPwdRelatedVC *pwdRelatedVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
        pwdRelatedVC.isWallet = YES;
        pwdRelatedVC.success = ^{
            
            [weakSelf clickWithdrawWithCurrency:currencyModel];
        };
        [self.navigationController pushViewController:pwdRelatedVC animated:YES];
        return ;
        
    }
    
    WithdrawalsCoinVC *coinVC = [WithdrawalsCoinVC new];
    coinVC.currency = currencyModel;
    [self.navigationController pushViewController:coinVC animated:YES];
}

@end
