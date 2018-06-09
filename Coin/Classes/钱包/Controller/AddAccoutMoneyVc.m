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
@property (nonatomic, strong) NSArray <CurrencyModel *>*currencys;

@end

@implementation AddAccoutMoneyVc

- (void)viewDidLoad {
    self.title = @"添加资产";
    [self initTableView];
    [self getMyCurrencyList];

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
