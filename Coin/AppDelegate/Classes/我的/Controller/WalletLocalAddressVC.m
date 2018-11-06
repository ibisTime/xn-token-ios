//
//  WalletLocalAddressVC.m
//  Coin
//
//  Created by shaojianfei on 2018/6/12.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "WalletLocalAddressVC.h"
#import "AddMoneyTableView.h"
#import "CurrencyModel.h"
#import "WalletAdressTableView.h"
#import "WalletAddressDetailVC.h"
@interface WalletLocalAddressVC ()<RefreshDelegate>
@property (nonatomic ,strong) WalletAdressTableView *tableView;
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*shouldDisplayCoins;
@end

@implementation WalletLocalAddressVC

- (void)viewDidLoad {
    self.title = @"导出私钥";
    [self initTableView];
    [self queryTotalAmount];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)initTableView {
    
    
    
    self.tableView = [[WalletAdressTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    
    //    self.tableView.tableHeaderView = self.headerView;
    self.tableView.refreshDelegate = self;
    //    [self.tableView adjustsContentInsets];
    [self.view addSubview:self.tableView];
    //    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.headerView.mas_bottom);
    //    }];
    CoinWeakSelf;
    //    self.tableView.selectBlock = ^(NSInteger inter) {
    //        NSLog(@"%ld",inter);
    //        WallAccountVC *accountVC= [[WallAccountVC alloc] init];
    //        accountVC.currency = weakSelf.currencys[inter];
    //        accountVC.billType = CurrentTypeAll;
    //        [weakSelf.navigationController pushViewController:accountVC animated:YES];
    //
    //
    //    };
}
//- (void)refreshOpenCoinList {
//    [CoinUtil refreshOpenCoinList:^{
//
//    } failure:^{
//
//    }];
//}

- (void)queryTotalAmount {
    [self.tableView beginRefreshing];
    TLNetworking *http = [TLNetworking new];
    http.code = @"802270";
    //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KWalletWord];
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *symbol;
    NSString *address;
    NSMutableArray *arr = [NSMutableArray array];
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT symbol,address from THALocal lo, THAUser th where lo.walletId = th.walletId  and th.userId = '%@'",[TLUser user].userId];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            symbol = [set stringForColumn:@"symbol"];
            address = [set stringForColumn:@"address"];
            
            if (!address) {
                [dic setObject:@"" forKey:@"address"];
                
            }else{
                
                [dic setObject:address forKey:@"address"];
                
            }
            [dic setObject:symbol forKey:@"symbol"];
            [arr addObject:dic];
        }
        [set close];
    }
    [dataBase.dataBase close];
    
    http.parameters[@"accountList"] = arr;
    
    //    http.parametArray = @[ dic];
    
    
    CoinWeakSelf;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *cnyStr = [responseObject[@"data"][@"totalAmountCNY"] convertToSimpleRealMoney];
        
        //        self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"%.2f", [cnyStr doubleValue]];
        
        NSArray *usdStr = responseObject[@"data"][@"accountList"];
        
        weakSelf.currencys   =  [CurrencyModel mj_objectArrayWithKeyValuesArray:usdStr];
        NSMutableArray <CurrencyModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
        [weakSelf.currencys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CurrencyModel *currencyModel = (CurrencyModel *)obj;
            currencyModel.IsSelected = YES;
            //                if ([[CoinUtil shouldDisplayCoinArray] indexOfObject:currencyModel.currency ] != NSNotFound ) {
            
            [shouldDisplayCoins addObject:currencyModel];
            //                }
            
        }];
        
        NSLog(@"%@",self.currencys);
        weakSelf.currencys = shouldDisplayCoins;
        
        weakSelf.tableView.currencys = weakSelf.currencys;
        [weakSelf.tableView reloadData_tl];
        //        self.headerView.usdAmountLbl.text = [NSString stringWithFormat:@"%@USD", usdStr];
        //
        //        NSString *hkdStr = [responseObject[@"data"][@"totalAmountHKD"] convertToSimpleRealMoney];
        
        //        self.headerView.hkdAmountLbl.text = [NSString stringWithFormat:@"%@HKD", hkdStr];
        [self.tableView endRefreshingWithNoMoreData_tl];
        
    } failure:^(NSError *error) {
        
        [self.tableView endRefreshingWithNoMoreData_tl];
        
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
        
//        [weakSelf refreshOpenCoinList];
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            //去除没有的币种
            
            
            NSMutableArray <CurrencyModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                CurrencyModel *currencyModel = (CurrencyModel *)obj;
                currencyModel.IsSelected = YES;
                //                if ([[CoinUtil shouldDisplayCoinArray] indexOfObject:currencyModel.currency ] != NSNotFound ) {
                
                [shouldDisplayCoins addObject:currencyModel];
                //                }
                
            }];
            
            //
            weakSelf.currencys = shouldDisplayCoins;
            weakSelf.tableView.currencys = shouldDisplayCoins;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
        
        
    }];
    
    [self.tableView beginRefreshing];
    
}

-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%@",self.currencys);
    
    WalletAddressDetailVC *detail = [[WalletAddressDetailVC alloc] init];
    detail.currentModel = self.currencys[indexPath.section];
    [self.navigationController pushViewController:detail animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//-(void)viewDidDisappear:(BOOL)animated
//{
//    
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    
//}
- (void)viewWillDisappear:(BOOL)animated{
    
    　　if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
            [self.navigationController popToRootViewControllerAnimated:YES];

        　　}
    [super viewWillDisappear:animated];
    
}


@end
