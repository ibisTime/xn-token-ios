//
//  TLTransactionVC.m
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLPushVC.h"
#import "TLUIHeader.h"
#import "UITabBar+Badge.h"
#import "PushTradeTableView.h"
#import "CoinChangeView.h"
#import "PublishTipView.h"
#import "TopLabelUtil.h"
#import "FilterView.h"
#import "GengXinModel.h"
#import "TLUIHeader.h"
#import "WebVC.h"
#import "TradeBuyVC.h"
#import "TradeSellVC.h"
#import "SearchVC.h"
#import "TLNavigationController.h"
#import "TLUserLoginVC.h"
#import "PushAdsService.h"
#import "TLPublishVC.h"
#import "AppConfig.h"
#import "PushPublishService.h"
#import "CoinUtil.h"
#import "TestViewController.h"
#import "CoinService.h"
#import "TLNotficationService.h"
#import "CoinModel.h"
#import "PushSelectScrollView.h"
#import "MyAdvertiseVC.h"
#import "TLOrderVC.h"
#import "LastestPriceModel.h"

@interface TLPushVC ()<SegmentDelegate, RefreshDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray <CoinModel *>*coins;
//货币切换
@property (nonatomic, strong) CoinChangeView *changeView;
////筛选
@property (nonatomic, strong) FilterView *filterPicker;
//
@property (nonatomic, strong) TLPageDataHelper *helper;

//顶部切换
@property (nonatomic, strong) TopLabelUtil *labelUnil;

//最新成交价格
@property (nonatomic, strong) TLBaseLabel *lastestPrice;

//币种切换
@property (nonatomic, strong) PushSelectScrollView *selectScrollView;

//tableview
@property (nonatomic, strong) PushTradeTableView *tableView;
//广告列表
@property (nonatomic, strong) NSArray <AdvertiseModel *>*advertises;
//发布
@property (nonatomic, strong) UIButton *publishBtn;
//发布界面
@property (nonatomic, strong) PublishTipView *tipView;
@property (nonatomic, assign) BOOL isFirst;

//交易方式(买币和卖币)
@property (nonatomic, copy) NSString *tradeType;

//todo 开定时器去刷
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TLPushVC

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //
    if (self.advertises && self.advertises.count > 0) {
        
        [self.tableView reloadData_tl];
        
    }
    
    //
    if (self.isFirst) {
        
        self.isFirst = NO;
        [self.tableView beginRefreshing];
        
    }
    
}

- (void)test {
    
    TLPublishVC *sellVC =  [[TLPublishVC alloc] init];
    sellVC.publishType = PublishTypePublishOrSaveDraft;
    [self.navigationController pushViewController:sellVC animated:YES];
    
    
    
    //      [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[TLPublishSellVC alloc] init] animated:YES completion:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"PUSH";
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"802267";
    
    http.parameters[@"status"] = @"0";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSMutableArray *coinList = responseObject[@"data"];
        
        [[CoinModel coin] saveOpenCoinList:coinList];
        
        self.isFirst = YES;
        
//        [self navBarUI];
        
        [self setUpUI];
        //获取广告
        [self requestAdvetiseList];
        //添加通知
        [self addNotification];
        
        // 定时器去刷新广告列表
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5*60
                                                      target:self
                                                    selector:@selector(refreshAds)
                                                    userInfo:nil
                                                     repeats:YES];
        
        
        
        
    } failure:^(NSError *error) {
        NSLog(@"787878");
        
    }];
    
}







- (void)refreshAds {
    
    [self.tableView beginRefreshing];
    
}

#pragma mark - Init
- (PushSelectScrollView *)selectScrollView {
    
    CoinWeakSelf;
    
    if (!_selectScrollView) {
        
        NSArray *titleArray = @[
                                [LangSwitcher switchLang:@"买入" key:nil],
                                [LangSwitcher switchLang:@"卖出" key:nil],
                                [LangSwitcher switchLang:@"交易单" key:nil],
                                [LangSwitcher switchLang:@"订单" key:nil]
                                ];
        
        _selectScrollView = [[PushSelectScrollView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 47) itemTitles:titleArray];
        
//        NSMutableArray<CoinModel *> *coins = [CoinUtil shouldDisplayCoinModelArray];
        
        [_selectScrollView setSelectBlock:^(NSInteger index) {
            
            //判断点击的Controller是不是需要登录，如果是，那就登录
            if((index == 2 || index == 3 ) && ![TLUser user].isLogin) {
                
                TLUserLoginVC *loginVC = [TLUserLoginVC new];
                
                loginVC.loginSuccess = ^{
                    
                    if(index == 2) {
                        
                        MyAdvertiseVC *advertiseVC = [MyAdvertiseVC new];
                        advertiseVC.defaultCoin = [CoinService shareService].currentToken.symbol;
                        [weakSelf.navigationController pushViewController:advertiseVC animated:YES];
                        
                        
                    } else if(index == 3) {
                        
                        TLOrderVC *orderVC = [TLOrderVC new];
                        [weakSelf.navigationController pushViewController:orderVC animated:YES];
                        
                    }
                    
                };
                
                TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
                [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
                
            }
            
            if (index == 0) {
                
                weakSelf.tradeType = kAdsTradeTypeSell;
                weakSelf.helper.parameters[@"tradeType"] = weakSelf.tradeType;
                [weakSelf.tableView beginRefreshing];
                [weakSelf.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
                
            } else if(index == 1) {
                
                weakSelf.tradeType = kAdsTradeTypeBuy;
                weakSelf.helper.parameters[@"tradeType"] = weakSelf.tradeType;
                [weakSelf.tableView beginRefreshing];
                [weakSelf.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
                
            } else if(index == 2) {
                
                MyAdvertiseVC *advertiseVC = [MyAdvertiseVC new];
                advertiseVC.defaultCoin = [CoinService shareService].currentToken.symbol;
                [weakSelf.navigationController pushViewController:advertiseVC animated:YES];
                
                
            } else if(index == 3) {
                
                TLOrderVC *orderVC = [TLOrderVC new];
                [weakSelf.navigationController pushViewController:orderVC animated:YES];
                
            }
            
            
            
        }];
    }
    return _selectScrollView;
}

- (void)navBarUI {
    
    //1.左边切换
        CoinChangeView *coinChangeView = [[CoinChangeView alloc] initWithFrame:CGRectMake(0, 0, 55, 40)];
    
        NSArray *textArr = [CoinUtil shouldDisplayTokenCoinArray];
    
        coinChangeView.title = [NSString stringWithFormat:@"%@/CNY", textArr[0]];
    
        [coinChangeView addTarget:self action:@selector(changeCoin) forControlEvents:UIControlEventTouchUpInside];
    
        self.changeView = coinChangeView;
    
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:coinChangeView];
    
    
    //2.右边搜索
//    UIImage *searchImg = [UIImage imageNamed:@"交易_搜索"];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:searchImg style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    //3.中间切换
//    self.tableView.tableHeaderView = self.labelUnil;
    
}

- (void)setUpUI {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    topView.backgroundColor = [UIColor whiteColor];
//    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view.centerX);
//    }];
//    [self.view addSubview:topView];
    
    //币种切换
    CoinChangeView *coinChangeView = [[CoinChangeView alloc] initWithFrame:CGRectMake(15, 0, 95, topView.height)];
    
    NSArray *textArr = [CoinUtil shouldDisplayTokenCoinArray];
    
    coinChangeView.title = [NSString stringWithFormat:@"%@/CNY", textArr[0]];
    
    [coinChangeView addTarget:self action:@selector(changeCoin) forControlEvents:UIControlEventTouchUpInside];
    
    self.changeView = coinChangeView;
    
    [topView addSubview:coinChangeView];
    
    //更多币种label
    CGFloat moreLabelWidth = 46;
    TLBaseLabel *moreLabel = [TLBaseLabel labelWithFrame:CGRectMake(coinChangeView.right + 10, 0, moreLabelWidth, coinChangeView.height)
                                            textAligment:NSTextAlignmentCenter
                                         backgroundColor:[UIColor whiteColor]
                                                    font:[UIFont systemFontOfSize:11]
                                               textColor:[UIColor textColor2]];
    moreLabel.text = [LangSwitcher switchLang:@"更多币种" key:nil];
    [topView addSubview:moreLabel];
    
    //最新成交价文字
    CGFloat newPriceTWidth = 58;
    TLBaseLabel *newPriceT = [TLBaseLabel labelWithFrame:CGRectMake(SCREEN_WIDTH - newPriceTWidth - 15,
                                                                    0,
                                                                    newPriceTWidth,
                                                                    coinChangeView.height)
                                            textAligment:NSTextAlignmentRight
                                         backgroundColor:[UIColor whiteColor]
                                                    font:[UIFont systemFontOfSize:11]
                                               textColor:[UIColor themeColor]];
    newPriceT.text = [LangSwitcher switchLang:@"最新成交价" key:nil];
    [topView addSubview:newPriceT];
    
    //最新成交价格
    CGFloat newPriceWidth = SCREEN_WIDTH - coinChangeView.width - moreLabel.width - newPriceT.width - 60;
    self.lastestPrice = [TLBaseLabel labelWithFrame:CGRectMake(coinChangeView.width + moreLabel.width + 35,
                                                                   0,
                                                                   newPriceWidth,
                                                                   coinChangeView.height)
                                           textAligment:NSTextAlignmentRight
                                        backgroundColor:[UIColor whiteColor]
                                                   font:[UIFont systemFontOfSize:18]
                                              textColor:[UIColor themeColor]];
    self.lastestPrice.text = [LangSwitcher switchLang:@"￥0.00" key:nil];
    [topView addSubview:self.lastestPrice];
    
    [self.view addSubview:topView];
    
    //交易列表
    self.tradeType = kAdsTradeTypeSell;
    self.tableView = [[PushTradeTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.placeHolderView = [TLPlaceholderView  placeholderViewWithImgAndText:@"暂无广告"];
    self.tableView.refreshDelegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    //    if (@available(iOS 11.0, *)) {
    //
    //        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    //    }
    

    //table表头tab切换
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 47 + 10)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    
    [headerView addSubview:self.selectScrollView];
    
//    [self.selectScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(headerView.mas_bottom);
//        make.width.equalTo(@(SCREEN_WIDTH));
//        make.height.equalTo(@(44));
//        make.left.equalTo(@(0));
//    }];
    
    
    
    self.tableView.tableHeaderView = headerView;
    
    
    //2.发布
    self.publishBtn = [UIButton buttonWithImageName:@"发布"];
    
    [self.publishBtn addTarget:self action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.publishBtn];
    [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        
    }];
    
    [self initTipView];
    
}


- (void)initTipView {
    
    CoinWeakSelf;
    
    NSArray *titles = @[
                        [LangSwitcher switchLang:@"发布购买" key:nil],
                        [LangSwitcher switchLang:@"发布卖出" key:nil]
                        ];
    
    _tipView = [[PublishTipView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) titles:titles];
    
    _tipView.publishBlock = ^(NSInteger index) {
        
        [weakSelf publishEventsWithIndex:index];
        
    };
}

#pragma mark- 币种切换事件
- (FilterView *)filterPicker {
    
    if (!_filterPicker) {
        
        CoinWeakSelf;
        
        NSMutableArray<CoinModel *> *tokens = [CoinUtil shouldDisplayTokenCoinModelArray];
        NSMutableArray *textArr = [[NSMutableArray alloc] init];
        for (CoinModel *coinModel in tokens) {
            [textArr addObject:coinModel.symbol];
        }
        
        _filterPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _filterPicker.title = @"请选择货币类型";
        _filterPicker.tagNames = textArr;
        _filterPicker.selectBlock = ^(NSInteger index) {
            
            [CoinService shareService].currentToken = tokens[index];
            weakSelf.changeView.title = [NSString stringWithFormat:@"%@/CNY", textArr[index]];
            [weakSelf changePageHelperCoin:textArr[index] pageHelper:weakSelf.helper];
            [weakSelf.tableView beginRefreshing];
            
        };
        
    }
    
    return _filterPicker;
}


- (void)addNotification{
    //发布购买/出售
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData:)
                                                 name:kPushAdvertiseListRefresh
                                               object:nil];
    
    //信任/取消信任
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kTrustNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLoginOut)
                                                 name:kUserLoginOutNotification
                                               object:nil];
    
}

- (void)userLoginOut {
    
    self.helper.parameters[@"token"] = nil;
    
}

#pragma mark - Events
- (void)changeCoin {
    
    [self.filterPicker show];
}

- (void)search {
    
    SearchVC *searchVC = [SearchVC new];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark- 点击发布按钮
- (void)clickPublish {
    
    [self.tipView show];
}

#pragma mark- 发布界面
- (void)publishEventsWithIndex:(NSInteger)index {
    
    CoinWeakSelf;
    
    if (index == 0) {
        
        if (![TLUser user].isLogin) {
            
            TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
            TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
            loginVC.loginSuccess = ^(){
                
                [weakSelf publishEventsWithIndex:0];
            };
            
            [self presentViewController:nav animated:YES completion:nil];
            
            return;
        }
        
        
        [[PushPublishService shareInstance] publishBuy:self.navigationController];
        
    } else if (index == 1) {
        
        if (![TLUser user].isLogin) {
            
            TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
            
            TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
            
            loginVC.loginSuccess = ^(){
                
                [weakSelf publishEventsWithIndex:1];
            };
            
            [self presentViewController:nav animated:YES completion:nil];
            
            return;
        }
        
        
        [[PushPublishService shareInstance] publishSell:self.navigationController];
        
    }
    
}

- (void)refreshData:(NSNotification *)notification {
    
    id obj = notification.object;
    if ([obj isKindOfClass:[TLNotificationObj class]]) {
        
        TLNotificationObj *notiObj = (TLNotificationObj *)obj;
        
        //币种改变
        CoinModel *coin = [CoinUtil getCoinModel:notiObj.content];
        [CoinService shareService].currentToken = coin;
        [self changePageHelperCoin:[CoinService shareService].currentToken.symbol
                        pageHelper:self.helper];
        self.changeView.title = [NSString stringWithFormat:@"%@/CNY", [CoinService shareService].currentToken.symbol];
        
        //左右切换
        NSInteger index = [notiObj.subContent integerValue];
        index = index == 1 ? 0 : 1;
        [self.labelUnil selectSortBarWithIndex:index];
        
        
    }
    
}

- (void)refreshData {
    
    [self.tableView beginRefreshing];
    
}


- (void)changePageHelperCoin:(NSString *)coin pageHelper:(TLPageDataHelper *)helper; {
    
    helper.parameters[@"coin"] = coin;
    
}

- (void)getLastestPrice {
    
    //最新成交价
    __weak typeof(self) weakSelf = self;
    
    TLNetworking *http = [TLNetworking new];
    //806052
    http.code = @"625283";
    http.parameters[@"tradeCoin"] = [CoinService shareService].currentToken.symbol;
    
    [http postWithSuccess:^(id responseObject) {
        
        LastestPriceModel *price = [LastestPriceModel mj_objectWithKeyValues:responseObject[@"data"]];
        weakSelf.lastestPrice.text = [NSString stringWithFormat:@"￥%.2f", price.lastestPrice.doubleValue];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)requestAdvetiseList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [TLPageDataHelper new];
    helper.code = @"625228";
    helper.start = 1;
    helper.limit = 20;
    
    [self changePageHelperCoin:[CoinService shareService].currentToken.symbol pageHelper:helper];
    helper.parameters[@"tradeType"] = self.tradeType;
    helper.tableView = self.tableView;
    self.helper = helper;
    
    [helper modelClass:[AdvertiseModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [weakSelf getLastestPrice];
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.advertises = objs;
            weakSelf.tableView.advertises = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //
            //                [weakSelf requestAdvetiseList];
            //            });
            
        }];
    }];
    
    [self.tableView beginRefreshing];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.advertises = objs;
            
            weakSelf.tableView.advertises = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
    
}



#pragma mark - SegmentDelegate
-(void)segment:(TopLabelUtil *)segment didSelectIndex:(NSInteger)index {
    
    if (index == 1) {
        
        self.tradeType = kAdsTradeTypeSell;
        
    } else if(index == 2) {
        
        self.tradeType = kAdsTradeTypeBuy;
        
    }
    
    self.helper.parameters[@"tradeType"] = self.tradeType;
    
    [self.tableView beginRefreshing];
    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
    
    //    if ([AppConfig config].runEnv == RunEnvDev) {
    //
    //        TestViewController *testVC = [[TestViewController alloc] init];
    //        [self.navigationController pushViewController:testVC animated:YES];
    //        return;
    //    }
    
    
    
}


#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AdvertiseModel *advertiseModel = self.advertises[indexPath.row];
    [PushAdsService pushToAdsDetail:advertiseModel currentVC:self];
}

@end

