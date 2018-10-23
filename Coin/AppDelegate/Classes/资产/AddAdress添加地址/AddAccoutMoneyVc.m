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

    if (self.isRedPage == YES) {
        self.title = [LangSwitcher switchLang:@"选择币种" key:nil];

    }else{
        self.title = [LangSwitcher switchLang:@"添加资产" key:nil];

        }
    [self initTableView];
   
    [self getStatusSymbol];

//    [self queryTotalAmount];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)initTableView {
    
    
    
    self.tableView = [[AddMoneyTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    self.tableView.refreshDelegate = self;
    self.tableView.PersonalWallet = self.PersonalWallet;
    [self.view addSubview:self.tableView];

}


- (void)getStatusSymbol
{

    if (self.PersonalWallet == 100)
    {
        CoinWeakSelf;

        TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
        if (![TLUser user].isLogin) {
            return;
        }

        helper.code = @"802283";
        helper.parameters[@"userId"] = [TLUser user].userId;
        helper.parameters[@"type"] = @"1";
        helper.isList = YES;
        helper.isCurrency = NO;
        helper.tableView = self.tableView;
        [helper modelClass:[CurrencyModel class]];
        [self.tableView addRefreshAction:^{

            [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {

                //去除没有的币种


                NSMutableArray <CurrencyModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
                [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                    CurrencyModel *currencyModel = (CurrencyModel *)obj;
                    [shouldDisplayCoins addObject:currencyModel];
                    //查询总资产
                }];

                weakSelf.currencys = shouldDisplayCoins;
                weakSelf.tableView.currencys = weakSelf.currencys;

                [weakSelf.tableView reloadData_tl];
                [weakSelf.tableView endRefreshingWithNoMoreData_tl];

            } failure:^(NSError *error) {

                [weakSelf.tableView endRefreshingWithNoMoreData_tl];

            }];



        }];
        [self.tableView beginRefreshing];
        [self.tableView addLoadMoreAction:^{
            helper.parameters[@"userId"] = [TLUser user].userId;
            helper.parameters[@"type"] = @"1";
            [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {

                //去除没有的币种


                NSMutableArray <CurrencyModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
                [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                    CurrencyModel *currencyModel = (CurrencyModel *)obj;
                    //                if ([[CoinUtil shouldDisplayCoinArray] indexOfObject:currencyModel.currency ] != NSNotFound ) {

                    [shouldDisplayCoins addObject:currencyModel];
                    //                }
                    //查询总资产

                }];

                weakSelf.currencys = shouldDisplayCoins;

                weakSelf.tableView.currencys = weakSelf.currencys;
                [weakSelf.tableView reloadData_tl];
                [weakSelf.tableView endRefreshingWithNoMoreData_tl];


                //


            } failure:^(NSError *error) {
                [weakSelf.tableView endRefreshingWithNoMoreData_tl];


            }];

        }];


    }
    else
    {
        if (self.isRedPage == YES) {
            self.tableView.currencys = self.currentModels;
            self.currentModels = self.currentModels;
            [self.tableView reloadData];


        }else{
            self.currentModels = [NSMutableArray array];
            NSString *totalcount;
            TLDataBase *data = [TLDataBase sharedManager];

            if ([data.dataBase open]) {
                NSString *sql;
                if (self.isRedPage == YES) {
                    sql = [NSString stringWithFormat:@"SELECT * from THALocal lo, THAUser th where lo.walletId = th.walletId  and th.userId = '%@'",[TLUser user].userId];
                }else{
                    sql = [NSString stringWithFormat:@"SELECT * from THALocal lo, THAUser th where lo.walletId = th.walletId  and th.userId = '%@'",[TLUser user].userId];
                }

                FMResultSet *set = [data.dataBase executeQuery:sql];
                while ([set next]) {
                    CurrencyModel *model =[CurrencyModel new];
                    if (self.isRedPage == YES) {
                        model.symbol = [set stringForColumn:@"symbol"];
                        [self.currentModels addObject:model];
                    }else{
                        totalcount = [set stringForColumn:@"IsSelect"];
                        model.IsSelected = [totalcount boolValue];
                        model.symbol = [set stringForColumn:@"symbol"];
                        [self.currentModels addObject:model];

                    }

                }
                [set close];
            }
            [data.dataBase close];

            self.tableView.currencys = self.currentModels;
            self.currentModels = self.currentModels;
            [self.tableView reloadData];
        }
    }

}

- (void)SaveStatusSymbol
{
    self.currencys = self.currentModels.mutableCopy;
    for (int i = 0; i < self.tableView.currencys.count; i++) {
        TLDataBase *data = [TLDataBase sharedManager];
        CurrencyModel *model = self.tableView.currencys[i];
        if ([data.dataBase open]) {
            
            NSString *sql = [NSString stringWithFormat:@"UPDATE THALocal SET IsSelect = '%@' WHERE walletId = (SELECT walletId from THAUser where userId='%@') and symbol = '%@' ",[NSNumber numberWithBool:model.IsSelected],[TLUser user].userId,model.symbol];
            BOOL sucess = [data.dataBase executeUpdate:sql];
            NSLog(@"更新自选状态%d",sucess);
        }
        [data.dataBase close];
    }
    
    
    self.tableView.currencys = self.currencys;
    self.currentModels = self.currentModels;
    [self.tableView reloadData];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    if (self.PersonalWallet == 100) {
        return;
    }
    if (self.isRedPage) {
        return;
    }
    self.currencys = self.tableView.currencys;
    [self SaveStatusSymbol];
    NSMutableArray *a = [NSMutableArray array];
    for (int i = 0; i < self.currencys.count; i++) {
        CurrencyModel *model = self.currencys[i];
        if (model.IsSelected == YES) {
            [a addObject:model];
        }
    }

    [super viewWillDisappear:animated];
//    CoinWeakSelf;


    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
   NSLog(@"clicked navigationbar back button");
            if (self.select) {
                self.select(self.currencys);
            }
    }
}

-(void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index
{

    if (self.PersonalWallet == 100) {
        TLNetworking *http = [TLNetworking new];
        http.code = @"802280";
        http.showView = self.view;
        NSDictionary *coin = self.currencys[index].coin;
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"symbol"] = coin[@"symbol"];
        http.parameters[@"type"] = @(1);
        http.parameters[@"orderNo"] = @(1);

        [http postWithSuccess:^(id responseObject) {

            NSNotification *notification =[NSNotification notificationWithName:@"LOADDATAPAGE" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];

        } failure:^(NSError *error) {


        }];
    }




}


-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isRedPage == YES) {
        if (self.curreryBlock) {
            self.curreryBlock(self.currentModels[indexPath.section]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
   
    
}
@end
