//
//  IMAContactManager.m
//  TIMAdapter
//
//  Created by AlexiChen on 16/2/18.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAContactManager.h"




@implementation IMAContactChangedNotifyItem

- (instancetype)initWith:(IMAContactChangedNotifyType)type
{
    if (self = [super init])
    {
        _type = type;
    }
    return self;
}

- (NSNotification *)changedNotification
{
    NSNotification *notify = [NSNotification notificationWithName:[self notificationName] object:self];
    return notify;
}

- (NSString *)notificationName
{
    return [NSString stringWithFormat:@"IMAContactChangedNotification_%d", (int)_type];
}

@end


@implementation IMAContactManager

- (void)saveToLocal
{
    [self saveSubGroupStateInfoToLocal];
}


- (void)asyncConfigContact
{
    // 分组是FriendShipProxy下的内容
    // 同步分组列表
    [self asyncSubGroupList];
}

// 异步配置群相关内容
- (void)asyncConfigGroup
{
    // 是GroupAssistant下的内容
    // 同步群列表
    [self syncGroupList];
    
    // 异步黑名单
    [self asyncBlackList];
}


- (CLSafeMutableArray *)clearPickedSubGroupList
{
    NSInteger count = [_subGroupList count];
    for (NSInteger i = 0; i < count; i++)
    {
        IMASubGroup *group = [_subGroupList objectAtIndex:i];
        
        NSInteger fcount = group.friends.count;
        for (NSInteger j = 0; j < fcount; j++)
        {
            IMAUser *user = [group.friends objectAtIndex:j];
            user.isSelected = NO;
        }
    }
    
    return _subGroupList;
}

- (IMASubGroup *)getSubGroupOf:(NSString *)sgNAme
{
    IMASubGroup *temp = [[IMASubGroup alloc] initWithName:sgNAme];
    NSInteger idx = [_subGroupList indexOfObject:temp];
    if (idx >= 0 && idx < _subGroupList.count)
    {
        return [_subGroupList objectAtIndex:idx];
    }
    else
    {
        return [self defaultAddToSubGroup];
    }
}

- (IMASubGroup *)subgroupOf:(IMAUser *)user
{
    if ([user isC2CType])
    {
        for (NSInteger i = 0; i < _subGroupList.count; i++)
        {
            IMASubGroup *sg = [_subGroupList objectAtIndex:i];
            NSInteger index = [sg.friends indexOfObject:user];
            if (index >= 0 && index < sg.friends.count)
            {
                return sg;
            }
        }
    }
    return nil;
}

- (IMAUser *)isContainUser:(IMAUser *)user
{
    if ([user isC2CType])
    {
        for (NSInteger i = 0; i < _subGroupList.count; i++)
        {
            IMASubGroup *sg = [_subGroupList objectAtIndex:i];
            NSInteger index = [sg.friends indexOfObject:user];
            if (index >= 0 && index < sg.friends.count)
            {
                return [sg.friends objectAtIndex:index];
            }
        }
    }
    else if ([user isGroupType])
    {
        NSInteger index = [_groupList indexOfObject:user];
        if (index >= 0 && index < _groupList.count)
        {
            return [_groupList objectAtIndex:index];
        }
    }
    
    return nil;
}



- (IMAUser *)getUserByGroupId:(NSString *)groupID
{
    if ([NSString isEmpty:groupID])
    {
        return nil;
    }
    IMAUser *item = [[IMAGroup alloc] initWith:groupID];
    return [self isContainUser:item];
    
}

- (IMAUser *)getUserByUserId:(NSString *)userID
{
    if ([NSString isEmpty:userID])
    {
        return nil;
    }
    IMAUser *item = [[IMAUser alloc] initWith:userID];
    return [self isContainUser:item];
}

- (BOOL)isMyFriend:(IMAUser *)user
{
    // 检查通讯录中是否含有些人
    IMAUser *u = [self isContainUser:user];
    
    return u != nil;
}

- (BOOL)isInBlackListByID:(NSString *)userID
{
    IMAUser *u = [[IMAUser alloc] initWith:userID];
    return [self isInBlackList:u];
}
- (BOOL)isInBlackList:(IMAUser *)user
{
    return _blackList && [_blackList containsObject:user];
}

- (void)addContactChangedObserver:(id)observer handler:(SEL)selector forEvent:(NSUInteger)eventID
{
    NSUInteger op = EIMAContact_AddNewSubGroup;
    do
    {
        if (op & eventID)
        {
            NSString *notification = [NSString stringWithFormat:@"IMAContactChangedNotification_%d", (int)op];
            [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:notification object:nil];
            eventID -= op;
        }
        op = op << 1;
        
    } while (eventID > 0);
}

- (void)removeContactChangedObser:(id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

- (void)removeUser:(IMAUser *)user
{
    if (user)
    {
        [self onDeleteFriend:user];
        [[IMAPlatform sharedInstance].conversationMgr removeConversationWith:user];
    }
}

- (void)addUser:(IMAUser *)user toSubGroup:(IMASubGroup *)sg
{
    if (user && [user isC2CType])
    {
        NSInteger idx = [_subGroupList indexOfObject:sg];
        if (idx >= 0 && idx < _subGroupList.count)
        {
            IMASubGroup *dsg = [_subGroupList objectAtIndex:idx];
            
            NSInteger uidx = [dsg.friends indexOfObject:user];
            
            if (!(uidx >= 0 && uidx < dsg.friends.count))
            {
                [dsg.friends addObject:user];
                [self onAddUser:user toSubGroup:dsg];
            }
            
        }
    }
    else
    {
        DebugLog(@"参数有误");
    }
}

- (void)addUserToDefaultSubGroup:(IMAUser *)user
{
    if (user)
    {
        IMASubGroup *sub = [[IMASubGroup alloc] initDefaultSubGroup];
        NSInteger idx = [_subGroupList indexOfObject:sub];
        if (idx >= 0 && idx < _subGroupList.count)
        {
            IMASubGroup *dsg = [_subGroupList objectAtIndex:idx];
            
            NSInteger uidx = [dsg.friends indexOfObject:user];
            
            if (!(uidx >= 0 && uidx < dsg.friends.count))
            {
                [dsg.friends addObject:user];
                [self onAddUser:user toSubGroup:dsg];
            }
        }
    }
}


- (void)removeUserToBlackList:(IMAUser *)user
{
//    [self removeUser:user];//这里不需要移除，添加到黑名单时，会收到一个删除好友的回调通知，-(void) OnDelFriends:(NSArray*)identifiers，在这个回调通知里面已经处理了
    [self onAddToBlackList:user];
}

- (void)removeUserOutBlackList:(IMAUser *)user
{
    [self onRemoveOutBlackList:user];
}




@end





@implementation IMAContactManager (Protected)




- (void)onAddNewSubGroup:(IMASubGroup *)group
{
    NSString * log = [NSString stringWithFormat:@"onAddNewSubGroup1 group.count = %ld,fun = %s",(long)group.itemsCount, __func__];
    [[TIMManager sharedInstance] log:TIM_LOG_ERROR tag:@"ui crash" msg:log];
    NSString * log1 = [NSString stringWithFormat:@"onAddNewSubGroup1 subGroupList.count = %ld,fun = %s",(long)_subGroupList.count, __func__];
    [[TIMManager sharedInstance] log:TIM_LOG_ERROR tag:@"ui crash" msg:log1];
    [self saveSubGroupStateInfoToLocal];
    [_subGroupList addObject:group];
    NSInteger index = [self.subGroupList count] - 1;
    IMAContactChangedNotifyItem *item = [[IMAContactChangedNotifyItem alloc] initWith:EIMAContact_AddNewSubGroup];
    item.subGroup = group;
    item.index = index;
    
    if (_contactChangedCompletion)
    {
        _contactChangedCompletion(item);
    }
    [[NSNotificationQueue defaultQueue] enqueueNotification:[item changedNotification] postingStyle:NSPostWhenIdle];
    NSString * log2 = [NSString stringWithFormat:@"onAddNewSubGroup1 subGroupList.count = %ld,fun = %s",(long)_subGroupList.count, __func__];
    [[TIMManager sharedInstance] log:TIM_LOG_ERROR tag:@"ui crash" msg:log2];
}

- (void)onAddUser:(IMAUser *)user toSubGroup:(IMASubGroup *)group
{
    NSInteger index = [group.friends indexOfObject:user];
    
    IMAContactChangedNotifyItem *item = [[IMAContactChangedNotifyItem alloc] initWith:EIMAContact_AddFriend];
    item.subGroup = group;
    item.user = user;
    item.index = index;
    
    if (_contactChangedCompletion)
    {
        _contactChangedCompletion(item);
    }
    [[NSNotificationQueue defaultQueue] enqueueNotification:[item changedNotification] postingStyle:NSPostWhenIdle];
}

- (void)onDeleteSubGroup:(IMASubGroup *)group
{
    NSString * log1 = [NSString stringWithFormat:@"onDeleteSubGroup subGroupList.count = %ld,fun = %s",(long)_subGroupList.count, __func__];
    [[TIMManager sharedInstance] log:TIM_LOG_ERROR tag:@"ui crash" msg:log1];
    NSInteger index = [_subGroupList indexOfObject:group];
    // todo-todo-
    [_subGroupList removeObject:group];
    
    [self saveSubGroupStateInfoToLocal];
    
    IMAContactChangedNotifyItem *item = [[IMAContactChangedNotifyItem alloc] initWith:EIMAContact_DeleteSubGroup];
    item.subGroup = group;
    item.index = index;
    
    if (_contactChangedCompletion)
    {
        _contactChangedCompletion(item);
    }
    [[NSNotificationQueue defaultQueue] enqueueNotification:[item changedNotification] postingStyle:NSPostWhenIdle];
    
    if (group.friends.count)
    {
        IMASubGroup *defg = [self defaultAddToSubGroup];
        [defg.friends addObjectsFromArray:group.friends.safeArray];
        
        IMAContactChangedNotifyItem *item = [[IMAContactChangedNotifyItem alloc] initWith:EIMAContact_SubGroupChanged];
        item.subGroup = defg;
        item.index = [_subGroupList indexOfObject:defg];
        if (_contactChangedCompletion)
        {
            _contactChangedCompletion(item);
        }
        [[NSNotificationQueue defaultQueue] enqueueNotification:[item changedNotification] postingStyle:NSPostWhenIdle];
    }
    NSString * log2 = [NSString stringWithFormat:@"onDeleteSubGroup subGroupList.count = %ld,fun = %s",(long)_subGroupList.count, __func__];
    [[TIMManager sharedInstance] log:TIM_LOG_ERROR tag:@"ui crash" msg:log2];
}

- (void)onDeleteFriend:(IMAUser *)user
{
    if ([user isC2CType])
    {
        for (NSInteger i = 0; i < _subGroupList.count; i++)
        {
            IMASubGroup *sg = [_subGroupList objectAtIndex:i];
            NSInteger index = [sg.friends indexOfObject:user];
            if (index >= 0 && index < sg.friends.count)
            {
                IMAUser *u = [sg.friends objectAtIndex:index];
                [sg.friends removeObject:u];
                
                // 更新
                IMAContactChangedNotifyItem *item = [[IMAContactChangedNotifyItem alloc] initWith:EIMAContact_DeleteFriend];
                item.subGroup = sg;
                item.user = u;
                item.index = index;
                if (_contactChangedCompletion)
                {
                    _contactChangedCompletion(item);
                }
                [[NSNotificationQueue defaultQueue] enqueueNotification:[item changedNotification] postingStyle:NSPostWhenIdle];
                break;
            }
        }
    }
    else if([user isGroupType])
    {
        NSInteger index = [_groupList indexOfObject:user];
        if (index >= 0 && index < _groupList.count)
        {
            IMAGroup *sg = [_groupList objectAtIndex:index];
            [_groupList removeObject:sg];
            // UI退出后上不存在更新逻辑，所以不发送通知
            //            // 更新
            //            IMAContactChangedNotifyItem *item = [[IMAContactChangedNotifyItem alloc] initWith:EIMAContact_DeleteFriend];
            //            item.subGroup = sg;
            //            item.user = u;
            //            item.index = index;
            //            [[NSNotificationQueue defaultQueue] enqueueNotification:[item changedNotification] postingStyle:NSPostWhenIdle];
            
        }
    }
}

- (void)onFriendInfoChanged:(IMAUser *)user remark:(NSString *)remark
{
    for (NSInteger i = 0; i < _subGroupList.count; i++)
    {
        IMASubGroup *sg = [_subGroupList objectAtIndex:i];
        NSInteger index = [sg.friends indexOfObject:user];
        if (index >= 0 && index < sg.friends.count)
        {
            IMAUser *u = [sg.friends objectAtIndex:index];
            u.remark = remark;
            
            // 更新
            IMAContactChangedNotifyItem *item = [[IMAContactChangedNotifyItem alloc] initWith:EIMAContact_FriendInfoChanged];
            item.subGroup = sg;
            item.user = u;
            item.index = index;
            if (_contactChangedCompletion)
            {
                _contactChangedCompletion(item);
            }
            [[NSNotificationQueue defaultQueue] enqueueNotification:[item changedNotification] postingStyle:NSPostWhenIdle];
            break;
        }
    }
    
    // 有可能不在好友里面
    [[IMAPlatform sharedInstance].conversationMgr updateConversationWith:user];
}

- (void)onLoadDefaultSubGroup:(IMASubGroup *)group
{
    NSString * log = [NSString stringWithFormat:@"subGroupList.count = %ld,fun = %s",(long)_subGroupList.count, __func__];
    [[TIMManager sharedInstance] log:TIM_LOG_ERROR tag:@"ui crash" msg:log];
    // todo-todo-
    [_subGroupList insertObject:group atIndex:0];
    IMAContactChangedNotifyItem *item = [[IMAContactChangedNotifyItem alloc] initWith:EIMAContact_LoadDefaultFriends];
    item.subGroup = group;
    item.index = 0;
    if (_contactChangedCompletion)
    {
        _contactChangedCompletion(item);
    }
    [[NSNotificationQueue defaultQueue] enqueueNotification:[item changedNotification] postingStyle:NSPostWhenIdle];
    NSString * log1 = [NSString stringWithFormat:@"subGroupList.count = %ld,fun = %s",(long)_subGroupList.count, __func__];
    [[TIMManager sharedInstance] log:TIM_LOG_ERROR tag:@"ui crash" msg:log1];
}



- (void)onAddToBlackList:(IMAUser *)user
{
    if (!_blackList)
    {
        _blackList = [[CLSafeMutableArray alloc] init];
    }
    
    [_blackList addObject:user];
    
    
    IMAContactChangedNotifyItem *item = [[IMAContactChangedNotifyItem alloc] initWith:EIMAContact_BlackListAddIn];
    item.index = _blackList.count - 1;
    if (_contactChangedCompletion)
    {
        _contactChangedCompletion(item);
    }
    [[NSNotificationQueue defaultQueue] enqueueNotification:[item changedNotification] postingStyle:NSPostWhenIdle];
}

- (void)onRemoveOutBlackList:(IMAUser *)user
{
    NSInteger idx = [_blackList indexOfObject:user];
    if (idx >= 0 && idx < _blackList.count)
    {
        [_blackList removeObjectAtIndex:idx];
        
        IMAContactChangedNotifyItem *item = [[IMAContactChangedNotifyItem alloc] initWith:EIMAContact_BlackListMoveOut];
        item.index = idx;
        if (_contactChangedCompletion)
        {
            _contactChangedCompletion(item);
        }
        [[NSNotificationQueue defaultQueue] enqueueNotification:[item changedNotification] postingStyle:NSPostWhenIdle];
    }
}

- (void)onMove:(IMAUser *)user from:(IMASubGroup *)fromG to:(IMASubGroup *)toG
{
    IMAUser *u = [self isContainUser:user];
    
    if (u)
    {
        NSInteger fi = [_subGroupList indexOfObject:fromG];
        NSInteger ti = [_subGroupList indexOfObject:toG];
        NSInteger count = [_subGroupList count];
        if (fi >= 0 && fi < count && ti >= 0 && ti < count)
        {
            IMASubGroup *sg = [_subGroupList objectAtIndex:fi];
            NSInteger index = [sg.friends indexOfObject:user];
            [sg.friends removeObject:u];
            
            // 更新
            IMAContactChangedNotifyItem *item = [[IMAContactChangedNotifyItem alloc] initWith:EIMAContact_MoveFriend];
            item.subGroup = sg;
            item.user = u;
            item.index = index;
            
            IMASubGroup *tg = [_subGroupList objectAtIndex:ti];
            [tg.friends addObject:u];
            
            NSInteger tindex = [tg.friends indexOfObject:u];
            
            IMAContactChangedNotifyItem *titem = [[IMAContactChangedNotifyItem alloc] initWith:EIMAContact_AddFriend];
            titem.subGroup = tg;
            titem.user = u;
            titem.index = tindex;
            
            item.toItem = titem;
            
            if (_contactChangedCompletion)
            {
                _contactChangedCompletion(item);
            }
            [[NSNotificationQueue defaultQueue] enqueueNotification:[item changedNotification] postingStyle:NSPostWhenIdle];
        }
        else
        {
            DebugLog(@"不存在的分组");
        }
    }
    else
    {
        DebugLog(@"不存在的User");
    }
}

- (void)onAddGroup:(IMAGroup *)group
{
    if (group)
    {
        [_groupList addObject:group];
    }
}
@end



