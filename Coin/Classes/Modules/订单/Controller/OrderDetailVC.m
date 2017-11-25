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

@interface OrderDetailVC ()

@property (nonatomic, strong) OrderDetailHeaderView *headView;

@end

@implementation OrderDetailVC

//如果要使用自己的输入面板，可以重写这个函数
//- (void)addInputPanel
//{
//}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //查看详情
    [self lookOrderDetail];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    [self initHeaderView];
    
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.headView.centerView.height = self.headView.tradeBtn.yy + 18;
    
    self.headView.height = self.headView.centerView.yy;
    
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
    
    self.tableView.tableHeaderView = self.headView;
}

#pragma mark - Events
- (void)orderEventsWithType:(OrderEventsType)type {
    
    CoinWeakSelf;
    
    switch (type) {
        case OrderEventsTypeWillPay:
        {
            [TLAlert alertWithTitle:@"" msg:@"" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                [weakSelf confirmPay];
            }];
            
        }break;
        
        case OrderEventsTypeWillRelease:
        {
            [TLAlert alertWithTitle:@"" msg:@"" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                [weakSelf releaseCoin];
            }];
            
        }break;
            
        case OrderEventsTypeWillComment:
        {
            
        }break;
            
        case OrderEventsTypeDidComplete:
        {
            self.tabBarController.selectedIndex = 3;
            
            [self.navigationController popViewControllerAnimated:NO];
            
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

#pragma mark - Data
//标记打款
- (void)confirmPay {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625243";
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"updater"] = [TLUser user].userId;
    http.parameters[@"remark"] = @"标记打款";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *isSuccess = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"isSuccess"]];
        
        if ([isSuccess isEqualToString:@"1"]) {
            
            [TLAlert alertWithSucces:@"标记打款成功"];
            
            [self lookOrderDetail];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//释放比太币
- (void)releaseCoin {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625244";
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"updater"] = [TLUser user].userId;
    http.parameters[@"remark"] = @"释放货币";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *isSuccess = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"isSuccess"]];
        
        if ([isSuccess isEqualToString:@"1"]) {
            
            [TLAlert alertWithSucces:@"释放成功"];
            
            [self lookOrderDetail];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
//交易评价
- (void)commentWithResult:(NSString *)result {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625245";
    http.parameters[@"code"] = self.order.code;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"comment"] = @"";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *isSuccess = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"isSuccess"]];
        
        if ([isSuccess isEqualToString:@"1"]) {
            
            [TLAlert alertWithSucces:@"释放成功"];
            
            [self lookOrderDetail];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)lookOrderDetail {
    
    //详情查询交易订单
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625251";
    http.parameters[@"code"] = self.order.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.order = [OrderModel tl_objectWithDictionary:responseObject[@"data"]];
        
        self.headView.order = self.order;
        
    } failure:^(NSError *error) {
        
    }];
}

//添加右上角按钮
- (void)addChatSettingItem
{
    //用户在这里自定义右上角按钮，不实现本函数则右上角没有按钮
    BOOL isUser = [_receiver isC2CType];
    
    UIImage *norimage =  isUser ? [UIImage imageNamed:@"person"] :  [UIImage imageNamed:@"group"];
    UIImage *higimage =  isUser ? [UIImage imageNamed:@"person_hover"] :  [UIImage imageNamed:@"group_hover"];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, norimage.size.width, norimage.size.height)];
    [btn setImage:norimage forState:UIControlStateNormal];
    [btn setImage:higimage forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onClickChatSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = bar;
}

//右上角按钮
- (void)onClickChatSetting
{
    //用户自己实现需要的操作，在demo中，这里是跳转到聊天对象的资料页
    
    //如果是创建群，直接进入聊天界面时，_receiver是临时创建的群，这里需要在ongroupAdd之后，重新获取一次详细群信息
    IMAGroup *group = [[IMAGroup alloc] initWith:_receiver.userId];
    NSInteger index = [[IMAPlatform sharedInstance].contactMgr.groupList indexOfObject:group];
    if (index >= 0 && index < [IMAPlatform sharedInstance].contactMgr.groupList.count)
    {
        _receiver = [[IMAPlatform sharedInstance].contactMgr.groupList objectAtIndex:index];
    }
    
    if ([_receiver isC2CType])
    {
        IMAUser *user = (IMAUser *)_receiver;
        if ([[IMAPlatform sharedInstance].contactMgr isMyFriend:user])
        {
            FriendProfileViewController *vc = [[FriendProfileViewController alloc] initWith:user];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
        else
        {
            StrangerProfileViewController *vc = [[StrangerProfileViewController alloc] initWith:user];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
    }
    else if ([_receiver isGroupType])
    {
        IMAGroup *user = (IMAGroup *)_receiver;
        
        if ([user isPublicGroup])
        {
            
            GroupProfileViewController *vc = [[GroupProfileViewController alloc] initWith:user];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
        else if ([user isChatGroup])
        {
            ChatGroupProfileViewController *vc = [[ChatGroupProfileViewController alloc] initWith:user];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
        else if ([user isChatRoom])
        {
            ChatRoomProfileViewController *vc = [[ChatRoomProfileViewController alloc] initWith:user];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
        else
        {
            // do nothing
        }
    }
}

@end
