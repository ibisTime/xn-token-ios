//
//  GroupMemberListViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/4.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "GroupMemberListViewController.h"

@implementation GroupMemberListViewController

- (BOOL)canAddRightBarItem
{
    BOOL noCanAdd = [_group isChatRoom] | [_group isPublicGroup];//聊天室和公开群不能邀请好友
    if (noCanAdd)
    {
        return NO;
    }
    return [_group isCreatedByMe] || [_group isManagedByMe];
}

@end
