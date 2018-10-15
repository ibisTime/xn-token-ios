//
//  InviteEarningsVC.m
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "InviteEarningsVC.h"
#import "InviteEarningsTableView.h"
#import "InviteEarningsModel.h"
@interface InviteEarningsVC ()<RefreshDelegate>

@property (nonatomic , strong)NSMutableArray <InviteEarningsModel *>*model;

@property (nonatomic , strong)InviteEarningsTableView *tableView;

@end

@implementation InviteEarningsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    UILabel *titleText = [[UILabel alloc] init];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textColor=kTextColor;
    [titleText setFont:[UIFont systemFontOfSize:17.0]];
    [titleText setText:[LangSwitcher switchLang:@"邀请收益" key:nil]];
    self.navigationItem.titleView=titleText;

    [self LoadData];


}

-(void)LoadData
{
    CoinWeakSelf;

    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];

    helper.code = @"625802";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.isCurrency = YES;
    helper.tableView = self.tableView;
    [helper modelClass:[InviteEarningsModel class]];
    [self.tableView addRefreshAction:^{
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {


//            for (NSDictionary *dic in objs) {
//
//            }
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < objs.count; i ++) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic = objs[i];
//                [dic setValue:[dic[@"createDatetime"] convertDate] forkey:@"createDatetime"];
                InviteEarningsModel *model = [InviteEarningsModel mj_objectWithKeyValues:dic];
                [dic setValue:[model.createDatetime convertDate] forKey:@"createDatetime"];
                [array addObject:dic];
            }

            weakSelf.tableView.array = [NSMutableArray array];
            weakSelf.tableView.array = [InviteEarningsVC filterMaxItemsArray:array filterKey:@"createDatetime"];
            [weakSelf.tableView reloadData_tl];

        } failure:^(NSError *error) {

        }];



    }];

    [self.tableView beginRefreshing];

    [self.tableView addLoadMoreAction:^{
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {

            if (weakSelf.tl_placeholderView.superview != nil) {

                [weakSelf removePlaceholderView];
            }


//            NSMutableArray <InviteEarningsModel *>*ARRAY = [InviteEarningsVC filterMaxItemsArray:objs filterKey:@"createDatetime"];
            weakSelf.tableView.array = [InviteEarningsVC filterMaxItemsArray:objs filterKey:@"createDatetime"];
            [weakSelf.tableView reloadData_tl];

        } failure:^(NSError *error) {

            [weakSelf addPlaceholderView];

        }];
    }];

    [self.tableView endRefreshingWithNoMoreData_tl];
}

+ (NSMutableArray *)filterMaxItemsArray:(NSArray *)array filterKey:(NSString *)key {
    NSMutableArray *origArray = [NSMutableArray arrayWithArray:array];
    NSMutableArray *filerArray = [NSMutableArray array];

    while (origArray.count > 0) {
        id obj = origArray.firstObject;
        NSPredicate *predic = nil;

        id value = [obj valueForKey:key];
        predic = [NSPredicate predicateWithFormat:@"self.%@ == %@",key,value];

        NSArray *pArray = [origArray filteredArrayUsingPredicate:predic];
        [filerArray addObject:pArray];
        [origArray removeObjectsInArray:pArray];
    }
    return filerArray;
}

- (void)initTableView {
    self.tableView = [[InviteEarningsTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight) style:(UITableViewStyleGrouped)];
    self.tableView.refreshDelegate = self;
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.defaultNoDataImage = kImage(@"暂无订单");
    self.tableView.defaultNoDataText = [LangSwitcher switchLang:@"暂无明细" key:nil];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
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
