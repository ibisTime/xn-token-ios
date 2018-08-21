//
//  IMAGroupMember.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/4.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAUser.h"

// 群成员用户信息

@interface IMAGroupMember : IMAUser
{
@protected
    TIMGroupMemberInfo *_memberInfo;
}

@property (nonatomic, strong) TIMGroupMemberInfo *memberInfo;

- (instancetype)initWithMemberInfo:(TIMGroupMemberInfo *)user;

- (BOOL)isGroupOwner;
- (BOOL)isGroupAdmin;
- (BOOL)isNormalMember;

- (BOOL)isSilence;



@end
