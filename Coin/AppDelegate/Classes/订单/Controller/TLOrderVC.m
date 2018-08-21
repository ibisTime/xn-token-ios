//
//  TLOrderVC.m
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderVC.h"

#import "TopSegmentUtil.h"
#import "CoinChangeView.h"
#import "FilterView.h"
#import "ChatManager.h"
#import "OrderDetailVC.h"
#import "WaitingOrderVC.h"
#import "OrderModel.h"
#import <CDCommon/DeviceUtil.h>
#import "OrderListVC.h"
#import "SelectScrollView.h"
#import "CoinModel.h"
#import "CoinUtil.h"
#import "CoinService.h"
#import "UnReadModel.h"
#import "TLPageDataHelper.h"

#define SHOW_BADGE_LEFT_INDEX 0
#define SHOW_BADGE_RIGHT_INDEX 1

@interface TLOrderVC ()<SegmentDelegate, RefreshDelegate, MsgDelegate,OrderListVCLoadDelegate>

//货币切换
@property (nonatomic, strong) CoinChangeView *changeView;
@property (nonatomic, strong) TopSegmentUtil *segmentUtil;
@property (nonatomic, strong) UIScrollView *switchScrollView;
@property (nonatomic, strong) OrderListVC *ingOrderListVC;
@property (nonatomic, strong) OrderListVC *endOrderListVC;

//币种切换
@property (nonatomic, strong) SelectScrollView *selectScrollView;
@property (nonatomic, strong) NSMutableArray <CoinModel *>*coins;

//未读消息标识
@property (nonatomic, strong) UnReadModel *ingUnReadModel;
@property (nonatomic, strong) UnReadModel *endUnReadModel;


@end

@implementation TLOrderVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_currentCoin) {
        _currentCoin = [CoinUtil shouldDisplayCoinArray][0];
    }
    
    if (!_ingUnReadModel) {
        _ingUnReadModel = [[UnReadModel alloc] init];
        _ingUnReadModel.unReadFlag = NO;
        _ingUnReadModel.unReadCurrencyList = [[NSMutableArray alloc] init];
    }
    
    if (!_endUnReadModel) {
        _endUnReadModel = [[UnReadModel alloc] init];
        _endUnReadModel.unReadFlag = NO;
        _endUnReadModel.unReadCurrencyList = [[NSMutableArray alloc] init];
    }
    
    //中间切换
    self.navigationItem.titleView = self.segmentUtil;
    
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        TLNetworking *http = [TLNetworking new];
        http.code = @"625251";
        http.parameters[@"code"] = groupId;
        [http postWithSuccess:^(id responseObject) {
            
            OrderModel *orderModel =  [OrderModel tl_objectWithDictionary:responseObject[@"data"]];
            
            __block BOOL hasLook = NO;
            [OrderModel.ingStatusList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([orderModel.status equalsString:obj]) {
                    //正在进行的订单，左边
                    [self changeLeftTopMsgRedHintToHave];
                    hasLook = YES;
                }
                
            }];
            
            if (!hasLook) {
                [self changeRightTopMsgRedHintToHave];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    });
  
}

//
- (void)userLogin {
    //
    [IMAPlatform sharedInstance].conversationMgr.msgDelegate = self;
    self.ingOrderListVC.pageDataHelper.parameters[@"belongUser"] = [TLUser user].userId;
    self.endOrderListVC.pageDataHelper.parameters[@"belongUser"] = [TLUser user].userId;
    [self addUnReadMsgKVO];
    [self orderRefresh];
    [self changeTopMsgRedHintToZero];
    
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


#pragma mark- 顶部红点消失相关方法
- (void)changeTopMsgRedHintToZero {
    
    [self changeLeftTopMsgRedHintToZero];
    [self changeRightTopMsgRedHintToZero];
}

- (void)changeLeftTopMsgRedHintToZero {
    
    [self.segmentUtil hideBadgeOnItemIndex:SHOW_BADGE_LEFT_INDEX];
    
}

- (void)changeRightTopMsgRedHintToZero {
    
    [self.segmentUtil hideBadgeOnItemIndex:SHOW_BADGE_RIGHT_INDEX];
    
}

- (void)changeSelectScrollViewMsgRedHintToZero {
    
//    [self.selectScrollView show];
    
}

- (void)changeLeftTopMsgRedHintToHave {
    
    [self.segmentUtil showBadgeOnItemIndex:SHOW_BADGE_LEFT_INDEX];
    
}

- (void)changeRightTopMsgRedHintToHave {
    
    [self.segmentUtil showBadgeOnItemIndex:SHOW_BADGE_RIGHT_INDEX];
    
}

- (void)changeSelectScrollViewMsgRedHintToHave {
    
//    [self.selectScrollView ];
    
}



- (void)orderRefresh {
    
    [self.ingOrderListVC refresh];
    [self.endOrderListVC refresh];
    
}

#pragma mark- 添加未读消息 的 观察
- (void)addUnReadMsgKVO {
    
    CoinWeakSelf;
    // 这里不负责tabbar 上的改变, tabbar 在apple delegate 中处理
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
                                  [weakSelf asyncHandleTopUnreadMsgHint];
                                  
                              }
                              
                          }];
    
}

//- (void)asyncHandleTopUnreadMsgHint {
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//
//        __block int leftUnReadCount = 0;
//        __block int rightUnReadCount = 0;
//
//        [self.ingOrderListVC.orderGroups enumerateObjectsUsingBlock:^(OrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            TIMConversation *conversation =  [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:obj.code];
//            leftUnReadCount += conversation.getUnReadMessageNum;
//
//        }];
//
//        [self.endOrderListVC.orderGroups enumerateObjectsUsingBlock:^(OrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            TIMConversation *conversation =  [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:obj.code];
//            rightUnReadCount += conversation.getUnReadMessageNum;
//
//        }];
//
//        //
//        dispatch_async(dispatch_get_main_queue() , ^{
//
//            if(leftUnReadCount <= 0) {
//
//                [self changeLeftTopMsgRedHintToZero];
//            } else {
//                [self changeLeftTopMsgRedHintToHave];
//
//            }
//
//            if(rightUnReadCount <= 0) {
//
//                [self changeRightTopMsgRedHintToZero];
//
//            } else {
//
//                [self changeRightTopMsgRedHintToHave];
//            }
//
//        });
//
//    });
//
//}

- (void)asyncHandleTopUnreadMsgHint {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        //查询用户所有订单并遍历是否未读消息

        TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
        helper.code = @"625250";
        helper.start = 1;
        helper.limit = 999999999; //为了列表查
        helper.parameters[@"tradeCurrency"] = @"CNY";
        [helper modelClass:[OrderModel class]];
        //切换用户时外部会去更新
        helper.parameters[@"belongUser"] = [TLUser user].userId;
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            //遍历订单列表
            //1、计算进行中订单的未读消息总数，状态是进行中，币种不传 leftUnReadCount
            //2、计算结束订单的未读消息总数，状态是已结束，币种不传 rightUnReadCount
            //3、计算单个币种进行中订单的未读消息总数，状态是进行中，对应币种 leftUnReadCount_ETH leftUnReadCount_SC ...更多币种
            //4、计算单个币种已结束订单的未读消息总数，状态是已结束，对应币种 rightUnReadCount_ETH rightUnReadCount_SC ...更多币种
            
            __block int ingUnReadCount = 0;
            __block int endUnReadCount = 0;
            
            self.ingUnReadModel.unReadFlag = NO;
            self.endUnReadModel.unReadFlag = NO;
            [self.ingUnReadModel.unReadCurrencyList removeAllObjects];
            [self.endUnReadModel.unReadCurrencyList removeAllObjects];
            
            [objs enumerateObjectsUsingBlock:^(OrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([[OrderModel ingStatusList] indexOfObject:obj.status] != NSNotFound) {
                    
                    TIMConversation *conversation =  [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:obj.code];
                    
                    int unReadMessageNum = conversation.getUnReadMessageNum;
                    if (unReadMessageNum > 0) {
                        ingUnReadCount += unReadMessageNum;
                        [self.ingUnReadModel.unReadCurrencyList addObject:obj.tradeCoin];
                    }
                    
                }
                
                if ([[OrderModel endStatusList] indexOfObject:obj.status] != NSNotFound) {
                    
                    TIMConversation *conversation =  [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:obj.code];
                    
                    int unReadMessageNum = conversation.getUnReadMessageNum;
                    if (unReadMessageNum > 0) {
                        endUnReadCount += unReadMessageNum;
                        [self.endUnReadModel.unReadCurrencyList addObject:obj.tradeCoin];
                    }
                    
                }
                
            }];
            
            if (ingUnReadCount > 0) {
                self.ingUnReadModel.unReadFlag = YES;
            }
            
            if (endUnReadCount > 0) {
                self.endUnReadModel.unReadFlag = YES;
            }
            
            dispatch_async(dispatch_get_main_queue() , ^{
                
                if(self.ingUnReadModel.unReadFlag) {
                    
                    [self changeLeftTopMsgRedHintToHave];
                    
                    
                } else {
                    
                    [self changeLeftTopMsgRedHintToZero];
                    
                }
                
                if(self.endUnReadModel.unReadFlag) {
                    
                    [self changeRightTopMsgRedHintToHave];
                    
                } else {
                    
                    [self changeRightTopMsgRedHintToZero];
                    
                }
                
                if (self.segmentUtil.selectIndex == 0) {
                    
                    [self.selectScrollView.headView showBadgeOn:self.ingUnReadModel.unReadCurrencyList];
                    
                } else {
                    
                    [self.selectScrollView.headView showBadgeOn:self.endUnReadModel.unReadCurrencyList];
                    
                }

                
            });
            
        } failure:^(NSError *error) {
            
        }];
        
        
        
    });
    
}



#pragma mark- 获取用户所有的订单列表，计算消息红点
- (void)queryOrderList {
    
   
    
}

#pragma mark- delegate
- (void)loadFinsh:(UIViewController *)vc orderGroups:(NSMutableArray <OrderModel *>* )orderGroups {
    
    [self asyncHandleTopUnreadMsgHint];
    
}


#pragma mark - SegmentDelegate, 顶部切换
-(void)segment:(TopSegmentUtil *)segment didSelectIndex:(NSInteger)index {
    
    [self.switchScrollView setContentOffset:CGPointMake((index) * self.switchScrollView.width, 0)];
    [self.segmentUtil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
    
    if (index == 0) {
        
        [self.selectScrollView.headView showBadgeOn:self.ingUnReadModel.unReadCurrencyList];
        
    } else {
        
        [self.selectScrollView.headView showBadgeOn:self.endUnReadModel.unReadCurrencyList];
        
    }
}


- (void)setUpChildVC {
    
    //1. 进行中
    self.ingOrderListVC = [[OrderListVC alloc] init];
    self.ingOrderListVC.delegate = self;
    self.ingOrderListVC.statusList = [OrderModel ingStatusList];
    self.ingOrderListVC.tradeCoin = self.currentCoin;
    self.ingOrderListVC.view.frame = CGRectMake(0,0,self.switchScrollView.width,self.switchScrollView.height);
    [self addChildViewController:self.ingOrderListVC];
    [self.switchScrollView addSubview:self.ingOrderListVC.view];
    
    //2. 结束
    self.endOrderListVC = [[OrderListVC alloc] init];
    self.endOrderListVC.delegate = self;
    self.endOrderListVC.statusList = [OrderModel endStatusList];
    self.endOrderListVC.tradeCoin = self.currentCoin;
    self.endOrderListVC.view.frame = CGRectMake(self.switchScrollView.width,0,self.switchScrollView.width,self.switchScrollView.height);
    [self addChildViewController:self.endOrderListVC];
    [self.switchScrollView addSubview:self.endOrderListVC.view];
    
    
}

- (void)setUpUI {
    
    //0.顶部切换
    self.segmentUtil = [[TopSegmentUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 145, 25, 145, 30)];
    self.segmentUtil.layer.cornerRadius = 5;
    self.segmentUtil.delegate = self;
    self.segmentUtil.backgroundColor = [UIColor whiteColor];
    self.segmentUtil.layer.borderWidth = 1;
    self.segmentUtil.layer.borderColor = kThemeColor.CGColor;
    self.segmentUtil.titleNormalColor = kThemeColor;
    self.segmentUtil.titleSelectColor = kWhiteColor;
    self.segmentUtil.bgNormalColor = kWhiteColor;
    self.segmentUtil.bgSelectColor = kThemeColor;
    self.segmentUtil.msgNormalColor = kThemeColor;
    self.segmentUtil.msgSelectColor = kWhiteColor;
    self.segmentUtil.titleFont = Font(13.0);
    self.segmentUtil.titleArray = @[
                                  [LangSwitcher switchLang: @"进行中" key:nil],
                                  [LangSwitcher switchLang: @"已结束" key:nil]
                                  ];
    self.navigationItem.titleView = self.segmentUtil;
    
    //币种选择
    [self.view addSubview:self.selectScrollView];
    for (int index = 0; index < _coins.count; index++) {
        if ([_currentCoin isEqualToString:_coins[index].symbol]) {
            [self.selectScrollView setCurrentIndex:index];
            break;
        }
    }
    
    //1.切换背景
    self.switchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.selectScrollView.bottom + 10, SCREEN_WIDTH, SCREEN_HEIGHT - [DeviceUtil top64] - [DeviceUtil bottom49] - self.selectScrollView.height)];
    [self.view addSubview:self.switchScrollView];
    [self.switchScrollView setContentSize:CGSizeMake(2*self.switchScrollView.width, self.switchScrollView.height)];
    self.switchScrollView.scrollEnabled = NO;
    
    
    
    
}

#pragma mark - Init
- (SelectScrollView *)selectScrollView {
    
    CoinWeakSelf;
    
    if (!_selectScrollView) {
        
         NSArray *titleArray = [CoinUtil shouldDisplayCoinArray];
        
        _selectScrollView = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45) itemTitles:titleArray];
 
        weakSelf.coins = [CoinUtil shouldDisplayCoinModelArray];
        
        [_selectScrollView setSelectBlock:^(NSInteger index) {
            
            CoinModel *currentCoin = weakSelf.coins[index];
            
            weakSelf.ingOrderListVC.pageDataHelper.parameters[@"tradeCoin"] = currentCoin.symbol;
            weakSelf.endOrderListVC.pageDataHelper.parameters[@"tradeCoin"] = currentCoin.symbol;
            
            [weakSelf orderRefresh];
//            [weakSelf asyncHandleTopUnreadMsgHint];
        }];
        
    }
    return _selectScrollView;
}

@end
