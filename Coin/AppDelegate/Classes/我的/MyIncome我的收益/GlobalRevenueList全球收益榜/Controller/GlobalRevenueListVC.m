//
//  GlobalRevenueListVC.m
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "GlobalRevenueListVC.h"
#import "GlobalRevenueListTableView.h"
#import "GlobalRevenueListBottomView.h"
#import "MyIncomeTopModel.h"

@interface GlobalRevenueListVC ()<RefreshDelegate>

@property (nonatomic , strong)GlobalRevenueListTableView *tableView;
@property (nonatomic , strong)NSMutableArray <MyIncomeTopModel *>*topModel;
@property (nonatomic , strong)GlobalRevenueListBottomView *bottomView;
@end

@implementation GlobalRevenueListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LangSwitcher switchLang:@"全球收益榜" key:nil];
    [self initTableView];
    [self LoadData];


    GlobalRevenueListBottomView *bottomView = [[GlobalRevenueListBottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kNavigationBarHeight - GlobalRevenueListBottomHeight - 50, SCREEN_WIDTH, GlobalRevenueListBottomHeight + 50)];
    self.bottomView = bottomView;
    bottomView.layer.shadowOpacity = 0.22;// 阴影透明度
    bottomView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    bottomView.layer.shadowRadius=3;// 阴影扩散的范围控制
    bottomView.layer.shadowOffset=CGSizeMake(1, 1);// 阴影的范围
    [self.view addSubview:bottomView];
}


-(void)LoadData
{
    CoinWeakSelf;
    [weakSelf.tableView addRefreshAction:^{

        TLNetworking *http = [[TLNetworking alloc] init];
        http.showView = self.view;
        http.code = @"625801";
        http.parameters[@"userId"] = [TLUser user].userId;
        [http postWithSuccess:^(id responseObject) {
            weakSelf.topModel = [MyIncomeTopModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"top100"]];
            weakSelf.tableView.topModel = weakSelf.topModel;

            weakSelf.bottomView.model = [MyIncomeTopModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self.tableView reloadData];
            [self.tableView endRefreshHeader];

        } failure:^(NSError *error) {
            [self.tableView endRefreshHeader];
        }];


//        [TLNetworking POST:@"http://rap2.hichengdai.com:8080/app/mock/22/625801" parameters:nil success:^(id responseObject) {
//            NSLog(@"%@",responseObject);
//
//            weakSelf.topModel = [MyIncomeTopModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"top100"]];
//            weakSelf.tableView.topModel = weakSelf.topModel;
//
//            weakSelf.bottomView.model = [MyIncomeTopModel mj_objectWithKeyValues:responseObject[@"data"]];
//
//            [self.tableView reloadData];
//            [self.tableView endRefreshHeader];
//        } failure:^(NSError *error) {
//            [self.tableView endRefreshHeader];
//        }];
    }];
    [self.tableView beginRefreshing];
}



- (void)initTableView {
    self.tableView = [[GlobalRevenueListTableView alloc] initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - GlobalRevenueListBottomHeight - 50) style:(UITableViewStyleGrouped)];
    self.tableView.refreshDelegate = self;
    self.tableView.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.tableView];
}

-(void)refreshTableView:(TLTableView *)refreshTableview scrollView:(UIScrollView *)scroll
{


    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:9/255.0 green:90/255.0 blue:221/255.0 alpha:self.tableView.contentOffset.y / (400 - 64 + kNavigationBarHeight)]] forBarMetrics:UIBarMetricsDefault];


}

-(UIImage *)imageWithBgColor:(UIColor *)color {

    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;


}

//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.barTintColor = kHexColor(@"#0848DF");
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


@end
