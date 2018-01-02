//
//  TLOrderVC.m
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderVC.h"

#import "TopLabelUtil.h"
#import "CoinChangeView.h"
#import "FilterView.h"
#import "ChatManager.h"
#import "OrderDetailVC.h"
#import "WaitingOrderVC.h"
#import "OrderModel.h"
#import <CDCommon/DeviceUtil.h>
#import "OrderListVC.h"

@interface TLOrderVC ()<SegmentDelegate, RefreshDelegate, MsgDelegate>

//货币切换
@property (nonatomic, strong) CoinChangeView *changeView;
@property (nonatomic, strong) TopLabelUtil *labelUnil;
@property (nonatomic, strong) UIScrollView *switchScrollView;
@property (nonatomic, strong) OrderListVC *ingOrderListVC;
@property (nonatomic, strong) OrderListVC *endOrderListVC;

@end

@implementation TLOrderVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //中间切换
    self.navigationItem.titleView = self.labelUnil;
    
    //货币切换
    [self addCoinChangeView];
    
    //添加通知
    [self addNotification];

    //添加KVO
    [self addUnReadMsgKVO];
    
    //TODO 如果切换账户 把订单清除掉
    [self setUpUI];
    
    [self setUpChildVC];
    
    //
    [IMAPlatform sharedInstance].conversationMgr.msgDelegate = self;

}

- (void)test {
    
//    IMAUser *user
//    [[IMAPlatform sharedInstance].conversationMgr chatWith:<#(IMAUser *)#>]
    
}


- (void)addNotification {
    //消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderRefresh) name:kOrderListRefresh object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOut) name:kUserLoginOutNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kUserLoginNotification object:nil];

}


// 该方法只处理顶部红点逻辑
- (void)handleGroupMsg:(NSString *)groupId msg:(TIMMessage *) msg {
    
    /*
     此处应该为，拿订单号去查询订单详情。先区分，左边 还是 右边
     1.
        如果订单列表，中有该数据，把这个数据移动到，第一位。否则把该数据插入到订单列表中。
        并移动到第一位
     */
    //1. 获取订单详情
    TLNetworking *http = [TLNetworking new];
    http.code = @"625251";
    http.parameters[@"code"] = groupId;
    [http postWithSuccess:^(id responseObject) {
        
     OrderModel *orderModel =  [OrderModel tl_objectWithDictionary:responseObject[@"data"]];
        
        __block BOOL hasLook = NO;
        [OrderModel.ingStatusList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([orderModel.status equalsString:obj]) {
                //正在进行的订单，左边
                [self.labelUnil showBadgeOnItemIndex:0];
                hasLook = YES;
//                [self orderRefresh];
            }
        }];
        
        if (!hasLook) {
            [self.labelUnil showBadgeOnItemIndex:1];
        }
       
        
    } failure:^(NSError *error) {
        
    }];

    
}

//
- (void)userLogin {
    //
    [IMAPlatform sharedInstance].conversationMgr.msgDelegate = self;
    self.ingOrderListVC.pageDataHelper.parameters[@"belongUser"] = [TLUser user].userId;
    self.endOrderListVC.pageDataHelper.parameters[@"belongUser"] = [TLUser user].userId;
    [self addUnReadMsgKVO];
    [self orderRefresh];
    
}

// 用户登出，把订单数据清除掉
- (void)userLoginOut {
    
    
    self.ingOrderListVC.orderGroups = [[NSMutableArray alloc] init];
    self.endOrderListVC.orderGroups = [[NSMutableArray alloc] init];
    //
    [self orderReloadData];

}

- (void)orderReloadData {
    
    [self.ingOrderListVC reloadData];
    [self.endOrderListVC reloadData];
    
}

- (void)changeTopMsgRedHintToZero {
    
    [self.labelUnil hideBadgeOnItemIndex:0];
    [self.labelUnil hideBadgeOnItemIndex:1];

}

- (void)orderRefresh {
    
    [self.ingOrderListVC refresh];
    [self.endOrderListVC refresh];

}

#pragma mark- 添加未读消息 的 观察
- (void)addUnReadMsgKVO {
    
    CoinWeakSelf;
    // 这里不负责tabbar 上的改变
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:[IMAPlatform sharedInstance].conversationMgr
                        keyPath:@"unReadMessageCount"
                        options:NSKeyValueObservingOptionNew
                          block:^(id observer, id object, NSDictionary *change) {
                              
                              if ([IMAPlatform sharedInstance].conversationMgr.unReadMessageCount <= 0) {
                                  
                                  //让顶部的取置0
                                  [weakSelf changeTopMsgRedHintToZero];
                                  [weakSelf orderReloadData];
                              } else {
                                  [weakSelf orderRefresh];

                              }
                              
    }];
    
}




#pragma mark - SegmentDelegate, 顶部切换
-(void)segment:(TopLabelUtil *)segment didSelectIndex:(NSInteger)index {
    
    [self.switchScrollView setContentOffset:CGPointMake((index - 1) * self.switchScrollView.width, 0)];
    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
    
}


- (void)setUpChildVC {
    
    //1. 进行中
    self.ingOrderListVC = [[OrderListVC alloc] init];
    self.ingOrderListVC.statusList = [OrderModel ingStatusList];
    self.ingOrderListVC.view.frame = CGRectMake(0,0,self.switchScrollView.width,self.switchScrollView.height);
    [self addChildViewController:self.ingOrderListVC];
    [self.switchScrollView addSubview:self.ingOrderListVC.view];
    
    //2. 结束
    self.endOrderListVC = [[OrderListVC alloc] init];
    self.endOrderListVC.statusList = [OrderModel endStatusList];
    self.endOrderListVC.view.frame = CGRectMake(self.switchScrollView.width,0,self.switchScrollView.width,self.switchScrollView.height);
    [self addChildViewController:self.endOrderListVC];
    [self.switchScrollView addSubview:self.endOrderListVC.view];
    
}

- (void)setUpUI {
    
    //0.顶部切换
    self.labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 120, 25, 240, 44)];
    self.labelUnil.delegate = self;
    self.labelUnil.backgroundColor = [UIColor clearColor];
    self.labelUnil.titleNormalColor = kTextColor;
    self.labelUnil.titleSelectColor = kThemeColor;
    self.labelUnil.titleFont = Font(17.0);
    self.labelUnil.lineType = LineTypeTitleLength;
    self.labelUnil.titleArray = @[
                                  [LangSwitcher switchLang: @"进行中" key:nil],
                                  [LangSwitcher switchLang: @"已结束" key:nil]
                                  ];
    self.navigationItem.titleView = self.labelUnil;

    
    //1.切换背景
    self.switchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - [DeviceUtil top64] - [DeviceUtil bottom49])];
    [self.view addSubview:self.switchScrollView];
    [self.switchScrollView setContentSize:CGSizeMake(2*self.switchScrollView.width, self.switchScrollView.height)];
    self.switchScrollView.scrollEnabled = NO;
    
}

- (void)addCoinChangeView {
    
    CoinChangeView *coinChangeView = [[CoinChangeView alloc] init];
    coinChangeView.title = @"ETH";
    self.changeView = coinChangeView;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:coinChangeView];
    
}

@end
