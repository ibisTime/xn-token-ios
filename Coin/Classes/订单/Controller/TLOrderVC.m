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

#import "OrderDetailVC.h"
#import "WaitingOrderVC.h"

@interface TLOrderVC ()<SegmentDelegate, RefreshDelegate>

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

@end

@implementation TLOrderVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //获取广告
    [self requestOrderList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //中间切换
    self.navigationItem.titleView = self.labelUnil;
    //添加通知
    [self addNotification];
    //暂无订单
    [self initPlaceHolderView];
    //订单列表
    [self initTableView];
    
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
        
        _labelUnil.titleArray = @[@"进行中",@"已结束"];
    }
    
    return _labelUnil;
}

- (void)initPlaceHolderView {
    //-1:待下单  0:待付款 1:待释放 2:待评价  5:仲裁中
    self.statusList = @[@"-1", @"0", @"1", @"2", @"5"];
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *couponIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 80, 80)];
    
    couponIV.image = kImage(@"暂无订单");
    
    couponIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:couponIV];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = @"暂无订单";
    
    textLbl.frame = CGRectMake(0, couponIV.yy + 20, kScreenWidth, 15);
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
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
    
    
}

#pragma mark - Init
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
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView beginRefreshing];

    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.orders = objs;
            
            weakSelf.tableView.orders = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
    
}

#pragma mark - SegmentDelegate
-(void)segment:(TopLabelUtil *)segment didSelectIndex:(NSInteger)index {
    
    if (index == 1) {
        //-1:待下单  0:待付款 1:待释放 2:待评价  5:仲裁中
        self.statusList = @[@"-1", @"0", @"1", @"2", @"5"];
        
    }else {
        
        self.statusList = @[@"3", @"4"];
        
    }
    
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
