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
#import "PlatformTableView.h"
#import "WallAccountVC.h"
#import "AddAccoutMoneyVc.h"
#import "TLAccountTableView.h"
#import <MJExtension/MJExtension.h>
#import "WalletLocalVc.h"
#import "WalletLocalModel.h"
//#import <CoreBitcoin.h>
//#import <CoreBitcoin/CoreBitcoin.h>
//#import "BTCMnemonic+Tests.h"
@interface TLWalletVC ()<RefreshDelegate>

@property (nonatomic, strong) WalletHeaderView *headerView;

@property (nonatomic, strong) WalletTableView *tableView;

@property (nonatomic, strong) TLAccountTableView *currentTableView;

@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;

@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*tempcurrencys;


@end

@implementation TLWalletVC

- (void)viewWillAppear:(BOOL)animated {
    [self.currentTableView beginRefreshing];
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
//    [BTCMnemonic runAllTests];
//
//    BTCMnemonic *m = [[BTCMnemonic alloc] init];
//    NSLog(@"%@",m.words);
    
    //tableView
    [self initTableView];
    //列表查询我的币种
    [self getLocalWalletMessage];
    //通知
    [self addNotification];
    
//    self.tableView.backgroundColor = [UIColor themeColor];
    
}


- (void)getLocalWalletMessage
{
    //获取本地去中心化币种
    
    
    
    
    //获取我的资产
    [self queryMyAmount];
    [self queryTotalAmount];
    
    //本地读取数据

    
    
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
        _headerView.usdRate = @"test";

//        _headerView.whiteView.hidden = YES;
        _headerView.headerBlock = ^{
            
            RateDescVC *descVC = [RateDescVC new];
            
            [weakSelf.navigationController pushViewController:descVC animated:YES];
        };
        
        _headerView.addBlock = ^{
            AddAccoutMoneyVc *monyVc = [[AddAccoutMoneyVc alloc] init];
            monyVc.currentModels = weakSelf.currencys;
            [weakSelf.navigationController pushViewController:monyVc animated:YES];
            
            weakSelf.tempcurrencys = [NSMutableArray array];
            monyVc.select = ^(NSMutableArray *model) {
//                weakSelf.currencys = model;
                weakSelf.currencys = [NSMutableArray array];
                for (CurrencyModel *m in model) {
                    if (m.IsSelected == YES) {
                        [weakSelf.currencys addObject:m];
                    }
                }
                weakSelf.currentTableView.platforms = nil;
                [weakSelf.currentTableView reloadData];

                weakSelf.currentTableView.platforms = weakSelf.currencys;
//                [weakSelf.currentTableView beginRefreshing];
                [weakSelf.currentTableView reloadData];
                NSLog(@"%@",model);
            };
            
            NSLog(@"点击添加");
        };
        
    }
    return _headerView;
}

- (void)initTableView {
    

    [self.view addSubview:self.headerView];
    
    self.currentTableView = [[TLAccountTableView alloc] initWithFrame:CGRectMake(0, self.headerView.height, kScreenWidth, kScreenHeight - kTabBarHeight - self.headerView.height)
                                                      style:UITableViewStyleGrouped];
    
//    self.currentTableView.tableHeaderView = [UIView new];
//    self.currentTableView.tableFooterView = [UIView new];

    self.currentTableView.refreshDelegate = self;
//    self.currentTableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector (loadMore)];
//    self.currentTableView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector (loadBottom)];;

//    self.currentTableView.mj_header = [MJRefreshHeader]
//    [self.tableView adjustsContentInsets];
    [self.view addSubview:self.currentTableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.headerView.mas_bottom);
//    }];
    CoinWeakSelf;
    self.currentTableView.selectBlock = ^(NSInteger inter) {
        NSLog(@"%ld",inter);
        WalletLocalVc *accountVC= [[WalletLocalVc alloc] init];
        accountVC.currency = weakSelf.currencys[inter];
        accountVC.billType = LocalTypeAll;
        [weakSelf.navigationController pushViewController:accountVC animated:YES];
        
        
    };
}

- (void)loadNotiction
{
    TLPageDataHelper *http = [TLPageDataHelper new];
    http.code = @"804040";
    http.parameters[@"channelType"] = @4;
    http.parameters[@"status"] = @1;
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"10";
    http.isList = YES;

  

    
}
- (void)loadBottom
{
    
    
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userlogin) name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(withDrawCoinSuccess) name:kWithDrawCoinSuccess object:nil];
}

#pragma mark - Events

- (void)userlogin {
    
//    [self getMyCurrencyList];
    
}

- (void)withDrawCoinSuccess {
    
//    [self getMyCurrencyList];
    
}

- (void)queryMyAmount
{
    TLNetworking *http = [TLNetworking new];
    http.code = @"802270";

    NSArray *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"localArray"];
    if (a.count > 0) {
                http.ISparametArray = YES;
        
        http.parameters[@"accountList"] = a;
    }
    else{
        
        NSString *address  =  [[NSUserDefaults standardUserDefaults] objectForKey:KWalletAddress];
        
        //    http.ISparametArray = YES;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSMutableDictionary *dicWan = [NSMutableDictionary dictionary];
        
        [dic setObject:@"ETH" forKey:@"symbol"];
        [dic setObject:address forKey:@"address"];
        [dicWan setObject:@"WAN" forKey:@"symbol"];
        [dicWan setObject:address forKey:@"address"];
        NSArray *arr = @[dic,dicWan];
        http.parameters[@"accountList"] = arr;
    }
    
    //    http.parametArray = @[ dic];
    
    CoinWeakSelf;
        [http postWithSuccess:^(id responseObject) {
    
            NSString *cnyStr = [responseObject[@"data"][@"totalAmountCNY"] convertToSimpleRealMoney];
    
            self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"%.2f", [cnyStr doubleValue]];
    
            NSArray *usdStr = responseObject[@"data"][@"accountList"];
    
//            weakSelf.currencys   =  [CurrencyModel mj_objectArrayWithKeyValuesArray:usdStr];
    
            NSLog(@"%@",self.currencys);
    
//            weakSelf.currentTableView.platforms = weakSelf.currencys;
//            [weakSelf.currentTableView reloadData_tl];
            self.headerView.usdAmountLbl.text = [NSString stringWithFormat:@"%@USD", usdStr];
    
            NSString *hkdStr = [responseObject[@"data"][@"totalAmountHKD"] convertToSimpleRealMoney];
    
            self.headerView.hkdAmountLbl.text = [NSString stringWithFormat:@"%@HKD", hkdStr];
    
        } failure:^(NSError *error) {
    
            [self.currentTableView endRefreshingWithNoMoreData_tl];
    
        }];
    
}

#pragma mark - Data
- (void)queryTotalAmount {
    
    [self.currentTableView beginRefreshing];
    TLPageDataHelper *http = [TLPageDataHelper new];
    http.code = @"802270";
    
    NSArray *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"localArray"];
    if (a.count > 0) {
//        http.ISparametArray = YES;

        http.parameters[@"accountList"] = a;
    }
    else{
    
    NSString *address  =  [[NSUserDefaults standardUserDefaults] objectForKey:KWalletAddress];

//    http.ISparametArray = YES;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableDictionary *dicWan = [NSMutableDictionary dictionary];

    [dic setObject:@"ETH" forKey:@"symbol"];
    [dic setObject:address forKey:@"address"];
    [dicWan setObject:@"WAN" forKey:@"symbol"];
    [dicWan setObject:address forKey:@"address"];
    NSArray *arr = @[dic,dicWan];
    http.parameters[@"accountList"] = arr;
    }

//    http.parametArray = @[ dic];

    CoinWeakSelf;
    http.isList = YES;
    http.isCurrency = YES;
    http.tableView = self.currentTableView;
    [http modelClass:[CurrencyModel class]];

    [self.currentTableView addRefreshAction:^{
        [http refresh:^(NSMutableArray *objs, BOOL stillHave) {
            weakSelf.currencys = objs;
            weakSelf.currentTableView.platforms = weakSelf.currencys;
            [weakSelf.currentTableView reloadData_tl];
            NSLog(@"%@",objs);
            [weakSelf.currentTableView endRefreshingWithNoMoreData_tl];
            [weakSelf loadNotiction];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.currentTableView beginRefreshing];
    
//    [http postWithSuccess:^(id responseObject) {
//
//        NSString *cnyStr = [responseObject[@"data"][@"totalAmountCNY"] convertToSimpleRealMoney];
//
//        self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"%.2f", [cnyStr doubleValue]];
//
//        NSArray *usdStr = responseObject[@"data"][@"accountList"];
//
//        weakSelf.currencys   =  [CurrencyModel mj_objectArrayWithKeyValuesArray:usdStr];
//
//        NSLog(@"%@",self.currencys);
//
//        weakSelf.currentTableView.platforms = weakSelf.currencys;
//        [weakSelf.currentTableView reloadData_tl];
//        self.headerView.usdAmountLbl.text = [NSString stringWithFormat:@"%@USD", usdStr];
//
//        NSString *hkdStr = [responseObject[@"data"][@"totalAmountHKD"] convertToSimpleRealMoney];

//        self.headerView.hkdAmountLbl.text = [NSString stringWithFormat:@"%@HKD", hkdStr];
//
//    } failure:^(NSError *error) {
//
//        [self.currentTableView endRefreshingWithNoMoreData_tl];
//
//    }];
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
        
    }];
    
    [self.currentTableView beginRefreshing];
    
    [self.currentTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            if (weakSelf.tl_placeholderView.superview != nil) {
                
                [weakSelf removePlaceholderView];
            }
            [weakSelf queryMyAmount];
            weakSelf.currencys = objs;
            
            weakSelf.currentTableView.platforms = objs;
            [weakSelf.currentTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];
            
        }];
        
    }];
    
}

- (void)searchRateWithCurrency:(NSString *)currency {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625280";
    
    http.parameters[@"currency"] = currency;
    
    [http postWithSuccess:^(id responseObject) {
        
        if ([currency isEqualToString:@"USD"]) {
            
            self.headerView.usdRate = @"test";
            
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

@end
