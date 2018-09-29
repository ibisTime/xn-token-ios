//
//  PosMyInvestmentDetailsVC.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "PosMyInvestmentDetailsVC.h"
#import "PosMyInvestmentDetailsTableView.h"
#import "PosMyInvestmentModel.h"
#import "PosMyInvestmentHeadView.h"
#import "AccumulatedEarningsVC.h"
@interface PosMyInvestmentDetailsVC ()<RefreshDelegate>

@property (nonatomic , strong)PosMyInvestmentDetailsTableView *tableView;

@property (nonatomic , strong)NSMutableArray <PosMyInvestmentModel *>*model;

@end

@implementation PosMyInvestmentDetailsVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;


}
//
//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    self.title = [LangSwitcher switchLang:@"我的投资详情" key:nil];
    [self initTableView];
    [self LoadData:@[@"0",@"1",@"2"]];
}

- (void)initTableView {
    self.tableView = [[PosMyInvestmentDetailsTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight) style:(UITableViewStyleGrouped)];
    self.tableView.refreshDelegate = self;
    self.tableView.backgroundColor = kBackgroundColor;


    PosMyInvestmentHeadView *headView = [[PosMyInvestmentHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160 - 64)];
    headView.backgroundColor = kHexColor(@"#0848DF");
    headView.dataDic = self.dataDic;
    [headView.earningsButton addTarget:self action:@selector(earningsButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [headView.backButton addTarget:self action:@selector(earningsButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    self.tableView.tableHeaderView = headView;
    [self.view addSubview:self.tableView];

    

}

- (void)click:(UITapGestureRecognizer *)gesture{

//    NSLog(@"====%d",gesture.view.tag);//label的tag
    AccumulatedEarningsVC *vc = [AccumulatedEarningsVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

//累计收益
-(void)earningsButtonClick
{
    AccumulatedEarningsVC *vc = [AccumulatedEarningsVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index setArray:(NSArray *)array
{
//    [self.tableView endRefreshHeader];
    [TLProgressHUD show];
    [self LoadData:array];
}

//-(void)SelectLoadData:(NSArray *)array
//{
//    CoinWeakSelf;
//    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
//    helper.code = @"625525";
//    helper.showView = self.view;
//    helper.parameters[@"userId"] = [TLUser user].userId;
//    if (array.count > 0) {
//        helper.parameters[@"statusList"] = [array componentsJoinedByString:@","];
//    }
//    helper.isCurrency = YES;
//    helper.tableView = self.tableView;
//    [helper modelClass:[PosMyInvestmentModel class]];
//    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
//        NSMutableArray <PosMyInvestmentModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
//        [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            PosMyInvestmentModel *model = (PosMyInvestmentModel *)obj;
//            [shouldDisplayCoins addObject:model];
//        }];
//        //            weakSelf.model = shouldDisplayCoins;
//        //            weakSelf.tableView.model = shouldDisplayCoins;
//        //            [weakSelf.tableView reloadData_tl];
//
//        weakSelf.model = shouldDisplayCoins;
////        [weakSelf.tableView.model removeAllObjects];
////        [weakSelf.tableView reloadData];
//        weakSelf.tableView.model = shouldDisplayCoins;
//        //        weakSelf.tableView.bills = objs;
//        [weakSelf.tableView reloadData_tl];
//        [TLProgressHUD dismiss];
//    } failure:^(NSError *error) {
//
//    }];
//    helper.parameters[@"userId"] = [TLUser user].userId;
//    if (array.count > 0) {
//        helper.parameters[@"status"] = [array componentsJoinedByString:@","];
//    }
//    [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
//        NSLog(@" ==== %@",objs);
//        NSMutableArray <PosMyInvestmentModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
//        [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            PosMyInvestmentModel *model = (PosMyInvestmentModel *)obj;
//            [shouldDisplayCoins addObject:model];
//        }];
//        weakSelf.model = shouldDisplayCoins;
//
//        weakSelf.tableView.model = shouldDisplayCoins;
//        //        weakSelf.tableView.bills = objs;
//        [weakSelf.tableView reloadData_tl];
//
//    } failure:^(NSError *error) {
//    }];
//}

-(void)LoadData:(NSArray *)array
{
    CoinWeakSelf;
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"625526";
    helper.parameters[@"userId"] = [TLUser user].userId;
    if (array.count > 0) {
        helper.parameters[@"statusList"] = array;
    }
    helper.isCurrency = YES;
    helper.tableView = self.tableView;
    [helper modelClass:[PosMyInvestmentModel class]];

    [self.tableView addRefreshAction:^{
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            NSMutableArray <PosMyInvestmentModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PosMyInvestmentModel *model = (PosMyInvestmentModel *)obj;
                [shouldDisplayCoins addObject:model];
            }];

            weakSelf.model = shouldDisplayCoins;
            [weakSelf.tableView.model removeAllObjects];
            [weakSelf.tableView reloadData];
            weakSelf.tableView.model = shouldDisplayCoins;
            //        weakSelf.tableView.bills = objs;
            [TLProgressHUD dismiss];
            [weakSelf.tableView reloadData_tl];
        } failure:^(NSError *error) {

        }];
    }];
    [self.tableView addLoadMoreAction:^{

        helper.parameters[@"userId"] = [TLUser user].userId;
        if (array.count > 0) {
            helper.parameters[@"statusList"] = [array componentsJoinedByString:@","];
        }
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            NSLog(@" ==== %@",objs);
            NSMutableArray <PosMyInvestmentModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                PosMyInvestmentModel *model = (PosMyInvestmentModel *)obj;
                [shouldDisplayCoins addObject:model];
            }];
            weakSelf.model = shouldDisplayCoins;

            weakSelf.tableView.model = shouldDisplayCoins;
            //        weakSelf.tableView.bills = objs;
            [weakSelf.tableView reloadData_tl];

        } failure:^(NSError *error) {
        }];
    }];
    [self.tableView beginRefreshing];
}

@end
