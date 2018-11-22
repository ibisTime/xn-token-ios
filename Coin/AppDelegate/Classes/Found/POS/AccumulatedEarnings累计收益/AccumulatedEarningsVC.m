//
//  AccumulatedEarningsVC.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/27.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "AccumulatedEarningsVC.h"
#import "AccumulatedEarningsTableView.h"
#import "PGDatePickManager.h"
#import "AccumulatedEarningsModel.h"
@interface AccumulatedEarningsVC ()<RefreshDelegate,PGDatePickerDelegate>

@property (nonatomic , strong)AccumulatedEarningsTableView *tableView;

@property (nonatomic , strong)NSMutableArray <AccumulatedEarningsModel *>*model;

@end

@implementation AccumulatedEarningsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(kScreenWidth/2-60, 0, 120, 50)];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textColor=kTextColor;
    [titleText setFont:[UIFont systemFontOfSize:17.0]];
    [titleText setText:[LangSwitcher switchLang:@"投资账单" key:nil]];
    self.navigationItem.titleView=titleText;

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    UIButton *_RightButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:_RightButton]];
    [_RightButton addTarget:self action:@selector(myRecodeClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_RightButton setImage:kImage(@"ic_calendar") forState:(UIControlStateNormal)];

    [self initTableView];
    [self LoadData:self.tableView.date];
}

-(void)myRecodeClick
{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackgroud = true;
    datePickManager.cancelButtonText = @"";
    datePickManager.confirmButtonText = [LangSwitcher switchLang:@"确认" key:nil];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType1;
    datePicker.isHiddenMiddleText = false;
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
    [self presentViewController:datePickManager animated:false completion:nil];
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    self.tableView.date = [NSString stringWithFormat:@"%ld-%ld",dateComponents.year,dateComponents.month];
    [self LoadData:self.tableView.date];
}

- (void)initTableView {
    self.tableView = [[AccumulatedEarningsTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight) style:(UITableViewStyleGrouped)];
    self.tableView.refreshDelegate = self;
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.defaultNoDataImage = kImage(@"暂无订单");
    self.tableView.defaultNoDataText = [LangSwitcher switchLang:@"暂无明细" key:nil];
    [self.view addSubview:self.tableView];

}

-(void)LoadData:(NSString *)date
{
    CoinWeakSelf;
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"802525";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"date"] = date;
    helper.isCurrency = YES;
    helper.tableView = self.tableView;
    [helper modelClass:[AccumulatedEarningsModel class]];

    [self.tableView addRefreshAction:^{
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            NSMutableArray <AccumulatedEarningsModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                AccumulatedEarningsModel *model = (AccumulatedEarningsModel *)obj;
                [shouldDisplayCoins addObject:model];
            }];
            //            weakSelf.model = shouldDisplayCoins;
            //            weakSelf.tableView.model = shouldDisplayCoins;
            //            [weakSelf.tableView reloadData_tl];

            weakSelf.model = shouldDisplayCoins;
            [weakSelf.tableView.model removeAllObjects];
            [weakSelf.tableView reloadData];
            weakSelf.tableView.model = shouldDisplayCoins;
            //        weakSelf.tableView.bills = objs;
            [weakSelf.tableView reloadData_tl];
        } failure:^(NSError *error) {

        }];
    }];
    [self.tableView addLoadMoreAction:^{

        helper.parameters[@"userId"] = [TLUser user].userId;
        helper.parameters[@"date"] = date;
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            NSLog(@" ==== %@",objs);
            NSMutableArray <AccumulatedEarningsModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                AccumulatedEarningsModel *model = (AccumulatedEarningsModel *)obj;
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


- (void)viewWillAppear:(BOOL)animated{
[super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    //    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];

    //    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = item;
    //    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;


}

//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kHexColor(@"#0848DF");
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

@end
