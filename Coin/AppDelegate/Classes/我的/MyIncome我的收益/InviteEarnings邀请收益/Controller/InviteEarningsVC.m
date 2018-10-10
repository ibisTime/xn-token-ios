//
//  InviteEarningsVC.m
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "InviteEarningsVC.h"
#import "InviteEarningsTableView.h"
@interface InviteEarningsVC ()<RefreshDelegate>
{

}

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

    NSArray *array = @[
         @{@"bizType": @"5",
           @"mobile": @"+86 15268501421",
           @"income": @"10.2",
           @"createDatetime": @"2018-10-08"},
         @{@"bizType": @"1",
           @"mobile": @"+86 15268501481",
           @"income": @"10.2",
           @"createDatetime": @"2018-10-08"},
         @{@"bizType": @"1",
           @"mobile": @"+86 15268501481",
           @"income": @"10.2",
           @"createDatetime": @"2018-10-08"},
         @{@"bizType": @"1",
           @"mobile": @"+86 15268501481",
           @"income": @"10.2",
           @"createDatetime": @"2018-10-09"},
         @{@"bizType": @"1",
           @"mobile": @"+86 15268501481",
           @"income": @"10.2",
           @"createDatetime": @"2018-10-10"},
         @{@"bizType": @"1",
           @"mobile": @"+86 15268501481",
           @"income": @"10.2",
           @"createDatetime": @"2018-10-11"}];

    self.tableView.array = [InviteEarningsVC filterMaxItemsArray:array filterKey:@"createDatetime"];
    NSLog(@"%@",self.tableView.array);


}

+ (NSArray *)filterMaxItemsArray:(NSArray *)array filterKey:(NSString *)key {
    NSMutableArray *origArray = [NSMutableArray arrayWithArray:array];
    NSMutableArray *filerArray = [NSMutableArray array];

    while (origArray.count > 0) {
        id obj = origArray.firstObject;
        NSPredicate *predic = nil;
//        predic = [NSPredicate predicateWithFormat:@"self == %@",obj];
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
