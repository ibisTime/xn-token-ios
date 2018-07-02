//
//  GetTheVC.m
//  Coin
//
//  Created by QinBao Zheng on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "GetTheVC.h"
#import "GetTheTableView.h"
#import "GetTheModel.h"

@interface GetTheVC ()
@property (nonatomic , strong)GetTheTableView *tableView;
@property (nonatomic, strong) NSMutableArray <GetTheModel *>*getthe;
@end

@implementation GetTheVC

-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[GetTheTableView alloc]
                          initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 70)
                          style:UITableViewStyleGrouped];

        self.tableView.backgroundColor = kWhiteColor;
        self.tableView.sectionHeaderHeight = 22;



    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self LoadData];
}



-(void)LoadData
{

    CoinWeakSelf;

    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    if (![TLUser user].isLogin) {
        return;
    }
    helper.code = @"623007";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.isList = NO;
    helper.isCurrency = YES;
    helper.tableView = self.tableView;
    [helper modelClass:[GetTheModel class]];

    [self.tableView addRefreshAction:^{

        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {

            //去除没有的币种
            NSLog(@" ==== %@",objs);

            NSMutableArray <GetTheModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                GetTheModel *getModel = (GetTheModel *)obj;
                [shouldDisplayCoins addObject:getModel];

            }];

            //
            weakSelf.getthe = shouldDisplayCoins;
            weakSelf.tableView.getthe = shouldDisplayCoins;
            [weakSelf.tableView reloadData_tl];

        } failure:^(NSError *error) {


        }];


    }];

    [self.tableView addLoadMoreAction:^{
        helper.parameters[@"userId"] = [TLUser user].userId;
        helper.parameters[@"token"] = [TLUser user].token;
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            NSLog(@" ==== %@",objs);
            //去除没有的币种


            NSMutableArray <GetTheModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                GetTheModel *gettheModel = (GetTheModel *)obj;
                //                if ([[CoinUtil shouldDisplayCoinArray] indexOfObject:currencyModel.currency ] != NSNotFound ) {

                [shouldDisplayCoins addObject:gettheModel];
                //                }

            }];

            //
            weakSelf.getthe = shouldDisplayCoins;
            weakSelf.tableView.getthe = shouldDisplayCoins;
            [weakSelf.tableView reloadData_tl];

        } failure:^(NSError *error) {


        }];

    }];

    [self.tableView beginRefreshing];
}



@end
