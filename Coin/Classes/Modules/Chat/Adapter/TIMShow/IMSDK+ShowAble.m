//
//  TIMUserProfile+ShowAble.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/1.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMSDK+ShowAble.h"

@implementation TIMUserProfile (ShowAble)

// 显示的标题
- (NSString *)showTitle
{
    return ![NSString isEmpty:self.remark] ? self.remark : ![NSString isEmpty:self.nickname] ? self.nickname : self.identifier;
}

// 显示图像的地址
- (NSURL *)showIconUrl
{
    return [NSURL URLWithString:self.faceURL];
}

- (NSString *)getAllowType
{
    switch (self.allowType)
    {
        case TIM_FRIEND_ALLOW_ANY:
        {
            return @"同意任何用户加好友";
        }
            
            break;
        case TIM_FRIEND_NEED_CONFIRM:
        {
            return @"需要验证";
        }
            break;
        case TIM_FRIEND_DENY_ANY:
        {
            return @"拒绝任何人加好友";
        }
            break;
        default:
            break;
    }
}

+ (NSDictionary *)allowTypeTips
{
    return @{@"同意任何用户加好友" : @(TIM_FRIEND_ALLOW_ANY), @"需要验证" : @(TIM_FRIEND_NEED_CONFIRM), @"拒绝任何人加好友" : @(TIM_FRIEND_DENY_ANY)};
}


@end

@implementation TIMFriendPendencyItem (ShowAble)

// 显示的标题
- (NSString *)showTitle
{
    return ![NSString isEmpty:self.nickname] ? self.nickname : self.identifier;
}

// 显示图像的地址
- (NSURL *)showIconUrl
{
    return nil;
}

- (NSString *)applyInfo
{
    return self.addWording;
}

- (BOOL)isSendByMe
{
    return self.type == TIM_PENDENCY_GET_SEND_OUT;
}


@end

@implementation TIMFriendFutureItem (ShowAble)

// 显示的标题
- (NSString *)showTitle
{
    return [self.profile showTitle];
}

// 显示图像的地址
- (NSURL *)showIconUrl
{
    return [self.profile showIconUrl];
}

///**
// *  收到的未决请求
// */
//TIM_FUTURE_FRIEND_PENDENCY_IN_TYPE              = 0x1,
//
///**
// *  发出去的未决请求
// */
//TIM_FUTURE_FRIEND_PENDENCY_OUT_TYPE             = 0x2,
//
///**
// *  推荐好友
// */
//TIM_FUTURE_FRIEND_RECOMMEND_TYPE                = 0x4,
//
///**
// *  已决好友
// */
//TIM_FUTURE_FRIEND_DECIDE_TYPE                   = 0x8,

// 申请理由
- (NSString *)detaiInfo
{
    switch (self.type)
    {
        case TIM_FUTURE_FRIEND_PENDENCY_IN_TYPE:
        {
            // 如果已添加到到列表
            return [NSString stringWithFormat:@"请求理由:%@", self.addWording];
            
        }
            
            break;

        case TIM_FUTURE_FRIEND_PENDENCY_OUT_TYPE:
        {
            // 如果已添加到到列表
            return [NSString stringWithFormat:@"添加理由:%@", self.addWording];
        }
            
            break;

        case TIM_FUTURE_FRIEND_RECOMMEND_TYPE:
        {
            // 如果已添加到到列表
            return [NSString stringWithFormat:@"推荐好友:%@", self.addWording];
        }
            
            break;

        case TIM_FUTURE_FRIEND_DECIDE_TYPE:
        {
            // 已决列表里面全部是已经同意的
            return @"已添加";
        }
            
            break;

        default:
            break;
    }
    return nil;
}

- (BOOL)isMyFriend
{
    IMAUser *usr = [[IMAUser alloc] initWith:self.identifier];
    return [[IMAPlatform sharedInstance].contactMgr isMyFriend:usr];
}

- (BOOL)isSendByMe
{
    return self.type == TIM_FUTURE_FRIEND_PENDENCY_OUT_TYPE;
}
- (BOOL)isPendency
{
    return self.type == TIM_FUTURE_FRIEND_PENDENCY_IN_TYPE ;
}
- (BOOL)isDecide
{
    return self.type == TIM_FUTURE_FRIEND_DECIDE_TYPE;
}
- (BOOL)isRecormend
{
    return self.type == TIM_FUTURE_FRIEND_RECOMMEND_TYPE;
}


@end


@implementation TIMGroupPendencyItem (ShowAble)

- (NSString *)showTitle
{
    //未处理
    if (self.handleStatus == TIM_GROUP_PENDENCY_HANDLE_STATUS_UNHANDLED)
    {
        return self.fromUser;
    }
    else
    {
        IMAUser *user = [[IMAUser alloc] initWith:self.toUser];
        
        BOOL isToUserIsMe = [[IMAPlatform sharedInstance].host isMe:user];
        
        NSString *toUserStr = isToUserIsMe ? @"你" : self.toUser;
        
        return toUserStr;
    }
}

- (NSURL *)showIconUrl
{
    return nil;
}

- (NSString *)applyInfo
{
    if (self.handleStatus == TIM_GROUP_PENDENCY_HANDLE_STATUS_UNHANDLED)
    {
        switch (self.getType)
        {
            case TIM_GROUP_PENDENCY_GET_TYPE_JOIN:
                return [NSString stringWithFormat:@"申请理由:%@", self.requestMsg];
                break;
            case TIM_GROUP_PENDENCY_GET_TYPE_INVITE:
                return [NSString stringWithFormat:@"邀请理由:%@", self.requestMsg];
                break;
            default:
                break;
        }
    }
    else
    {
        if (self.handleResult == TIM_GROUP_PENDENCY_HANDLE_RESULT_REFUSE)
        {
            return [NSString stringWithFormat:@"拒绝理由:%@", self.handledMsg];
        }
        else
        {
            return [NSString stringWithFormat:@"同意理由:%@", self.handledMsg];
        }
        
    }
    
    return nil;
}


- (NSString *)detailInfo
{
    IMAUser *user = [[IMAUser alloc] initWith:self.toUser];
    
    BOOL isToUserIsMe = [[IMAPlatform sharedInstance].host isMe:user];
    
    NSString *toUserStr = isToUserIsMe ? @"你" : self.toUser;
    
    if (self.handleStatus == TIM_GROUP_PENDENCY_HANDLE_STATUS_UNHANDLED)
    {
        switch (self.getType)
        {
            case TIM_GROUP_PENDENCY_GET_TYPE_JOIN:
                return [NSString stringWithFormat:@"申请加入群%@",self.groupId];
                break;
            case TIM_GROUP_PENDENCY_GET_TYPE_INVITE:
                return [NSString stringWithFormat:@"邀请%@加入群%@", toUserStr, self.groupId];
                break;
            default:
                break;
        }
    }
    else
    {
        switch (self.getType)
        {
            case TIM_GROUP_PENDENCY_GET_TYPE_JOIN:
                return [NSString stringWithFormat:@"已同意%@进群%@",self.fromUser, self.groupId];
                break;
            case TIM_GROUP_PENDENCY_GET_TYPE_INVITE:
                return [NSString stringWithFormat:@"受%@邀请进群%@", self.fromUser, self.groupId];
                break;
            default:
                break;
        }
    }
    return nil;
}


- (NSString *)actionTitle
{
    //未处理
    if (self.handleStatus == TIM_GROUP_PENDENCY_HANDLE_STATUS_UNHANDLED)
    {
        return @"审核";
    }
    else// if (self.handleStatus == TIM_GROUP_PENDENCY_HANDLE_STATUS_OTHER_HANDLED | self.handleStatus == TIM_GROUP_PENDENCY_HANDLE_STATUS_OPERATOR_HANDLED)
    {
        if (self.handleResult == TIM_GROUP_PENDENCY_HANDLE_RESULT_REFUSE)
        {
            return @"已拒绝";
        }
        else if (self.handleResult == TIM_GROUP_PENDENCY_HANDLE_RESULT_AGREE)
        {
            return @"已同意";
        }
    }
    return nil;
}
- (BOOL)actionEnable
{
    if (self.handleStatus == TIM_GROUP_PENDENCY_HANDLE_STATUS_UNHANDLED)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end


@implementation TIMGroupInfo (ShowAble)

+ (instancetype)instanceFrom:(TIMCreateGroupInfo *)info
{
    if (!info)
    {
        return nil;
    }
    
    TIMGroupInfo *gi = [[TIMGroupInfo alloc] init];
    gi.group = info.group;
    gi.groupName = info.groupName;
    gi.groupType = info.groupType;
    gi.notification = info.notification;
    gi.introduction = info.introduction;
    gi.faceURL = info.faceURL;
    return gi;
}

- (NSString *)showTitle
{
    return self.groupName;
}

- (NSURL *)showIconUrl
{
    return !self.faceURL ? [NSURL URLWithString:self.faceURL] : nil;
}

- (NSString *)groupId
{
    return self.group;
}

- (NSInteger)memberCount
{
    return self.memberNum;
}
@end


@implementation TIMGroupMemberInfo (ShowAble)

// 显示的标题
- (NSString *)showTitle
{
    return ![NSString isEmpty:self.nameCard] ? self.nameCard : self.member;
}

// 显示图像的地址
- (NSURL *)showIconUrl
{
    // TODO:获取用户头像
    return nil;
}

@end
