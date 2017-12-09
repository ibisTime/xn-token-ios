//
//  OrderDetailVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "OrderDetailVC.h"

#import "CoinHeader.h"

#import "OrderDetailHeaderView.h"
#import "OrderCommentView.h"
#import "OrderArbitrationView.h"

#import "NSString+Date.h"
#import "UIBarButtonItem+convience.h"

@interface OrderDetailVC ()

@property (nonatomic, strong) OrderDetailHeaderView *headView;
//评价
@property (nonatomic, strong) OrderCommentView *commentView;
//仲裁
@property (nonatomic, strong) OrderArbitrationView *arbitrationView;
//定时器
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation OrderDetailVC

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    //查看详情
    [self lookOrderDetail];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    [self initHeaderView];
    
//    支付倒计时
//    self.timer = [NSTimer timerWithTimeInterval:60 target:self selector:@selector(calculateInvalidTime) userInfo:nil repeats:YES];
    
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.headView.height = self.headView.centerView.yy;
    
    self.tableView.tableHeaderView = self.headView;

}

#pragma mark - Init
- (void)initHeaderView {
    
    CoinWeakSelf;
    
    self.headView = [[OrderDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 370)];
    
    self.headView.backgroundColor = kClearColor;
    self.headView.order = self.order;
    self.headView.orderBlock = ^(OrderEventsType orderType) {
        
        [weakSelf orderEventsWithType:orderType];
    };
    
}

- (void)addArbitrationItem {
    
    [UIBarButtonItem addRightItemWithTitle:@"申请仲裁" titleColor:kTextColor frame:CGRectMake(0, 0, 70, 44) vc:self action:@selector(applyArbitration)];
}

- (OrderCommentView *)commentView {
    
    if (!_commentView) {
        
        CoinWeakSelf;
        
        _commentView = [[OrderCommentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _commentView.commentBlock = ^(NSString *result) {
            
            [weakSelf commentWithResult:result];
        };
        
    }
    
    return _commentView;
}

- (OrderArbitrationView *)arbitrationView {
    
    if (!_arbitrationView) {
        
        CoinWeakSelf;
        
        _arbitrationView = [[OrderArbitrationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _arbitrationView.arbitrationBlock = ^(NSString *reason) {
            
            [weakSelf arbitrationWithReason:reason];

        };
        
    }
    
    return _arbitrationView;
}

#pragma mark - Events
- (void)orderEventsWithType:(OrderEventsType)type {
    
    CoinWeakSelf;
    
    switch (type) {
        case OrderEventsTypeWillPay:
        {
            [TLAlert alertWithTitle:@"注意" msg:@"您确定要标记打款?" confirmMsg:@"确定" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                [weakSelf confirmPay];
            }];
            
        }break;
        
        case OrderEventsTypeWillRelease:
        {
            [TLAlert alertWithTitle:@"注意" msg:@"您确定要释放货币?" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                [weakSelf releaseCoin];
            }];
            
        }break;
            
        case OrderEventsTypeWillComment:
        {
            [self.commentView show];
            
        }break;
            
        case OrderEventsTypeDidComplete:
        {
            
            self.tabBarController.selectedIndex = 3;
            [self.navigationController popToRootViewControllerAnimated:NO];
            
        }break;
            
//        case OrderEventsTypeDidCancel:
//        {
//
//        }break;
//
//        case OrderEventsTypeArbitration:
//        {
//
//        }break;
            
        default:
            break;
    }
}

- (void)applyArbitration {
    
    [self.arbitrationView show];
}

#pragma mark - Data
//标记打款
- (void)confirmPay {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625243";
    http.showView = self.view;
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"updater"] = [TLUser user].userId;
    http.parameters[@"remark"] = @"标记打款";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *isSuccess = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"isSuccess"]];
        
        if ([isSuccess isEqualToString:@"1"]) {
            
            [TLAlert alertWithSucces:@"标记打款成功"];
            //刷新订单列表
            [[NSNotificationCenter defaultCenter] postNotificationName:kOrderListRefresh object:nil];
            //刷新状态
            [self lookOrderDetail];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//释放比太币
- (void)releaseCoin {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625244";
    http.showView = self.view;
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"updater"] = [TLUser user].userId;
    http.parameters[@"remark"] = @"释放货币";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *isSuccess = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"isSuccess"]];
        
        if ([isSuccess isEqualToString:@"1"]) {
            
            [TLAlert alertWithSucces:@"释放成功"];
            //刷新订单列表
            [[NSNotificationCenter defaultCenter] postNotificationName:kOrderListRefresh object:nil];
            [self lookOrderDetail];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
//交易评价
- (void)commentWithResult:(NSString *)result {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625245";
    http.showView = self.view;
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"comment"] = result;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *isSuccess = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"isSuccess"]];
        
        if ([isSuccess isEqualToString:@"1"]) {
            
            [TLAlert alertWithSucces:@"评价成功"];
            
            [self.commentView hide];
            //刷新订单列表
            [[NSNotificationCenter defaultCenter] postNotificationName:kOrderListRefresh object:nil];
            [self lookOrderDetail];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//申请仲裁
- (void)arbitrationWithReason:(NSString *)reason {

    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625246";
    http.showView = self.view;
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"applyUser"] = [TLUser user].userId;
    http.parameters[@"reason"] = reason;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *isSuccess = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"isSuccess"]];
        
        if ([isSuccess isEqualToString:@"1"]) {
            
            [TLAlert alertWithSucces:@"申请成功"];
            
            [self.arbitrationView hide];
            //刷新订单列表
            [[NSNotificationCenter defaultCenter] postNotificationName:kOrderListRefresh object:nil];
            
            [self lookOrderDetail];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//详情查询交易订单
- (void)lookOrderDetail {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625251";
    http.showView = self.view;
    http.parameters[@"code"] = self.order.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.order = [OrderModel tl_objectWithDictionary:responseObject[@"data"]];
        
        self.headView.order = self.order;
        
        if ([self.order.status isEqualToString:@"1"]) {
            
            //仲裁
            [self addArbitrationItem];
            
        } else {
            
            //移除仲裁
            self.navigationItem.rightBarButtonItem = nil;
        }
    
    } failure:^(NSError *error) {
        
    }];
}

//支付倒计时
//- (void)calculateInvalidTime {
//
//    if (![self.order.status isEqualToString:@"0"]) {
//
//        [self.timer invalidate];
//
//        self.timer = nil;
//
//        return ;
//    }
//
//    NSDate *invalidDate = [NSString dateFromString:self.order.invalidDatetime formatter:@"MMM dd, yyyy hh:mm:ss aa"];
//
//    NSDate *localDate = [NSString getLoaclDateWithFormatter:@"MMM dd, yyyy hh:mm:ss aa"];
//
//    //转换时间格式
//    //对比两个时间
//
//    NSTimeInterval seconds = [invalidDate timeIntervalSinceDate:localDate];
//
//    NSInteger minute = seconds/60;
//
//    if (seconds < 0) {
//
//        [self lookOrderDetail];
//
//        return ;
//    }
//
//    self.headView.promptLbl.text = [NSString stringWithFormat:@"货币将在托管中保持%ld分钟, 逾期未支付交易将自动取消", minute];
//
//}

//添加右上角按钮
//- (void)addChatSettingItem
//{
//    //用户在这里自定义右上角按钮，不实现本函数则右上角没有按钮
//    BOOL isUser = [_receiver isC2CType];
//
//    UIImage *norimage =  isUser ? [UIImage imageNamed:@"person"] :  [UIImage imageNamed:@"group"];
//    UIImage *higimage =  isUser ? [UIImage imageNamed:@"person_hover"] :  [UIImage imageNamed:@"group_hover"];
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, norimage.size.width, norimage.size.height)];
//    [btn setImage:norimage forState:UIControlStateNormal];
//    [btn setImage:higimage forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(onClickChatSetting) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.rightBarButtonItem = bar;
//}

//右上角按钮
//- (void)onClickChatSetting
//{
//    //用户自己实现需要的操作，在demo中，这里是跳转到聊天对象的资料页
//
//    //如果是创建群，直接进入聊天界面时，_receiver是临时创建的群，这里需要在ongroupAdd之后，重新获取一次详细群信息
//    IMAGroup *group = [[IMAGroup alloc] initWith:_receiver.userId];
//    NSInteger index = [[IMAPlatform sharedInstance].contactMgr.groupList indexOfObject:group];
//    if (index >= 0 && index < [IMAPlatform sharedInstance].contactMgr.groupList.count)
//    {
//        _receiver = [[IMAPlatform sharedInstance].contactMgr.groupList objectAtIndex:index];
//    }
//
//    if ([_receiver isC2CType])
//    {
//        IMAUser *user = (IMAUser *)_receiver;
//        if ([[IMAPlatform sharedInstance].contactMgr isMyFriend:user])
//        {
//            FriendProfileViewController *vc = [[FriendProfileViewController alloc] initWith:user];
//            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
//        }
//        else
//        {
//            StrangerProfileViewController *vc = [[StrangerProfileViewController alloc] initWith:user];
//            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
//        }
//    }
//    else if ([_receiver isGroupType])
//    {
//        IMAGroup *user = (IMAGroup *)_receiver;
//
//        if ([user isPublicGroup])
//        {
//
//            GroupProfileViewController *vc = [[GroupProfileViewController alloc] initWith:user];
//            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
//        }
//        else if ([user isChatGroup])
//        {
//            ChatGroupProfileViewController *vc = [[ChatGroupProfileViewController alloc] initWith:user];
//            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
//        }
//        else if ([user isChatRoom])
//        {
//            ChatRoomProfileViewController *vc = [[ChatRoomProfileViewController alloc] initWith:user];
//            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
//        }
//        else
//        {
//            // do nothing
//        }
//    }
//}

@end
