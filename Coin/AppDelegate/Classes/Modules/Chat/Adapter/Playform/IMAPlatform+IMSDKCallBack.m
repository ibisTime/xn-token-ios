//
//  IMAPlatform+IMSDKCallBack.m
//  TIMChat
//
//  Created by AlexiChen on 16/2/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAPlatform+IMSDKCallBack.h"
#import "TLUser.h"
// 所有回调中的核心逻辑最终都放入到主线程中执行
#import "TLAlert.h"

@implementation IMAPlatform (IMSDKCallBack)

#pragma mark - TIMConnListener

/**
 *  网络连接成功
 */
- (void)onConnSucc
{
    self.isConnected = YES;
    
    TCQALNetwork net = [[QalSDKProxy sharedInstance] getNetType];
    [self changeToNetwork:net];
    
    [self.conversationMgr onConnect];
}

/**
 *  网络连接失败
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onConnFailed:(int)code err:(NSString*)err
{
    
    self.isConnected = NO;
    [self.conversationMgr onDisConnect];

    DebugLog(@"网络连接失败");
}

/**
 *  网络连接断开
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onDisconnect:(int)code err:(NSString*)err
{
    
    self.isConnected = NO;
    [self.conversationMgr onDisConnect];

    DebugLog(@"网络连接断开 code = %d, err = %@", code, err);
}


/**
 *  连接中
 */
- (void)onConnecting
{
    DebugLog(@"连接中");
}

- (void)registNotification
{
    [[IMAPlatform sharedInstance] configOnAppLaunchWithOptions:nil];
}

#pragma mark - TIMUserStatusListener

/**
 *  踢下线通知
 */
static BOOL kIsAlertingForceOffline = NO;
- (void)onForceOffline
{
    
    if (!kIsAlertingForceOffline)
    {
//        [[IMAAppDelegate sharedAppDelegate] popToRootViewController];
        
        kIsAlertingForceOffline = YES;
        DebugLog(@"踢下线通知");
        __weak typeof(self) ws = self;
        
        [TLAlert alertWithTitle:nil message:@"为了您的账户安全，请重新登录" confirmAction:^{
            
            [ws offlineLogin];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification
                                                                object:nil];
            
        }];
        
        
//        [TLAlert alertWithTitle:@"下线通知"
//                            msg:@"您的帐号于另一台手机上登录。"
//                     confirmMsg:@"重新登录"
//                      cancleMsg:@"取消"
//                         cancle:^(UIAlertAction *action) {
//
//            [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification  object:nil];
//
//        } confirm:^(UIAlertAction *action) {
//
//            [self offlineLogin];
//            // 重新登录
//            [self login:self.host.loginParm succ:^{
//
//                [TLAlert alertWithSucces:@"登录成功"];
//                //
//                IMALoginParam *wp = [IMALoginParam loadFromLocal];
//                [[IMAPlatform sharedInstance] configOnLoginSucc:wp];
//                //
//                [ws registNotification];
//            } fail:^(int code, NSString *msg) {
//                //进入登录界面
////                [[IMAAppDelegate sharedAppDelegate] enterLoginUI];
//            }];
//
//            kIsAlertingForceOffline = NO;
//
//        }];
        

        
    }
}

/**
 *  断线重连失败
 */
- (void)onReConnFailed:(int)code err:(NSString*)err
{
//    DebugLog(@"断线重连失败");
//
    
}

/**
 *  用户登录的userSig过期，需要重新登录
 */
- (void)onUserSigExpired
{
    [[HUDHelper sharedInstance] syncLoading];
    //刷新票据
    [[TLSHelper getInstance] TLSRefreshTicket:[IMAPlatform sharedInstance].host.profile.identifier andTLSRefreshTicketListener:self];
}

- (void)OnRefreshTicketSuccess:(TLSUserInfo *)userInfo
{
    [[HUDHelper sharedInstance] syncStopLoading];
    
    //更新本地票据
    IMALoginParam *param = [IMALoginParam loadFromLocal];
    param.userSig = [[TLSHelper getInstance] getTLSUserSig:userInfo.identifier];
    param.tokenTime = [[NSDate date] timeIntervalSince1970];
    
    [param saveToLocal];
    
    [IMAPlatform sharedInstance].host.loginParm.userSig = param.userSig;
    [[IMAPlatform sharedInstance].host.loginParm saveToLocal];
    
    // 重新登录
    [[TIMManager sharedInstance] login:param succ:^{
        [IMAPlatform setAutoLogin:YES];
    } fail:^(int code, NSString *msg) {
        DebugLog(@"TIMLogin Failed: code=%d err=%@", code, msg);
        [[HUDHelper sharedInstance] tipMessage:@"刷新票据，登录失败"];
    }];
}

- (void)OnRefreshTicketFail:(TLSErrInfo *)errInfo
{
    [[HUDHelper sharedInstance] syncStopLoading];
    
    NSString *err = [[NSString alloc] initWithFormat:@"刷新票据失败\ncode:%d, error:%@", errInfo.dwErrorCode, errInfo.sErrorTitle];
    
    DebugLog(@"%@",err);
    
    [[HUDHelper sharedInstance] syncLoading:@"刷新票据失败,正在退出"];
    
    IMALoginParam *param = [IMALoginParam loadFromLocal];
    param.tokenTime = 0;
    [param saveToLocal];
    
    [[IMAPlatform sharedInstance] logout:^{
        
        [[HUDHelper sharedInstance] syncStopLoading];
        
//        [[AppDelegate sharedAppDelegate] enterLoginUI];
        
    } fail:^(int code, NSString *err) {
        
        [[HUDHelper sharedInstance] syncStopLoading];
        
//        [[AppDelegate sharedAppDelegate] enterLoginUI];
        
    }];
}

- (void)OnRefreshTicketTimeout:(TLSErrInfo *)errInfo
{
    [self OnRefreshTicketFail:errInfo];
}

#pragma mark -TIMRefreshListener

- (void)onRefresh
{   // onRefresh 回调、腾讯sdk 的一级回调
    // 这里需要刷新会话
    // TODO:重新刷新会话列列
    [[TIMManager sharedInstance] addMessageListener:self.conversationMgr];

    DebugLog(@"=========>>>>> 刷新会话列表");
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.contactMgr asyncConfigContact];//从以前的OnProxyStatusChange里面移动过来的
//        [self.conversationMgr asyncConversationList];
        [self.conversationMgr asyncUpdateConversationList];
    });
    
//    [self.contactMgr asyncConfigGroup];
}

- (void)onRefreshConversations:(NSArray*)conversations
{
    [self.conversationMgr asyncConversationList];
}

@end

@implementation IMAPlatform (FriendShipListener)


/**
 *  收到代理状态变更通知
 *
 *  @param status 当前状态
 */
//- (void) OnProxyStatusChange:(TIM_FRIENDSHIP_PROXY_STATUS)status
//{
//    if (status == TIM_FRIENDSHIP_STATUS_SYNCED)
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.contactMgr asyncConfigContact];
//        });
//    }
//    DebugLog(@"同步状态为:%d", (int)status);
//}

/**
 *  添加好友通知
 *
 *  @param users 好友列表（TIMUserProfile*）
 */
- (void)onAddFriends:(NSArray *)users
{
    NSString *info = [NSString stringWithFormat:@"timchat onaddfriends %@",users];
    [[TIMManager sharedInstance] log:TIM_LOG_DEBUG tag:@"111" msg:info];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!self.contactMgr.hasNewDependency) {
            
            self.contactMgr.hasNewDependency = YES;
            
        }
        
        DebugLog(@"%@", users);
        
        for (TIMUserProfile *u in users)
        {
            IMAUser *user = [[IMAUser alloc] initWithUserInfo:u];
            NSString *fg = nil;
            if (u.friendGroups.count > 0)
            {
                fg = u.friendGroups[0];
            }
            
            IMASubGroup *sg = [self.contactMgr getSubGroupOf:fg];
            [self.contactMgr addUser:user toSubGroup:sg];
        }
    });
}

/**
 *  删除好友通知
 *
 *  @param identifiers 用户id列表（NSString*）
 */
- (void)onDelFriends:(NSArray*)identifiers
{
    DebugLog(@"%@", identifiers);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.contactMgr.hasNewDependency)
        {
            self.contactMgr.hasNewDependency = YES;
        }
        for (NSString *uid in identifiers)
        {
            IMAUser *user = [[IMAUser alloc] initWith:uid];
            [self.contactMgr removeUser:user];
        }
    });
}

/**
 *  好友资料更新通知
 *
 *  @param profiles 资料列表（TIMUserProfile*）
 */
- (void)onFriendProfileUpdate:(NSArray*)profiles
{
    DebugLog(@"%@", profiles);
    if (!self.contactMgr.hasNewDependency)
    {
        self.contactMgr.hasNewDependency = YES;
    }
}

/**
 *  好友申请通知
 *
 *  @param reqs 好友申请者id列表（TIMSNSChangeInfo*）
 */
- (void)onAddFriendReqs:(NSArray*)reqs
{
    dispatch_async(dispatch_get_main_queue(), ^{
        DebugLog(@"%@", reqs);
        if (!self.contactMgr.hasNewDependency)
        {
            self.contactMgr.hasNewDependency = YES;
        }
    });
}

/**
 *  添加好友分组通知
 *
 *  @param friendgroups 好友分组列表（TIMFriendGroup*）
 */
- (void)onAddFriendGroups:(NSArray*)friendgroups
{
    DebugLog(@"%@", friendgroups);
    if (!self.contactMgr.hasNewDependency)
    {
        self.contactMgr.hasNewDependency = YES;
    }
}

/**
 *  删除好友分组通知
 *
 *  @param names 好友分组名称列表（NSString*）
 */
- (void)onDelFriendGroups:(NSArray*)names
{
    DebugLog(@"%@", names);
    if (!self.contactMgr.hasNewDependency)
    {
        self.contactMgr.hasNewDependency = YES;
    }
}

/**
 *  好友分组更新通知
 *
 *  @param friendgroups 好友分组列表（TIMFriendGroup*）
 */
- (void)onFriendGroupUpdate:(NSArray*)friendgroups
{
    DebugLog(@"%@", friendgroups);
    if (!self.contactMgr.hasNewDependency)
    {
        self.contactMgr.hasNewDependency = YES;
    }
    
}


@end


@implementation IMAPlatform (GroupAssistantListener)

/**
 *  有新用户加入群时的通知回调
 *
 *  @param groupId     群ID
 *  @param membersInfo 加群用户的群资料（TIMGroupMemberInfo*）列表
 */
-(void) onMemberJoin:(NSString *)groupId membersInfo:(NSArray *)membersInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        DebugLog(@"groupId = %@, membersInfo = %@", groupId, membersInfo);
        
        IMAGroup *temp = [[IMAGroup alloc] initWith:groupId];
        IMAGroup *group = (IMAGroup *)[[IMAPlatform sharedInstance].contactMgr isContainUser:temp];
        if (group)
        {
            group.groupInfo.memberNum += (uint32_t)membersInfo.count;
        }
    });
}

/**
 *  有群成员退群时的通知回调
 *
 *  @param groupId 群ID
 *  @param members 退群成员的identifier（NSString*）列表
 */
-(void) onMemberQuit:(NSString*)groupId members:(NSArray*)members
{
    dispatch_async(dispatch_get_main_queue(), ^{
        DebugLog(@"groupId = %@, membersInfo = %@", groupId, members);
        
        IMAGroup *temp = [[IMAGroup alloc] initWith:groupId];
        IMAGroup *group = (IMAGroup *)[[IMAPlatform sharedInstance].contactMgr isContainUser:temp];
        
        if (group)
        {
            group.groupInfo.memberNum -= (uint32_t)members.count;
        }
    });
}

/**
 *  群成员信息更新的通知回调
 *
 *  @param groupId     群ID
 *  @param membersInfo 更新后的群成员资料（TIMGroupMemberInfo*）列表
 */
-(void) onMemberUpdate:(NSString*)groupId membersInfo:(NSArray*)membersInfo
{
    DebugLog(@"groupId = %@, membersInfo = %@", groupId, membersInfo);
}

/**
 *  加入群的通知回调
 *
 *  @param groupInfo 加入群的群组资料
 */
-(void) onGroupAdd:(TIMGroupInfo*)groupInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        DebugLog(@"groupInfo = %@", groupInfo);
        IMAUser *group = (IMAGroup *) [self.contactMgr getUserByGroupId:groupInfo.group];
        if (!group)
        {
            IMAGroup *gr = [[IMAGroup alloc] initWithInfo:groupInfo];
            [self.contactMgr onAddGroup:gr];
            
            //注:刚加入群时需要刷新一下会话列表，不然会话列表上显示的是群id，而不是群名称
            IMAConversation *gc = [self.conversationMgr queryConversationWith:gr];
            if (gc)
            {
                //重新设置一下lastMessage就可以更新整个会话了(lastmessage有kvo监听)
                gc.lastMessage = gc.lastMessage;
            }
        }
    });
}

/**
 *  解散群的通知回调
 *
 *  @param groupId 解散群的群ID
 */
-(void) onGroupDelete:(NSString*)groupId
{
    DebugLog(@"groupInfo = %@", groupId);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        IMAUser *group = (IMAGroup *) [self.contactMgr getUserByGroupId:groupId];
        if (group)
        {
            [self.contactMgr removeUser:group];
        }
    });
}

/**
 *  群资料更新的通知回调
 *
 *  @param groupInfo 更新后的群资料信息
 */
- (void)onGroupUpdate:(TIMGroupInfo*)groupInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        DebugLog(@"groupInfo = %@", groupInfo);
        IMAGroup *group = (IMAGroup *) [self.contactMgr getUserByGroupId:groupInfo.group];
        if (group)
        {
            [group changeGroupInfo:groupInfo];
        }
    });
}

@end
