//
//  MyIncomeVC.m
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "MyIncomeVC.h"
#import "MyIncomeTableView.h"
#import "GlobalRevenueListVC.h"
#import "AccumulatedEarningsVC.h"
#import "InviteEarningsVC.h"
#import "MyIncomeModel.h"
#import "MyIncomeTopModel.h"
@interface MyIncomeVC ()<RefreshDelegate>

@property (nonatomic , strong)MyIncomeTableView *tableView;

@property (nonatomic , strong)MyIncomeModel *model;

@property (nonatomic , strong)NSMutableArray <MyIncomeTopModel *>*topModel;

@end

@implementation MyIncomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LangSwitcher switchLang:@"我的收益" key:nil];
    [self initTableView];
    [self LoadData];
}

-(void)LoadData
{
    CoinWeakSelf;
    [weakSelf.tableView addRefreshAction:^{


        TLNetworking *http = [[TLNetworking alloc] init];
        http.showView = self.view;
        http.code = @"625800";
        http.parameters[@"userId"] = [TLUser user].userId;
        [http postWithSuccess:^(id responseObject) {

            weakSelf.topModel = [MyIncomeTopModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"top5"]];
            weakSelf.tableView.topModel = weakSelf.topModel;

            weakSelf.model = [MyIncomeModel mj_objectWithKeyValues:responseObject[@"data"]];
            weakSelf.tableView.model = weakSelf.model;

            [self.tableView reloadData];
            [self.tableView endRefreshHeader];

        } failure:^(NSError *error) {
            [self.tableView endRefreshHeader];
        }];
    }];
    [self.tableView beginRefreshing];


//        [TLNetworking POST:@"http://rap2.hichengdai.com:8080/app/mock/22/625800" parameters:nil success:^(id responseObject) {
//            NSLog(@"%@",responseObject);
//
//            weakSelf.topModel = [MyIncomeTopModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"top5"]];
//            weakSelf.tableView.topModel = weakSelf.topModel;
//
//            weakSelf.model = [MyIncomeModel mj_objectWithKeyValues:responseObject[@"data"]];
//            weakSelf.tableView.model = weakSelf.model;
//
//            [self.tableView reloadData];
//            [self.tableView endRefreshHeader];
//        } failure:^(NSError *error) {
//            [self.tableView endRefreshHeader];
//        }];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
//
//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)initTableView {
    self.tableView = [[MyIncomeTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight) style:(UITableViewStyleGrouped)];
    self.tableView.refreshDelegate = self;
    self.tableView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.tableView];
}

-(void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index
{
    if (index == 100)
    {
        AccumulatedEarningsVC *vc = [AccumulatedEarningsVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 101)
    {
        InviteEarningsVC *vc = [InviteEarningsVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        GlobalRevenueListVC *vc = [GlobalRevenueListVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
