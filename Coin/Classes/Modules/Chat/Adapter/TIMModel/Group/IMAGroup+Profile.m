//
//  IMAGroup+Profile.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/25.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAGroup+Profile.h"

@implementation IMAGroup (Profile)

+ (NSDictionary *)groupAddOptTips
{
    return @{@"禁止加群" : @(TIM_GROUP_ADD_FORBID), @"需要管理员审批" : @(TIM_GROUP_ADD_AUTH), @"任何人可以加入" : @(TIM_GROUP_ADD_ANY)};
}

+ (NSDictionary *)groupReceiveMessageTips
{
    //    /**
    //     *  接收消息
    //     */
    //    TIM_GROUP_RECEIVE_MESSAGE                       = 0,
    //    /**
    //     *  不接收消息，服务器不进行转发
    //     */
    //    TIM_GROUP_NOT_RECEIVE_MESSAGE                   = 1,
    //    /**
    //     *  接受消息，不进行iOS APNs 推送
    //     */
    //    TIM_GROUP_RECEIVE_NOT_NOTIFY_MESSAGE            = 2,
    return @{@"接收消息" : @(TIM_GROUP_RECEIVE_MESSAGE), @"不接收消息" : @(TIM_GROUP_NOT_RECEIVE_MESSAGE), @"接收但不提醒" : @(TIM_GROUP_RECEIVE_NOT_NOTIFY_MESSAGE)};
}

- (NSString *)getGroupAddOptTip:(TIMGroupAddOpt)opt
{
    switch (opt) {
        case TIM_GROUP_ADD_FORBID:
            return @"禁止加群";
            break;
        case TIM_GROUP_ADD_AUTH:
            return @"需要管理员审批";
            break;
        case TIM_GROUP_ADD_ANY:
            return @"任何人可以加入";
            
        default:
            break;
    }
    return nil;
}

- (NSString *)getReceiveMessageTip:(TIMGroupReceiveMessageOpt)opt
{
    switch (opt) {
        case TIM_GROUP_RECEIVE_MESSAGE:
            return @"接收消息";
            break;
        case TIM_GROUP_NOT_RECEIVE_MESSAGE:
            return @"不接收消息";
            break;
        case TIM_GROUP_RECEIVE_NOT_NOTIFY_MESSAGE:
            return @"接收但不提醒";
            
        default:
            break;
    }
    return nil;
}

- (void)asyncModifyGroupName:(NSString *)name succ:(TIMSucc)succ fail:(TIMFail)fail
{
    if ([NSString isEmpty:name])
    {
        DebugLog(@"参数错误");
        return;
    }
    
    if ([self.nickName isEqualToString:name])
    {
        [[HUDHelper sharedInstance] tipMessage:@"与当前群名一致"];
        return;
    }
    
    if ([name utf8Length] > 30)
    {
        [[HUDHelper sharedInstance] tipMessage:@"群名称过长"];
        return;
    }
    
    __weak IMAGroup *ws = self;
    [[TIMGroupManager sharedInstance] modifyGroupName:self.userId groupName:name succ:^{
        [ws setNickName:name];
        [[IMAPlatform sharedInstance].conversationMgr updateConversationWith:ws];
        if (succ)
        {
            succ();
        }
    } fail:^(int code, NSString *msg) {
        DebugLog(@"Fail code = %d, msg = %@", code, msg);
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}

- (void)asyncModifyGroupNameCard:(NSString *)name user:(NSString *)userId succ:(TIMSucc)succ fail:(TIMFail)fail
{
    if ([NSString isEmpty:name])
    {
        DebugLog(@"参数错误");
        return;
    }
    // 获取Role里面的信息
//    if ([self.nickName isEqualToString:name])
//    {
//        [[HUDHelper sharedInstance] tipMessage:@"与当前群名一致"];
//        return;
//    }
    
    if ([name utf8Length] > 30)
    {
        [[HUDHelper sharedInstance] tipMessage:@"群名片过长"];
        return;
    }
    
    __weak IMAGroup *ws = self;
    [[TIMGroupManager sharedInstance] modifyGroupMemberInfoSetNameCard:self.userId user:userId nameCard:name succ:^{
//        [ws setNickName:name];
        [[IMAPlatform sharedInstance].conversationMgr updateConversationWith:ws];
        if (succ)
        {
            succ();
        }
    } fail:^(int code, NSString *msg) {
        DebugLog(@"Fail code = %d, msg = %@", code, msg);
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}

- (void)asyncModifyGroupIntroduction:(NSString *)name succ:(TIMSucc)succ fail:(TIMFail)fail
{
    if ([NSString isEmpty:name])
    {
        DebugLog(@"参数错误");
        return;
    }
    
    if ([self.groupInfo.introduction isEqualToString:name])
    {
        [[HUDHelper sharedInstance] tipMessage:@"与当前群介绍一致"];
        return;
    }
    
    if ([name utf8Length] > 120)
    {
        [[HUDHelper sharedInstance] tipMessage:@"群公告过长"];
        return;
    }
    
    __weak IMAGroup *ws = self;
    
    [[TIMGroupManager sharedInstance] modifyGroupIntroduction:self.userId introduction:name succ:^{
        [ws.groupInfo setIntroduction:name];
        if (succ)
        {
            succ();
        }
    } fail:^(int code, NSString *msg) {
        DebugLog(@"Fail code = %d, msg = %@", code, msg);
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}

- (void)asyncModifyGroupNotify:(NSString *)name succ:(TIMSucc)succ fail:(TIMFail)fail
{
    if ([NSString isEmpty:name])
    {
        DebugLog(@"参数错误");
        return;
    }
    
    if ([self.groupInfo.notification isEqualToString:name])
    {
        [[HUDHelper sharedInstance] tipMessage:@"与当前群公告一致"];
        return;
    }
    
    if ([name utf8Length] > 150)
    {
        [[HUDHelper sharedInstance] tipMessage:@"群公告过长"];
        return;
    }
    
    __weak IMAGroup *ws = self;
    [[TIMGroupManager sharedInstance] modifyGroupNotification:self.userId notification:name succ:^{
        [ws.groupInfo setNotification:name];
        if (succ)
        {
            succ();
        }
    } fail:^(int code, NSString *msg) {
        DebugLog(@"Fail code = %d, msg = %@", code, msg);
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}

- (void)asyncExitGroupSucc:(TIMSucc)succ fail:(TIMFail)fail
{
    __weak IMAGroup *ws = self;
    if ([self isCreatedByMe] && ![self isChatGroup])
    {
        // 讨论组不能deletegroup
        // 解散群
        [[TIMGroupManager sharedInstance] deleteGroup:self.userId succ:^{
            // TODO:删除该群，以及相关的会话
            [[IMAPlatform sharedInstance].contactMgr removeUser:ws];
            
            if (succ)
            {
                succ();
            }
        } fail:^(int code, NSString *msg) {
            DebugLog(@"Fail code = %d, msg = %@", code, msg);
            [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
            if (fail)
            {
                fail(code, msg);
            }
        }];
    }
    else
    {
        // 退出群
        [[TIMGroupManager sharedInstance] quitGroup:self.userId succ:^{
            // TODO:删除该群，以及相关的会话
            [[IMAPlatform sharedInstance].contactMgr removeUser:ws];
            
            if (succ)
            {
                succ();
            }
        } fail:^(int code, NSString *msg) {
            DebugLog(@"Fail code = %d, msg = %@", code, msg);
            [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
            if (fail)
            {
                fail(code, msg);
            }
        }];
    }
}


- (void)asyncModifyReciveMessageOption:(TIMGroupReceiveMessageOpt)opt succ:(TIMSucc)succ fail:(TIMFail)fail
{
    [[TIMGroupManager sharedInstance] modifyReciveMessageOpt:self.userId opt:opt succ:succ fail:^(int code, NSString *msg) {
        DebugLog(@"Fail code = %d, msg = %@", code, msg);
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}

- (void)asyncModifyReciveMessage:(BOOL)receive succ:(TIMSucc)succ fail:(TIMFail)fail
{
    [[TIMGroupManager sharedInstance] modifyReciveMessageOpt:self.userId opt:receive ? TIM_GROUP_RECEIVE_MESSAGE : TIM_GROUP_NOT_RECEIVE_MESSAGE succ:succ fail:^(int code, NSString *msg) {
        DebugLog(@"Fail code = %d, msg = %@", code, msg);
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}

- (void)asyncJoinGroup:(NSString*)msg succ:(TIMSucc)succ fail:(TIMFail)fail
{
    [[TIMGroupManager sharedInstance] joinGroup:self.groupInfo.group msg:msg succ:^{
        if (succ)
        {
            succ();
        }
    } fail:^(int code, NSString *msg) {
        DebugLog(@"Fail code = %d, msg = %@", code, msg);
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}

- (void)asyncUpdateGroupInfo:(TIMSucc)succ fail:(TIMFail)fail
{
    [[TIMGroupManager sharedInstance] getGroupInfo:@[self.groupId] succ:^(NSArray *array) {
        // 只会返回一个信息
        TIMGroupInfo *groupInfo = array[0];
        [self changeGroupInfo:groupInfo];
        if (succ)
        {
            succ();
        }
    } fail:^(int code, NSString *msg) {
        DebugLog(@"Fail code = %d, msg = %@", code, msg);
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}

- (void)asyncModifyGroupAddOpt:(TIMGroupAddOpt)opt succ:(TIMSucc)succ fail:(TIMFail)fail
{
    [[TIMGroupManager sharedInstance] modifyGroupAddOpt:self.groupId opt:opt succ:succ fail:^(int code, NSString *msg) {
        DebugLog(@"Fail code = %d, msg = %@", code, msg);
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}
@end
