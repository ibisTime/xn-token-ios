//
//  IMAGroup.h
//  TIMAdapter
//
//  Created by AlexiChen on 16/1/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMASubGroup.h"

@interface IMAGroup : IMAUser<IMAGroupShowAble>
{
@protected
    TIMGroupInfo            *_groupInfo;
    TIMGroupMemberInfo      *_selfGroupInfo;
    NSMutableArray          *_members;
}

@property (nonatomic, readonly) TIMGroupInfo *groupInfo;
@property (nonatomic, readonly) NSMutableArray *members;

- (instancetype)initWithInfo:(TIMGroupInfo *)group;

- (void)changeGroupInfo:(TIMGroupInfo *)info;

- (void)modifySelfGroupNameCard:(NSString *)namecard;

// 是否为我创建的群
- (BOOL)isCreatedByMe;

// 是否为我管理的群
- (BOOL)isManagedByMe;

// 是否为聊天室
- (BOOL)isChatRoom;

// 是否为聊天组
- (BOOL)isChatGroup;

// 是否为公开群
- (BOOL)isPublicGroup;

- (NSString *)selfNamecard;

- (NSString *)receiveMessageOpt;

- (NSString *)groupAddOpt;

@end
