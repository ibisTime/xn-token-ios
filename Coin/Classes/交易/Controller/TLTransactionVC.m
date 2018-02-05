//
//  TLTransactionVC.m
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLTransactionVC.h"
#import "TLUIHeader.h"

#import "UITabBar+Badge.h"

#import "TradeTableView.h"
#import "CoinChangeView.h"
#import "TLBannerView.h"
#import "PublishTipView.h"
#import "TopLabelUtil.h"
#import "FilterView.h"
#import "BannerModel.h"
#import "GengXinModel.h"
#import "TLUIHeader.h"
#import "WebVC.h"
#import "PublishBuyVC.h"
#import "PublishSellVC.h"
#import "TradeBuyVC.h"
#import "TradeSellVC.h"
#import "SearchVC.h"
#import "TLNavigationController.h"
#import "TLUserLoginVC.h"
#import "AdsService.h"
#import "TLPublishVC.h"
#import "AppConfig.h"
#import "PublishService.h"
#import "CoinUtil.h"
#import "TestViewController.h"

@interface TLTransactionVC ()<SegmentDelegate, RefreshDelegate, UIScrollViewDelegate>

//货币切换
@property (nonatomic, strong) CoinChangeView *changeView;
////筛选
@property (nonatomic, strong) FilterView *filterPicker;
//
@property (nonatomic, strong) TLPageDataHelper *helper;

//切换
@property (nonatomic, strong) TopLabelUtil *labelUnil;
//图片
@property (nonatomic,strong) NSMutableArray *bannerPics;
//tableview
@property (nonatomic, strong) TradeTableView *tableView;
//广告列表
@property (nonatomic, strong) NSArray <AdvertiseModel *>*advertises;
//发布
@property (nonatomic, strong) UIButton *publishBtn;
//发布界面
@property (nonatomic, strong) PublishTipView *tipView;
@property (nonatomic, assign) BOOL isFirst;

//banner
@property (nonatomic, strong) TLBannerView *bannerView;
//
@property (nonatomic,strong) NSMutableArray <BannerModel *>*bannerRoom;
//交易方式(买币和卖币)
@property (nonatomic, copy) NSString *tradeType;

//todo 开定时器去刷
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TLTransactionVC

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
    self.isFirst = YES;
    
    [self navBarUI];
    
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
    
}

- (void)refreshAds {
    
    [self.tableView beginRefreshing];
    
}

#pragma mark - Init
- (TopLabelUtil *)labelUnil {
    
    if (!_labelUnil) {
        
        _labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 120, 25, 240, 44)];
        _labelUnil.delegate = self;
        _labelUnil.backgroundColor = [UIColor clearColor];
        _labelUnil.titleNormalColor = kTextColor;
        _labelUnil.titleSelectColor = kThemeColor;
        _labelUnil.titleFont = Font(17.0);
        _labelUnil.lineType = LineTypeTitleLength;
        _labelUnil.titleArray = @[
                                  [LangSwitcher switchLang:@"买币"
                                                       key:nil],
                                  [LangSwitcher switchLang:@"卖币"
                                                       key:nil]
                                  ];
    }
    return _labelUnil;
}

- (void)navBarUI {
    
    //1.左边切换
    CoinChangeView *coinChangeView = [[CoinChangeView alloc] init];
    
    coinChangeView.title = @"ETH";
    
    [coinChangeView addTarget:self action:@selector(changeCoin) forControlEvents:UIControlEventTouchUpInside];
    
    self.changeView = coinChangeView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:coinChangeView];
    
    
    //2.右边搜索
    UIImage *searchImg = [UIImage imageNamed:@"交易_搜索"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:searchImg style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    //3.中间切换
    self.navigationItem.titleView = self.labelUnil;
    
}

- (void)setUpUI {
    
    CoinWeakSelf;
    
    self.tradeType = kAdsTradeTypeSell;
    self.tableView = [[TradeTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.placeHolderView = [TLPlaceholderView  placeholderViewWithImgAndText:@"暂无广告"];
    self.tableView.refreshDelegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    //1.banner
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, kWidth(140))];
    
    bannerView.selected = ^(NSInteger index) {
        
        if (!(weakSelf.bannerRoom[index].url && weakSelf.bannerRoom[index].url.length > 0)) {
            return ;
        }
        
        WebVC *webVC = [WebVC new];
        
        webVC.url = weakSelf.bannerRoom[index].url;
        
        [weakSelf.navigationController pushViewController:webVC animated:YES];
        
    };
    
    self.bannerView = bannerView;
    
    self.tableView.tableHeaderView = bannerView;
    
    
    //2.发布
    self.publishBtn = [UIButton buttonWithImageName:@"发布"];
    
    [self.publishBtn addTarget:self action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.publishBtn];
    [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-12);
        
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
        
        NSArray *textArr = [CoinUtil shouldDisplayCoinArray];
        
        //        NSArray *typeArr = @[@"", @"charge", @"withdraw", @"buy", @"sell"];
        
        _filterPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _filterPicker.title = @"请选择货币类型";
        _filterPicker.tagNames = textArr;
        _filterPicker.selectBlock = ^(NSInteger index) {
            
            weakSelf.changeView.title = textArr[index];
            [weakSelf changePageHelperCoin:textArr[index] pageHelper:weakSelf.helper];
            [weakSelf.tableView beginRefreshing];
            
        };
        
    }
    
    return _filterPicker;
}


- (void)addNotification{
    //发布购买/出售
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:kAdvertiseListRefresh object:nil];
    
    //信任/取消信任
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kTrustNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOut) name:kUserLoginOutNotification object:nil];
    
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
        
//        if ([PublishService isDevPublish]) {
        
            [[PublishService shareInstance] publishBuy:self.navigationController];
            


//        } else {
//
//            PublishBuyVC *buyVC = [PublishBuyVC new];
//            buyVC.publishType = PublishTypePublishOrSaveDraft;
//            [self.navigationController pushViewController:buyVC animated:YES];
//        }
        

        
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
        
        
//        if ([PublishService isDevPublish]) {
        
            [[PublishService shareInstance] publishSell:self.navigationController];
            
//            TLPublishVC *sellVC = [[TLPublishVC alloc] init];
//            sellVC.VCType = TLPublishVCTypeSell;
//            sellVC.publishType = PublishTypePublishOrSaveDraft;
//            [self.navigationController pushViewController:sellVC animated:YES];
            
//        } else {
//
//        PublishSellVC *sellVC = [PublishSellVC new];
//        sellVC.publishType = PublishTypePublishOrSaveDraft;
//        [self.navigationController pushViewController:sellVC animated:YES];
//
//        }
        
    }
}

- (void)refreshData:(NSNotification *)notification {
    
    NSInteger index = [notification.object integerValue];
    [self.labelUnil selectSortBarWithIndex:index];
    
}

- (void)refreshData {
    
    [self.tableView beginRefreshing];
    
}

#pragma mark - Data
- (void)getBanner {
    
    //广告图
    __weak typeof(self) weakSelf = self;
    
    TLNetworking *http = [TLNetworking new];
    //806052
    http.code = @"805806";
    http.parameters[@"type"] = @"2";
    http.parameters[@"location"] = @"trade";
    
    [http postWithSuccess:^(id responseObject) {
        
        weakSelf.bannerRoom = [BannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //组装数据
        weakSelf.bannerPics = [NSMutableArray arrayWithCapacity:weakSelf.bannerRoom.count];
        
        //取出图片
        [weakSelf.bannerRoom enumerateObjectsUsingBlock:^(BannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [weakSelf.bannerPics addObject:[obj.pic convertImageUrl]];
        }];
        
        weakSelf.bannerView.imgUrls = weakSelf.bannerPics;
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)changePageHelperCoin:(NSString *)coin pageHelper:(TLPageDataHelper *)helper; {
    
    helper.parameters[@"coin"] = coin;
    
}

- (void)requestAdvetiseList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [TLPageDataHelper new];
    helper.code = @"625228";
    helper.start = 1;
    helper.limit = 20;
    [self changePageHelperCoin:kETH pageHelper:helper];
    helper.parameters[@"tradeType"] = self.tradeType;
    helper.tableView = self.tableView;
    self.helper = helper;
    
    [helper modelClass:[AdvertiseModel class]];
    
    [self.tableView addRefreshAction:^{
        
        //banner
        [weakSelf getBanner];
        
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

//    if ([AppConfig config].runEnv == RunEnvDev) {
//        
//        TestViewController *testVC = [[TestViewController alloc] init];
//        [self.navigationController pushViewController:testVC animated:YES];
//        return;
//    }
    
    if (index == 1) {
        
        self.tradeType = kAdsTradeTypeSell;
        
    } else if(index == 2) {
        
        self.tradeType = kAdsTradeTypeBuy;
        
    }
    
    self.helper.parameters[@"tradeType"] = self.tradeType;
    
    [self.tableView beginRefreshing];
    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
    
}


#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AdvertiseModel *advertiseModel = self.advertises[indexPath.row];
    [AdsService pushToAdsDetail:advertiseModel currentVC:self];
}

@end
