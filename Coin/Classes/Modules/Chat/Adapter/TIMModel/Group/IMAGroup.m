//
//  IMAGroup.m
//  TIMAdapter
//
//  Created by AlexiChen on 16/1/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAGroup.h"

@implementation IMAGroup


// 讨论组
#define kPrivateGroupType   @"Private"

// 公开群
#define kPublicGroupType    @"Public"

// 聊天室
#define kChatRoomGroupType  @"ChatRoom"


- (instancetype)initWithInfo:(TIMGroupInfo *)group
{
    if (self = [super init])
    {
        _groupInfo = group;
        [self initSelfGroupInfo];
    }
    return self;
}

- (void)initSelfGroupInfo
{
    __weak IMAGroup *ws = self;
    [[TIMGroupManager sharedInstance] getGroupSelfInfo:self.groupId succ:^(TIMGroupMemberInfo *selfInfo) {
        [ws changeSelfGroupInfo:selfInfo];
    } fail:^(int code, NSString *msg) {
        DebugLog(@"code = %d,msg = %@", code, msg);
    }];
}

- (NSString *)selfNamecard
{
    if (_selfGroupInfo)
    {
        return _selfGroupInfo.nameCard;
    }
    else
    {
        return @"";
    }
}

//由于目前版本GetGroupInfo接口返回的 TIMGroupInfo 中 selfInfo为空，所以更新群资料时，需要判断，selfInfo若为空，则保留原来的selfInfo
- (void)changeGroupInfo:(TIMGroupInfo *)info
{
    if (info.selfInfo)
    {
        _groupInfo = info;
    }
    else
    {
        TIMGroupSelfInfo *selfInfo =  _groupInfo.selfInfo;
        _groupInfo = info;
        _groupInfo.selfInfo = selfInfo;
    }
}

- (void)changeSelfGroupInfo:(TIMGroupMemberInfo *)info
{
    _selfGroupInfo = info;
}

- (void)modifySelfGroupNameCard:(NSString *)namecard
{
    _selfGroupInfo.nameCard = namecard;
}

- (BOOL)isChatRoom
{
    return [_groupInfo.groupType isEqualToString:kChatRoomGroupType];
    
}
- (BOOL)isChatGroup
{
    return [_groupInfo.groupType isEqualToString:kPrivateGroupType];
}
- (BOOL)isPublicGroup
{
    return [_groupInfo.groupType isEqualToString:kPublicGroupType];
}

- (BOOL)isCreatedByMe
{
    return [_groupInfo.owner isEqualToString:[[IMAPlatform sharedInstance].host userId]];
}
- (BOOL)isManagedByMe
{
    //等待接口支持
    return _groupInfo.selfInfo.role == TIM_GROUP_MEMBER_ROLE_ADMIN;
}

#pragma - mark overwrite IMAUser方法

- (NSString *)groupId
{
    return [self userId];
}

- (NSString *)userId
{
    if (_groupInfo)
    {
        return [_groupInfo group];
    }
    else
    {
        return [super userId];
    }
}

- (void)setUserId:(NSString *)userId
{
    if (_groupInfo)
    {
        return [_groupInfo setGroup:userId];
    }
    else
    {
        [super setUserId:userId];
    }
}

- (NSString *)icon
{
    if (_groupInfo)
    {
        return [_groupInfo faceURL];
    }
    else
    {
        return [super icon];
    }
}

- (void)setIcon:(NSString *)icon
{
    if (_groupInfo)
    {
        return [_groupInfo setFaceURL:icon];
    }
    else
    {
        return [super setIcon:icon];
    }
}

- (NSString *)nickName
{
    if (_groupInfo)
    {
        return _groupInfo.groupName;
    }
    else
    {
        return [super nickName];
    }
}

- (void)setNickName:(NSString *)nickName
{
    if (_groupInfo)
    {
        return [_groupInfo setGroupName:nickName];
    }
    else
    {
        return [super setNickName:nickName];
    }
}

- (NSString *)remark
{
    if (_groupInfo)
    {
        return _groupInfo.groupName;
    }
    else
    {
        return [super remark];
    }
}

- (void)setRemark:(NSString *)remark
{
    if (_groupInfo)
    {
        return [_groupInfo setGroupName:remark];
    }
    else
    {
        return [super setRemark:remark];
    }
}

//@property (nonatomic, copy) NSString *userId;
//@property (nonatomic, copy) NSString *icon;
//@property (nonatomic, copy) NSString *nickName;
//@property (nonatomic, copy) NSString *remark;


#pragma - mark IMAGroupShowAble

- (NSInteger)memberCount
{
    return _groupInfo.memberNum;
}



//#pragma - mark IMAConversationShowAble
//- (NSString *)lastMsgTime
//{
//    return nil;
//}
//- (NSString *)lastMsg
//{
//    return nil;
//}
//- (NSInteger)unReadCount
//{
//    return 0;
//}

#pragma - mark IMAConversationAble

- (BOOL)isC2CType
{
    return NO;
}

- (BOOL)isGroupType
{
    return YES;
}


- (NSString *)receiveMessageOpt
{
    NSString *rcvOpt = [self getReceiveMessageTip:self.groupInfo.selfInfo.recvOpt];
    return rcvOpt;
}

- (NSString *)groupAddOpt
{
    switch (self.groupInfo.addOpt)
    {
        case TIM_GROUP_ADD_FORBID:
            return @"禁止加群";
            break;
        case TIM_GROUP_ADD_AUTH:
            return @"需要管理员审批";
            break;
        case TIM_GROUP_ADD_ANY:
            return @"任何人可以加入";
            break;
        default:
            break;
    }
    return @"未知类型";
}
@end
