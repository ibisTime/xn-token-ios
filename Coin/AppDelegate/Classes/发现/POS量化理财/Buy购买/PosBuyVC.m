//
//  PosBuyVC.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "PosBuyVC.h"
#import "PosBuyTableView.h"
@interface PosBuyVC ()<RefreshDelegate>
@property (nonatomic , strong)PosBuyTableView *tableView;
@end

@implementation PosBuyVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];

    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(kScreenWidth/2-60, 0, 120, 50)];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textColor=kTextColor;
    [titleText setFont:[UIFont systemFontOfSize:17.0]];
    [titleText setText:[LangSwitcher switchLang:@"购买" key:nil]];
    self.navigationItem.titleView=titleText;

    UIButton *continBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"购买" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:18];
    [continBtn setBackgroundImage:kImage(@"Rectangle 3") forState:(UIControlStateNormal)];
    continBtn.frame = CGRectMake(0, SCREEN_HEIGHT - 50 - kNavigationBarHeight, SCREEN_WIDTH, 50);
    [continBtn addTarget:self action:@selector(continBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:continBtn];


}

-(void)continBtnClick
{

}

- (void)initTableView {
    self.tableView = [[PosBuyTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight) style:(UITableViewStyleGrouped)];
    self.tableView.refreshDelegate = self;
    self.tableView.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
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
