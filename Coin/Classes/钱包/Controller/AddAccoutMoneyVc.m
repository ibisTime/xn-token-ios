//
//  AddAccoutMoneyVc.m
//  Coin
//
//  Created by shaojianfei on 2018/6/7.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "AddAccoutMoneyVc.h"
#import "AddMoneyTableView.h"
#import "CurrencyModel.h"
#import "CoinUtil.h"

#import "NSString+Extension.h"
#import "NSString+Check.h"
@interface AddAccoutMoneyVc ()<RefreshDelegate>
@property (nonatomic ,strong) AddMoneyTableView *tableView;
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*shouldDisplayCoins;

@end

@implementation AddAccoutMoneyVc

- (void)viewDidLoad {
    self.title = @"添加资产";
    [self initTableView];
    [self queryTotalAmount];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)initTableView {
    
    
    
    self.tableView = [[AddMoneyTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    
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
- (void)refreshOpenCoinList {
    [CoinUtil refreshOpenCoinList:^{
        
    } failure:^{
        
    }];
}

- (void)queryTotalAmount {
    [self.tableView beginRefreshing];
    TLNetworking *http = [TLNetworking new];
    http.code = @"802270";
    //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KWalletWord];
    NSString *address  =  [[NSUserDefaults standardUserDefaults] objectForKey:KWalletAddress];
    //    NSString *address1  =  [[NSUserDefaults standardUserDefaults] objectForKey:KWalletWord];
    //    NSString *address2  =  [[NSUserDefaults standardUserDefaults] objectForKey:KWalletPrivateKey];
    
    http.ISparametArray = YES;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableDictionary *dicWan = [NSMutableDictionary dictionary];
    
    [dic setObject:@"ETH" forKey:@"symbol"];
    [dic setObject:address forKey:@"address"];
    [dicWan setObject:@"WAN" forKey:@"symbol"];
    [dicWan setObject:address forKey:@"address"];
    NSArray *arr = @[dic,dicWan];
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
            
            {
            CurrencyModel *currencyModel = (CurrencyModel *)obj;
            if ([weakSelf.currentModels containsObject:currencyModel] != NSNotFound)
            {
                    currencyModel.IsSelected = YES;

                }else{
                    
                     currencyModel.IsSelected = NO;
                }
                [shouldDisplayCoins addObject:currencyModel];

            }
            //                if ([[CoinUtil shouldDisplayCoinArray] indexOfObject:currencyModel.currency ] != NSNotFound ) {
            
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
        
        [weakSelf refreshOpenCoinList];
        
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

- (void)viewWillDisappear:(BOOL)animated{
    
    NSMutableArray *a = [NSMutableArray array];
    for (int i = 0; i < self.currencys.count; i++) {
        CurrencyModel *model = self.currencys[i];
        if (model.IsSelected == YES) {
            [a addObject:model];
        }
    }
    
    NSUserDefaults *defaules = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [NSMutableArray array];

    for (int i = 0; i < a.count; i++) {
        CurrencyModel *model = a[i];
        
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:model.symbol forKey:@"symbol"];
            [dic setObject:model.address forKey:@"address"];
            [arr addObject:dic];
    }
    [defaules setObject:arr forKey:@"localArray"];
    [defaules synchronize];

    
    [super viewWillDisappear:animated];
    CoinWeakSelf;
    　　if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
        　　　　NSLog(@"clicked navigationbar back button");
            if (self.select) {
                self.select(self.currencys);
            }
        
        
        　　}
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
