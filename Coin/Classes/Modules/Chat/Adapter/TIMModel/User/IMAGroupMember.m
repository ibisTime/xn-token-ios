//
//  IMAGroupMember.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/4.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAGroupMember.h"

@implementation IMAGroupMember

- (instancetype)initWith:(NSString *)userid
{
    DebugLog(@"IMAGroupMember禁用此方法");
    return nil;
}

- (instancetype)initWithMemberInfo:(TIMGroupMemberInfo *)user
{
    if (self = [super init])
    {
        _memberInfo = user;
    }
    return self;
}

- (NSString *)showTitle
{
    return self.nickName.length > 0 ? self.nickName : self.userId;
}

- (void)setIcon:(NSString *)icon
{
    _icon = icon;
}

- (NSString *)userId
{
    return _memberInfo.member;
}

- (void)setUserId:(NSString *)userId
{
    _memberInfo.member = userId;
}

- (NSString *)nickName
{
    return _memberInfo.nameCard;
}

- (void)setNickName:(NSString *)nickName
{
    _memberInfo.nameCard = nickName;
}

- (void)setRemark:(NSString *)remark
{
    _memberInfo.nameCard = remark;
}

- (NSString *)remark
{
    return _memberInfo.nameCard;
}
- (BOOL)isGroupOwner
{
    return _memberInfo.role == TIM_GROUP_MEMBER_ROLE_SUPER;
}
- (BOOL)isGroupAdmin
{
    return _memberInfo.role == TIM_GROUP_MEMBER_ROLE_ADMIN;
}

- (BOOL)isNormalMember
{
    return _memberInfo.role == TIM_GROUP_MEMBER_ROLE_MEMBER;
}

- (BOOL)isSilence
{
    NSInteger curTime = [[NSDate date] timeIntervalSince1970];
    BOOL isSil = _memberInfo.silentUntil > curTime;
    return isSil;
}


@end
