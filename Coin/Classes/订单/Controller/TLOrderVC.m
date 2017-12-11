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
#import "ChatManager.h"
#import "OrderDetailVC.h"
#import "WaitingOrderVC.h"
#import "OrderModel.h"
#import <CDCommon/DeviceUtil.h>
#import "OrderListVC.h"

@interface TLOrderVC ()<SegmentDelegate, RefreshDelegate>

//货币切换
@property (nonatomic, strong) CoinChangeView *changeView;
//筛选
@property (nonatomic, strong) FilterView *filterPicker;
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

}


- (void)addNotification {
    //消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderRefresh) name:kOrderListRefresh object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOut) name:kUserLoginOutNotification object:nil];
    
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
                              
                              [weakSelf.ingOrderListVC reloadData];
                              [weakSelf.endOrderListVC reloadData];
                              
    }];
    
}


#pragma mark - Events
- (void)changeCoin {
    
    [self.filterPicker show];
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
    [coinChangeView addTarget:self action:@selector(changeCoin) forControlEvents:UIControlEventTouchUpInside];
    
    self.changeView = coinChangeView;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:coinChangeView];
    
}

- (FilterView *)filterPicker {
    
    if (!_filterPicker) {
        
        CoinWeakSelf;
        
        NSArray *textArr = @[@"ETH"];
        
        _filterPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _filterPicker.title = [LangSwitcher switchLang:@"请选择货币类型" key:nil] ;
        _filterPicker.selectBlock = ^(NSInteger index) {
            
            weakSelf.changeView.title = textArr[index];
            
        };
        
        _filterPicker.tagNames = textArr;
        
    }
    
    return _filterPicker;
}



@end
