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
#import "StoreTableView.h"
#import "StoreModel.h"
#import "UIBarButtonItem+convience.h"
#import "TLMakeMoney.h"
#import "QuestionModel.h"
#import "TLtakeMoneyModel.h"
#import "TLMoneyDeailVC.h"
#import "TLMyRecordVC.h"
#import "CurrencyModel.h"
@interface PosMiningVC ()<RefreshDelegate>
//
@property (nonatomic, strong) TLPlaceholderView *placeholderView;

@property (nonatomic , strong)UIButton *RightButton;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;

@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic,strong) NSArray <TLtakeMoneyModel *>*Moneys;

@property (nonatomic, strong) TLMakeMoney *tableView;


//@property (nonatomic, strong) TLMakeMoney *tableView1;
@end

@implementation PosMiningVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
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

    if ([TLUser user].isLogin) {
        BOOL is =  [[TLUser user] chang];

    }

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

    //敬请期待
    [self initPlaceHolderView];
    [self.view addSubview:self.tableView];
//    TLtakeMoneyModel *m = [TLtakeMoneyModel new];
//    m.name = @"币币赢第一期";
//    m.symbol = @"BTC";
//    m.expectYield = @"0.07";
//    m.minAmount = @"100";
//    m.limitAmount = @"500";
//    m.limitDays = @"360";
//    m.avilAmount = @"1000";
//    
//    TLtakeMoneyModel *m1 = [TLtakeMoneyModel new];
//    m1.name = @"币币赢第二期";
//    m1.symbol = @"BTC";
//    m1.expectYield = @"0.12";
//    m1.minAmount = @"1000";
//    m1.limitAmount = @"5000";
//
//    m1.limitDays = @"129";
//    m1.avilAmount = @"10000";
//    self.tableView.Moneys = @[m,m1];
//    self.Moneys = self.tableView.Moneys;
//    [self.tableView reloadData];
    [self getMyCurrencyList];
    [self getMySyspleList];



    
//    self.tableView.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"LOADDATA" object:nil];
    [self navigativeView];
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
    [_RightButton setTitle:@"我的投资" forState:(UIControlStateNormal)];
    [_RightButton addTarget:self action:@selector(myRecodeClick) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)myRecodeClick
{
    TLMyRecordVC *VC = [TLMyRecordVC new];
    VC.title = [LangSwitcher switchLang:@"我的理财" key:nil];
    [self.navigationController pushViewController:VC animated:YES];

}

#pragma mark -- 接收到通知
- (void)InfoNotificationAction:(NSNotification *)notification{
    [self getMyCurrencyList];
}

#pragma mark -- 删除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOADDATA" object:nil];
}

//- (void)getMyCurrencyList {
//
//    CoinWeakSelf;
//
//    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
//
//    helper.code = @"625510";
//    helper.parameters[@"userId"] = [TLUser user].userId;
//    helper.parameters[@"status"] = @"appDisplay";
//    helper.isCurrency = YES;
//    helper.tableView = self.tableView;
//    [helper modelClass:[TLtakeMoneyModel class]];
//    [self.tableView addRefreshAction:^{
//        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
//            //去除没有的币种
//            weakSelf.Moneys = objs;
//            weakSelf.tableView.Moneys = objs;
//            [weakSelf.tableView reloadData_tl];
//
//        } failure:^(NSError *error) {
//
//
//        }];
//
//
//
//    }];
//
//    [self.tableView beginRefreshing];
//
//    [self.tableView addLoadMoreAction:^{
//        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
//
//            if (weakSelf.tl_placeholderView.superview != nil) {
//
//                [weakSelf removePlaceholderView];
//            }
//
//
//            weakSelf.Moneys = objs;
//            weakSelf.tableView.Moneys = objs;
//            //        weakSelf.tableView.bills = objs;
//            [weakSelf.tableView reloadData_tl];
//
//        } failure:^(NSError *error) {
//
//            [weakSelf addPlaceholderView];
//
//        }];
//    }];
//
//    [self.tableView endRefreshingWithNoMoreData_tl];
//
//}

-(void)getMyCurrencyList
{
    CoinWeakSelf;
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"625510";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"status"] = @"appDisplay";
   

    helper.isCurrency = YES;
    helper.tableView = self.tableView;
    [helper modelClass:[TLtakeMoneyModel class]];

    [self.tableView addRefreshAction:^{
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            NSMutableArray <TLtakeMoneyModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TLtakeMoneyModel *model = (TLtakeMoneyModel *)obj;
                [shouldDisplayCoins addObject:model];
            }];
//            weakSelf.model = shouldDisplayCoins;
//            weakSelf.tableView.model = shouldDisplayCoins;
//            [weakSelf.tableView reloadData_tl];

            weakSelf.Moneys = shouldDisplayCoins;
            [weakSelf.tableView.Moneys removeAllObjects];
            [weakSelf.tableView reloadData];
            weakSelf.tableView.Moneys = shouldDisplayCoins;
            //        weakSelf.tableView.bills = objs;
            [weakSelf.tableView reloadData_tl];
        } failure:^(NSError *error) {

        }];
    }];
    [self.tableView addLoadMoreAction:^{

        helper.parameters[@"userId"] = [TLUser user].userId;
        helper.parameters[@"status"] = @"appDisplay";
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            NSLog(@" ==== %@",objs);
            NSMutableArray <TLtakeMoneyModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                TLtakeMoneyModel *model = (TLtakeMoneyModel *)obj;
                [shouldDisplayCoins addObject:model];
            }];
            weakSelf.Moneys = shouldDisplayCoins;
          
            weakSelf.tableView.Moneys = shouldDisplayCoins;
            //        weakSelf.tableView.bills = objs;
            [weakSelf.tableView reloadData_tl];

        } failure:^(NSError *error) {
        }];
    }];
    [self.tableView beginRefreshing];
}


- (void)getMySyspleList {
    
    CoinWeakSelf;
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    if (![TLUser user].isLogin) {
        return;
    }
    helper.code = @"802503";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"token"] = [TLUser user].token;
    helper.isList = YES;
    helper.isCurrency = YES;
//    helper.tableView = self.tableView1;
    [helper modelClass:[CurrencyModel class]];
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {

        //去除没有的币种


        NSMutableArray <CurrencyModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
        [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            CurrencyModel *currencyModel = (CurrencyModel *)obj;
            //                if ([[CoinUtil shouldDisplayCoinArray] indexOfObject:currencyModel.currency ] != NSNotFound ) {

            [shouldDisplayCoins addObject:currencyModel];
            //                }
            //查询总资产
        }];

        //
        weakSelf.currencys = shouldDisplayCoins;

    } failure:^(NSError *error) {


    }];


    
}






- (TLMakeMoney *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[TLMakeMoney alloc] initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];

        _tableView.refreshDelegate = self;
        _tableView.backgroundColor = kBackgroundColor;
        [self.view addSubview:_tableView];

    }
    return _tableView;
}

#pragma mark - Init
- (void)initPlaceHolderView {
//    self.view.backgroundColor = kWhiteColor;
//    UIView *topView = [[UIView alloc] init];
//    [self.view addSubview:topView];
//    topView.backgroundColor = kHexColor(@"#0848DF");
//    
//    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.height.equalTo(@(kHeight(66)));
//    }];

    
}


-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TLMoneyDeailVC *money = [TLMoneyDeailVC new];
    money.moneyModel = self.Moneys[indexPath.row];
    money.currencys = self.currencys;
    money.title = [LangSwitcher switchLang:@"理财产品详情" key:nil];
    [self.navigationController pushViewController:money animated:YES];
    
}

@end
