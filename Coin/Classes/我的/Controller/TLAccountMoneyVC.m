//
//  TLAccountMoneyVC.m
//  Coin
//
//  Created by shaojianfei on 2018/6/11.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLAccountMoneyVC.h"
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
#import "PlatformTableView.h"
#import "WallAccountVC.h"
#import "AddAccoutMoneyVc.h"
@interface TLAccountMoneyVC ()<RefreshDelegate>
@property (nonatomic, strong) WalletHeaderView *headerView;

@property (nonatomic, strong) WalletTableView *tableView;

@property (nonatomic, strong) PlatformTableView *currentTableView;

@property (nonatomic, strong) NSArray <CurrencyModel *>*currencys;

@end

@implementation TLAccountMoneyVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [LangSwitcher switchLang:@"托管账户" key:nil];

    //    [BTCMnemonic runAllTests];
    //
    //    BTCMnemonic *m = [[BTCMnemonic alloc] init];
    //    NSLog(@"%@",m.words);
    
    //tableView
    [self initTableView];
    //列表查询我的币种
    [self getMyCurrencyList];
    //通知
    [self addNotification];
    
    //    self.tableView.backgroundColor = [UIColor themeColor];
    
}

- (void)refreshOpenCoinList {
    [CoinUtil refreshOpenCoinList:^{
        
    } failure:^{
        
    }];
}

#pragma mark - Init

- (WalletHeaderView *)headerView {
    
    if (!_headerView) {
        
        CoinWeakSelf;
        
        _headerView = [[WalletHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150 + kStatusBarHeight+50 )];
        _headerView.addButton.hidden = YES;
        _headerView.headerBlock = ^{
            
            RateDescVC *descVC = [RateDescVC new];
            
            [weakSelf.navigationController pushViewController:descVC animated:YES];
        };
        
        _headerView.addBlock = ^{
            AddAccoutMoneyVc *monyVc = [[AddAccoutMoneyVc alloc] init];
            [weakSelf.navigationController pushViewController:monyVc animated:YES];
            
            NSLog(@"点击添加");
        };
        
    }
    return _headerView;
}

- (void)initTableView {
    
    
    [self.view addSubview:self.headerView];
    
    self.currentTableView = [[PlatformTableView alloc] initWithFrame:CGRectMake(0, self.headerView.height, kScreenWidth, kScreenHeight  - self.headerView.height)
                                                               style:UITableViewStyleGrouped];
    
    //    self.tableView.tableHeaderView = self.headerView;
    self.currentTableView.refreshDelegate = self;
    //    [self.tableView adjustsContentInsets];
    [self.view addSubview:self.currentTableView];
    //    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.headerView.mas_bottom);
    //    }];
    CoinWeakSelf;
    self.currentTableView.selectBlock = ^(NSInteger inter) {
        NSLog(@"%ld",inter);
        WallAccountVC *accountVC= [[WallAccountVC alloc] init];
        accountVC.currency = weakSelf.currencys[inter];
        accountVC.billType = CurrentTypeAll;
        [weakSelf.navigationController pushViewController:accountVC animated:YES];
        
        
    };
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
        
//        NSString *cnyStr = [responseObject[@"data"][@"totalAmountCNY"] convertToSimpleRealMoney];
        
        self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"%.2f", [responseObject[@"data"][@"totalAmountCNY"] doubleValue]];
        
//        NSString *usdStr = [responseObject[@"data"][@"totalAmountUSD"] convertToSimpleRealMoney];
        
        //        self.headerView.usdAmountLbl.text = [NSString stringWithFormat:@"%@USD", usdStr];
        //
//        NSString *hkdStr = [responseObject[@"data"][@"totalAmountHKD"] convertToSimpleRealMoney];
        
        //        self.headerView.hkdAmountLbl.text = [NSString stringWithFormat:@"%@HKD", hkdStr];
        
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
    helper.tableView = self.currentTableView;
    [helper modelClass:[CurrencyModel class]];
    [self.currentTableView addRefreshAction:^{
        
        [weakSelf refreshOpenCoinList];
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            //去除没有的币种
            
            
            NSMutableArray <CurrencyModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                CurrencyModel *currencyModel = (CurrencyModel *)obj;
                //                if ([[CoinUtil shouldDisplayCoinArray] indexOfObject:currencyModel.currency ] != NSNotFound ) {
                
                [shouldDisplayCoins addObject:currencyModel];
                //                }
                
            }];
            
            //
            weakSelf.currencys = shouldDisplayCoins;
            weakSelf.currentTableView.platforms = shouldDisplayCoins;
            [weakSelf.currentTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
        //查询美元汇率
        [weakSelf searchRateWithCurrency:@"USD"];
        //查询港元汇率
        [weakSelf searchRateWithCurrency:@"HKD"];
        //查询总资产
        [weakSelf queryTotalAmount];
        
    }];
    
    [self.currentTableView beginRefreshing];
    
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
    
   
}

-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
   
   
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
