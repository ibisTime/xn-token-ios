//
//  TLOrderVC.m
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderVC.h"

#import "TopLabelUtil.h"
#import "OrderListTableView.h"
#import "CoinChangeView.h"
#import "FilterView.h"

#import "OrderDetailVC.h"
#import "WaitingOrderVC.h"

#import "UITabBar+Badge.h"

@interface TLOrderVC ()<SegmentDelegate, RefreshDelegate>

//货币切换
@property (nonatomic, strong) CoinChangeView *changeView;
//筛选
@property (nonatomic, strong) FilterView *filterPicker;
//
@property (nonatomic, strong) TLPageDataHelper *helper;
//切换
@property (nonatomic, strong) TopLabelUtil *labelUnil;
//暂无订单
@property (nonatomic, strong) UIView *placeHolderView;
//
@property (nonatomic, strong) OrderListTableView *tableView;
//订单列表
@property (nonatomic, strong) NSArray <OrderModel *>*orders;
//订单状态方式(进行中和已完成)
@property (nonatomic, copy) NSArray *statusList;
//当前选择
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation TLOrderVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //获取广告
    if ([TLUser user].userId) {
        
        [self requestOrderList];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //中间切换
    self.navigationItem.titleView = self.labelUnil;
    //货币切换
    [self addCoinChangeView];
    //添加通知
    [self addNotification];
    //暂无订单
    [self initPlaceHolderView];
    //订单列表
    [self initTableView];
    //添加KVO
    [self addKVO];
    
}

#pragma mark - Init
- (TopLabelUtil *)labelUnil {
    
    if (!_labelUnil) {
        
        self.currentIndex = 1;
        
        _labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 120, 25, 240, 44)];
        _labelUnil.delegate = self;
        _labelUnil.backgroundColor = [UIColor clearColor];
        _labelUnil.titleNormalColor = kTextColor;
        _labelUnil.titleSelectColor = kThemeColor;
        _labelUnil.titleFont = Font(17.0);
        _labelUnil.lineType = LineTypeTitleLength;
        
        _labelUnil.titleArray = @[@"进行中",@"已结束"];
    }
    
    return _labelUnil;
}

- (void)addCoinChangeView {
    
    CoinChangeView *coinChangeView = [[CoinChangeView alloc] init];
    
    coinChangeView.title = @"ETH";
    
    [coinChangeView addTarget:self action:@selector(changeCoin) forControlEvents:UIControlEventTouchUpInside];
    
    self.changeView = coinChangeView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:coinChangeView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        coinChangeView.title = @"ETH";
        
    });
}

- (FilterView *)filterPicker {
    
    if (!_filterPicker) {
        
        CoinWeakSelf;
        
        NSArray *textArr = @[@"ETH"];
        
        _filterPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _filterPicker.title = @"请选择货币类型";
        
        _filterPicker.selectBlock = ^(NSInteger index) {
            
            weakSelf.changeView.title = textArr[index];
            
        };
        
        _filterPicker.tagNames = textArr;
        
    }
    
    return _filterPicker;
}

- (void)initPlaceHolderView {
    //-1:待下单  0:待付款 1:待释放 2:待评价  5:仲裁中
    self.statusList = @[@"-1", @"0", @"1", @"5"];
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *orderIV = [[UIImageView alloc] init];
    
    orderIV.image = kImage(@"暂无订单");
    
    orderIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:orderIV];
    [orderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@90);
        
    }];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = @"暂无订单";
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(orderIV.mas_bottom).offset(20);
        make.centerX.equalTo(orderIV.mas_centerX);
        
    }];
}

- (void)initTableView {
    
    self.tableView = [[OrderListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.refreshDelegate = self;
    
    self.tableView.placeHolderView = self.placeHolderView;

    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

- (void)addNotification {
    //消息
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kUserLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderRefresh) name:kOrderListRefresh object:nil];

}

- (void)addKVO {
    
    CoinWeakSelf;
    
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:[IMAPlatform sharedInstance].conversationMgr keyPath:@"unReadMessageCount" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [weakSelf onUnReadMessage];
    }];
    
}

- (void)onUnReadMessage
{
    //同步消息列表
    [[IMAPlatform sharedInstance].conversationMgr asyncConversationList];
    
    NSInteger unRead = [IMAPlatform sharedInstance].conversationMgr.unReadMessageCount;
    
    if (unRead == 0) {
        
        [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
        
    }else if (unRead > 0)
    {
        [self.tabBarController.tabBar showBadgeOnItemIndex:1];

    }
    
    if (self.currentIndex == 1) {
        
        NSMutableArray *conversationList = [NSMutableArray array];
        
        [self.orders enumerateObjectsUsingBlock:^(OrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *userId = obj.isBuy ? obj.sellUserInfo.userId: obj.buyUserInfo.userId;
            
            TIMConversation *timConversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:userId];
            
            [conversationList addObject:timConversation];
            
        }];
        
        NSInteger unReadCount = [[IMAPlatform sharedInstance].conversationMgr getUnReadCountWithConversationList:[conversationList copy]];
        
        if (unReadCount == 0) {
            
            [self.labelUnil hideBadgeOnItemIndex:0];

        }else if (unReadCount > 0)
        {
            [self.labelUnil showBadgeOnItemIndex:0];

        }
    }
    
    //刷新列表
    [self.tableView reloadData_tl];
}

#pragma mark - Events
- (void)changeCoin {
    
    [self.filterPicker show];
}

- (void)calculationUnReadCount {
    
    //同步消息列表
    [[IMAPlatform sharedInstance].conversationMgr asyncConversationList];
    
    //消息栏消息数
    NSInteger unReadCount = [[IMAPlatform sharedInstance].conversationMgr unReadMessageCount];
    
    if (unReadCount > 0) {
        
        [self.tabBarController.tabBar showBadgeOnItemIndex:1];
        
    } else {
        
        [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
        
    }
    
    [self.tableView reloadData_tl];
}

- (void)orderRefresh {
    
    [self.tableView beginRefreshing];
}

#pragma mark - Data
- (void)requestOrderList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [TLPageDataHelper new];
    
    helper.code = @"625250";
    
    helper.start = 1;
    helper.limit = 20;
    
    helper.parameters[@"tradeCoin"] = @"ETH";
    helper.parameters[@"statusList"] = self.statusList;
    helper.parameters[@"tradeCurrency"] = @"CNY";
    
    helper.parameters[@"belongUser"] = [TLUser user].userId;
    
    helper.tableView = self.tableView;
    
    self.helper = helper;
    
    [helper modelClass:[OrderModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.orders = objs;
            
            weakSelf.tableView.orders = objs;
            
            [weakSelf onUnReadMessage];

        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView beginRefreshing];

    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.orders = objs;
            
            weakSelf.tableView.orders = objs;
            
            [weakSelf onUnReadMessage];

        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
    
}

#pragma mark - SegmentDelegate
-(void)segment:(TopLabelUtil *)segment didSelectIndex:(NSInteger)index {
    
    if (index == 1) {
        //-1:待下单  0:待付款 1:待释放 2:待评价  5:仲裁中
        self.statusList = @[@"-1", @"0", @"1", @"5"];
        
    }else {
        
        self.statusList = @[@"2", @"3", @"4"];
        
    }
    
    self.currentIndex = index;
    
    self.helper.parameters[@"statusList"] = self.statusList;

    [self.tableView beginRefreshing];
    
    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
    
}

#pragma mark - RefreshDelegate

- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderModel *order = self.orders[indexPath.row];
    
    NSString *friendUserId = order.isBuy ? order.sellUserInfo.userId: order.buyUserInfo.userId;
    
    NSString *friendPhoto = order.isBuy ? order.sellUserInfo.photo: order.buyUserInfo.photo;
    
    NSString *friendNickName = order.isBuy ? order.sellUserInfo.nickname: order.buyUserInfo.nickname;
    //对方
    
    IMAUser *user = [[IMAUser alloc] initWith:friendUserId];
    
    user.nickName = friendNickName;
    user.icon = [friendPhoto convertImageUrl];
    user.remark = friendNickName;
    user.userId = friendUserId;
    //我
    ChatUserProfile *userInfo = [ChatUserProfile sharedUser];
    
    userInfo.minePhoto = [TLUser user].photo;
    userInfo.mineNickName = [TLUser user].nickname;
    userInfo.friendPhoto = [friendPhoto convertImageUrl];
    userInfo.friendNickName = friendNickName;
    
    if ([order.status isEqualToString:@"-1"]) {
        
        WaitingOrderVC *chatVC = [[WaitingOrderVC alloc] initWith:user];
        
        chatVC.userInfo = userInfo;
        
        chatVC.order = order;
        
        [self.navigationController pushViewController:chatVC animated:YES];
        
        return ;
    }
    
    OrderDetailVC *chatVC = [[OrderDetailVC alloc] initWith:user];
    
    chatVC.userInfo = userInfo;
    
    chatVC.order = order;
    
    [self.navigationController pushViewController:chatVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
