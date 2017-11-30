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
#import "IdAuthVC.h"

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

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    self.tableView = [[WalletTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userlogin) name:kUserLoginNotification object:nil];
    
}

#pragma mark - Events

- (void)userlogin {
    
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
    helper.isList = YES;
    helper.isCurrency = YES;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[CurrencyModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.currencys = objs;
            
            weakSelf.tableView.currencys = objs;
            
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
            
            //判断是否认证身份
            if (![[TLUser user].realName valid]) {
                
                IdAuthVC *idAuth = [IdAuthVC new];
                
                idAuth.success = ^{
                    
                    //身份认证成功后，判断是否设置资金密码
                    if ([[TLUser user].tradepwdFlag isEqualToString:@"0"]) {
                        
                        [TLAlert alertWithInfo:@"身份认证成功, 请设置资金密码"];

                        TLPwdType pwdType = TLPwdTypeSetTrade;
                        
                        TLPwdRelatedVC *pwdRelatedVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
                        
                        pwdRelatedVC.success = ^{
                            
                            WithdrawalsCoinVC *coinVC = [WithdrawalsCoinVC new];
                            
                            coinVC.currency = currencyModel;
                            
                            [weakSelf.navigationController pushViewController:coinVC animated:YES];
                        };
                        
                        [self.navigationController pushViewController:pwdRelatedVC animated:YES];
                        
                        return ;
                        
                    } else {
                        
                        [TLAlert alertWithInfo:@"身份认证成功"];

                        WithdrawalsCoinVC *coinVC = [WithdrawalsCoinVC new];
                        
                        coinVC.currency = currencyModel;
                        
                        [self.navigationController pushViewController:coinVC animated:YES];
                    }
                };
                
                [self.navigationController pushViewController:idAuth animated:YES];
            }
    
            WithdrawalsCoinVC *coinVC = [WithdrawalsCoinVC new];
            
            coinVC.currency = currencyModel;
            
            [self.navigationController pushViewController:coinVC animated:YES];
            
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

@end
