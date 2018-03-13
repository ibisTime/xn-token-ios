//
//  IMAUser.m
//  TIMAdapter
//
//  Created by AlexiChen on 16/1/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAUser.h"

@implementation IMAUser

- (instancetype)initWith:(NSString *)userid
{
    if (self = [super init])
    {
        self.userId = userid;
    }
    return self;
}

- (instancetype)initWithUserInfo:(TIMUserProfile *)userprofile
{
    if (self = [super init])
    {
        self.userId = userprofile.identifier;
        self.nickName = userprofile.nickname;
        self.remark = userprofile.remark;
        self.icon = userprofile.faceURL;
    }
    return self;
}

#pragma IMAUserShowAble method

- (NSURL *)showIconUrl
{
    NSString *icon = [self icon];
    if ([NSString isEmpty:icon])
    {
        return nil;
    }
    return [NSURL URLWithString:icon];
}

- (NSString *)showTitle
{
    return ![NSString isEmpty:self.remark] ? self.remark : ![NSString isEmpty:self.nickName] ? self.nickName : self.userId;
}

#pragma - mark IMAConversationAble

- (BOOL)isC2CType
{
    return YES;
}

- (BOOL)isGroupType
{
    return NO;
}

- (BOOL)isSystemType
{
    return NO;
}

// 重写此方法，主要用于列表中的去重以及查找操作
- (BOOL)isEqual:(id)object
{
    BOOL equal = [super isEqual:object];
    if (!equal)
    {
        if ([object isKindOfClass:[IMAUser class]])
        {
            IMAUser *u = (IMAUser *)object;
            
            if ((u.isC2CType && self.isC2CType)||(u.isGroupType && self.isGroupType))
            {
                equal = [self.userId isEqualToString:u.userId];
            }
        }
    }
    
    return equal;
}

@end
