//
//  TLTransactionVC.m
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLTransactionVC.h"
#import "TLUIHeader.h"

#import "TradeTableView.h"
#import "CoinChangeView.h"
#import "TLBannerView.h"
#import "PublishTipView.h"
#import "TopLabelUtil.h"

#import "BannerModel.h"

#import "WebVC.h"
#import "PublishBuyVC.h"
#import "PublishSellVC.h"
#import "TradeBuyVC.h"
#import "TradeSellVC.h"

@interface TLTransactionVC ()<SegmentDelegate, RefreshDelegate>

@property (nonatomic, strong) TLPageDataHelper *helper;
//暂无交易
@property (nonatomic, strong) UIView *placeHolderView;
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
//banner
@property (nonatomic, strong) TLBannerView *bannerView;
//
@property (nonatomic,strong) NSMutableArray <BannerModel *>*bannerRoom;
//交易方式(买币和卖币)
@property (nonatomic, copy) NSString *tradeType;

@end

@implementation TLTransactionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarUI];
    
    [self setUpUI];
    //banner
    [self getBanner];
    //获取广告
    [self requestAdvetiseList];
    //添加通知
    [self addNotification];

}

#pragma mark- 交易搜索
- (void)search {
    
}

#pragma mark - Init

-(TopLabelUtil *)labelUnil {
    
    if (!_labelUnil) {
        
        _labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 120, 25, 240, 44)];
        _labelUnil.delegate = self;
        _labelUnil.backgroundColor = [UIColor clearColor];
        _labelUnil.titleNormalColor = kTextColor;
        _labelUnil.titleSelectColor = kThemeColor;
        _labelUnil.titleFont = Font(17.0);
        _labelUnil.lineType = LineTypeTitleLength;

        _labelUnil.titleArray = @[@"买币",@"卖币"];
    }
    return _labelUnil;
}

- (void)navBarUI {
    
    //1.左边切换
    CoinChangeView *coinChangeView = [[CoinChangeView alloc] init];
    coinChangeView.title = @"ETH";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:coinChangeView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        coinChangeView.title = @"ETH";

    });
    
    //2.右边搜索
    UIImage *searchImg = [UIImage imageNamed:@"交易_搜索"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:searchImg style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    //3.中间切换
    
    self.navigationItem.titleView = self.labelUnil;


}

- (void)setUpUI {
    
    CoinWeakSelf;
    
    self.tradeType = @"1";
    
    [self initPlaceHolderView];
    
    self.tableView = [[TradeTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = self.placeHolderView;
    
    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
   //1.banner
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 140)];
    
    bannerView.selected = ^(NSInteger index) {
        
        if (!(self.bannerRoom[index].url && self.bannerRoom[index].url.length > 0)) {
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

- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *couponIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 80, 80)];
    
    couponIV.image = kImage(@"暂无订单");
    
    couponIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:couponIV];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = @"暂无交易";
    
    textLbl.frame = CGRectMake(0, couponIV.yy + 20, kScreenWidth, 15);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
}

- (void)initTipView {
    
    CoinWeakSelf;
    
    NSArray *titles = @[@"发布购买", @"发布卖出"];
    
    _tipView = [[PublishTipView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) titles:titles];
    
    _tipView.publishBlock = ^(NSInteger index) {
        
        [weakSelf publishEventsWithIndex:index];

    };
}

- (void)addNotification{
    //发布购买/出售
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:kAdvertiseListRefresh object:nil];
    
    //信任/取消信任
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kTrustNotification object:nil];
}

#pragma mark - Events
- (void)clickPublish {
    
    [self.tipView show];
}

- (void)publishEventsWithIndex:(NSInteger)index {
 
    if (index == 0) {

        PublishBuyVC *buyVC = [PublishBuyVC new];
        
        [self.navigationController pushViewController:buyVC animated:YES];
        
    } else if (index == 1) {
        
        PublishSellVC *sellVC = [PublishSellVC new];
        
        [self.navigationController pushViewController:sellVC animated:YES];
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

- (void)requestAdvetiseList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [TLPageDataHelper new];
    
    helper.code = @"625228";
    
    helper.start = 1;
    helper.limit = 20;
    
    helper.parameters[@"coin"] = @"ETH";
    helper.parameters[@"tradeType"] = self.tradeType;
    
    helper.tableView = self.tableView;
    
    self.helper = helper;
    
    [helper modelClass:[AdvertiseModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.advertises = objs;
            
            weakSelf.tableView.advertises = objs;

            [weakSelf.tableView reloadData_tl];

        } failure:^(NSError *error) {
            
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
        
        self.tradeType = @"1";
        
    }else {
        
        self.tradeType = @"0";

    }
    
    self.helper.parameters[@"tradeType"] = self.tradeType;

    [self.tableView beginRefreshing];
    
    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];

}

#pragma mark - RefreshDelegate

- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.tradeType isEqualToString:@"1"]) {
        
        TradeBuyVC *buyVC = [TradeBuyVC new];
        
        buyVC.advertise = self.advertises[indexPath.row];
        
        [self.navigationController pushViewController:buyVC animated:YES];
    } else {
        
        TradeSellVC *sellVC = [TradeSellVC new];
        
        sellVC.advertise = self.advertises[indexPath.row];
        
        [self.navigationController pushViewController:sellVC animated:YES];
    }
    
    
}
@end
