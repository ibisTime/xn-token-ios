//
//  PosMiningVC.m
//  Coin
//
//  Created by 蔡卓越 on 2018/3/29.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "PosMiningVC.h"
//V
#import "TLPlaceholderView.h"
#import "UIBarButtonItem+convience.h"
#import "TLMakeMoney.h"
#import "QuestionModel.h"
#import "TLtakeMoneyModel.h"
#import "TLMoneyDeailVC.h"
#import "CurrencyModel.h"
#import "PosMyInvestmentDetailsVC.h"
#import "MoneyAndTreasureHeadView.h"
@interface PosMiningVC ()<RefreshDelegate>

//
@property (nonatomic, strong) TLPlaceholderView *placeholderView;

@property (nonatomic , strong)UIButton *RightButton;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;

@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic,strong) NSArray <TLtakeMoneyModel *>*Moneys;

@property (nonatomic, strong) TLMakeMoney *tableView;

@property (nonatomic, strong) MoneyAndTreasureHeadView *headView;

@property (nonatomic , strong)NSDictionary *dataDic;

@end

@implementation PosMiningVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
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
    self.navigationController.navigationBar.barTintColor = kHexColor(@"#0848DF");
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];

    [self getMyCurrencyList];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"LOADDATA" object:nil];
    [self navigativeView];

    MoneyAndTreasureHeadView *headView = [[MoneyAndTreasureHeadView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, 160 - 64 + kNavigationBarHeight)];
    self.headView = headView;
    [self.view addSubview:headView];
}

-(void)navigativeView
{
//    self.title = [LangSwitcher switchLang:@"量化理财" key:nil];

    UILabel *nameLable = [[UILabel alloc]init];
    nameLable.text = [LangSwitcher switchLang:@"币加宝" key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(18);
    nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = nameLable;

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    _RightButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    _RightButton.frame = CGRectMake(0, 0, 44, 44);
    _RightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _RightButton.titleLabel.font = FONT(16);
    [_RightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:self.RightButton]];
    [_RightButton setTitle:[LangSwitcher switchLang:@"我的投资" key:nil] forState:(UIControlStateNormal)];
    [_RightButton addTarget:self action:@selector(myRecodeClick) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)myRecodeClick
{
    PosMyInvestmentDetailsVC *VC = [PosMyInvestmentDetailsVC new];
    VC.dataDic = self.dataDic;
    [self.navigationController pushViewController:VC animated:YES];

}

#pragma mark -- 接收到通知
- (void)InfoNotificationAction:(NSNotification *)notification{
    [self getMyCurrencyList];
    [self totalAmount];
}

#pragma mark -- 删除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOADDATA" object:nil];
}

//总收益
-(void)totalAmount
{
    TLNetworking *http = [TLNetworking new];
    http.code = @"625527";
    http.showView = self.view;
    http.parameters[@"userId"]  = [TLUser user].userId;

    [http postWithSuccess:^(id responseObject) {

        self.dataDic = responseObject[@"data"];
        self.headView.dataDic = responseObject[@"data"];
        [self.tableView reloadData];

    } failure:^(NSError *error) {

    }];
}

- (void)getMyCurrencyList {

    CoinWeakSelf;

    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];

    helper.code = @"625510";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"status"] = @"appDisplay";
    helper.isCurrency = YES;
    helper.tableView = self.tableView;
    [helper modelClass:[TLtakeMoneyModel class]];
    [self.tableView addRefreshAction:^{
        [weakSelf totalAmount];
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            //去除没有的币种
            weakSelf.Moneys = objs;
            weakSelf.tableView.Moneys = objs;
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


            weakSelf.Moneys = objs;
            weakSelf.tableView.Moneys = objs;
            //        weakSelf.tableView.bills = objs;
            [weakSelf.tableView reloadData_tl];

        } failure:^(NSError *error) {

            [weakSelf addPlaceholderView];

        }];
    }];

    [self.tableView endRefreshingWithNoMoreData_tl];

}

//-(void)getMyCurrencyList
//{
//    CoinWeakSelf;
//    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
//    helper.code = @"625510";
//    helper.parameters[@"userId"] = [TLUser user].userId;
//    helper.parameters[@"status"] = @"appDisplay";
//
//
//    helper.isCurrency = YES;
//    helper.tableView = self.tableView;
//    [helper modelClass:[TLtakeMoneyModel class]];
//
//    [self.tableView addRefreshAction:^{
//        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
//            NSMutableArray <TLtakeMoneyModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
//            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                TLtakeMoneyModel *model = (TLtakeMoneyModel *)obj;
//                [shouldDisplayCoins addObject:model];
//            }];
////            weakSelf.model = shouldDisplayCoins;
////            weakSelf.tableView.model = shouldDisplayCoins;
////            [weakSelf.tableView reloadData_tl];
//
//            weakSelf.Moneys = shouldDisplayCoins;
//            [weakSelf.tableView.Moneys removeAllObjects];
//            [weakSelf.tableView reloadData];
//            weakSelf.tableView.Moneys = shouldDisplayCoins;
//            //        weakSelf.tableView.bills = objs;
//            [weakSelf.tableView reloadData_tl];
//        } failure:^(NSError *error) {
//
//        }];
//    }];
//    [self.tableView addLoadMoreAction:^{
//
//        helper.parameters[@"userId"] = [TLUser user].userId;
//        helper.parameters[@"status"] = @"appDisplay";
//        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
//            NSLog(@" ==== %@",objs);
//            NSMutableArray <TLtakeMoneyModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
//            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                TLtakeMoneyModel *model = (TLtakeMoneyModel *)obj;
//                [shouldDisplayCoins addObject:model];
//            }];
//            weakSelf.Moneys = shouldDisplayCoins;
//
//            weakSelf.tableView.Moneys = shouldDisplayCoins;
//            //        weakSelf.tableView.bills = objs;
//            [weakSelf.tableView reloadData_tl];
//
//        } failure:^(NSError *error) {
//        }];
//    }];
//    [self.tableView beginRefreshing];
//}








- (TLMakeMoney *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[TLMakeMoney alloc] initWithFrame:CGRectMake(0, -kNavigationBarHeight + 160 - 64 + kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - (160 - 64 + kNavigationBarHeight)) style:UITableViewStylePlain];

        _tableView.refreshDelegate = self;
        _tableView.backgroundColor = kBackgroundColor;
//        [self.view addSubview:_tableView];

        

    }
    return _tableView;
}




-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TLMoneyDeailVC *money = [TLMoneyDeailVC new];
        money.moneyModel = self.Moneys[indexPath.row];
        money.currencys = self.currencys;
//        money.title = [LangSwitcher switchLang:@"理财产品详情" key:nil];
        [self.navigationController pushViewController:money animated:YES];
    }
    
}

@end
