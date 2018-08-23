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
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;

@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic,strong) NSArray <TLtakeMoneyModel *>*Moneys;

@property (nonatomic, strong) TLMakeMoney *tableView;


@property (nonatomic, strong) TLMakeMoney *tableView1;
@end

@implementation PosMiningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"量化理财" key:nil];
    //敬请期待
    [self initPlaceHolderView];
    [self.view addSubview:self.tableView1];
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
    [UIBarButtonItem addRightItemWithTitle:[LangSwitcher switchLang:@"我的理财" key:nil] titleColor:kWhiteColor frame:CGRectMake(0, 0, 80, 40) vc:self action:@selector(myRecodeClick)];
    
//    self.tableView.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"LOADDATA" object:nil];
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
    helper.tableView = self.tableView1;
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
    
//    [self.tableView addLoadMoreAction:^{
//        helper.parameters[@"userId"] = [TLUser user].userId;
//        helper.parameters[@"token"] = [TLUser user].token;
//        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
//
//            //去除没有的币种
//
//
//            NSMutableArray <CurrencyModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
//            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                CurrencyModel *currencyModel = (CurrencyModel *)obj;
//                //                if ([[CoinUtil shouldDisplayCoinArray] indexOfObject:currencyModel.currency ] != NSNotFound ) {
//
//                [shouldDisplayCoins addObject:currencyModel];
//                //                }
//                //查询总资产
//
//            }];
//
//            //
//            weakSelf.currencys = shouldDisplayCoins;
//
//        } failure:^(NSError *error) {
//
//
//        }];
//
//    }];

    
}


- (void)myRecodeClick
{
    TLMyRecordVC *VC = [TLMyRecordVC new];
    VC.title = [LangSwitcher switchLang:@"我的理财" key:nil];
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (TLMakeMoney *)tableView1 {

    if (!_tableView1) {

        _tableView1 = [[TLMakeMoney alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];

        //        _tableView.placeHolderView = self.placeHolderView;
        _tableView1.refreshDelegate = self;
        _tableView1.backgroundColor = kWhiteColor;
        _tableView1.frame = CGRectMake(0, 0, 0, 0);
        [self.view addSubview:_tableView1];
//        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 15));
//        }];

    }
    return _tableView1;
}

- (TLMakeMoney *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[TLMakeMoney alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        //        _tableView.placeHolderView = self.placeHolderView;
        _tableView.refreshDelegate = self;
        _tableView.backgroundColor = kWhiteColor;

        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 15));
        }];
        
    }
    return _tableView;
}

#pragma mark - Init
- (void)initPlaceHolderView {
    self.view.backgroundColor = kWhiteColor;
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    topView.backgroundColor = kHexColor(@"#0848DF");
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(kHeight(66)));
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
