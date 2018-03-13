//
//  IMAContactManager+Group.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAContactManager+Group.h"

@implementation IMAContactManager (Group)


- (void)createGroupList:(NSArray *)array
{
    if (array.count)
    {
        NSMutableArray *gidarray = [NSMutableArray array];
        for (TIMGroupInfo *group in array)
        {
            [gidarray addObject:[group group]];
        }
        // 同步群基本信息
        
        __weak IMAContactManager *ws = self;
        [[TIMGroupManager sharedInstance] getGroupInfo:gidarray succ:^(NSArray *array) {
            [ws asyncDetailGroupInfo:array];
        } fail:^(int code, NSString *err) {
            DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
            [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
        }];
    }
    
}


- (void)asyncDetailGroupInfo:(NSArray *)array
{
    if (!_groupList)
    {
        _groupList = [[CLSafeMutableArray alloc] init];
    }
    
    for (TIMGroupInfo *group in array)
    {
        IMAGroup *sg = [[IMAGroup alloc] initWithInfo:group];
        
        [_groupList addObject:sg];
    }
    
//    [[IMAPlatform sharedInstance].conversationMgr asyncConversationList];
}



// 群列表
- (void)asyncGroupList
{
    __weak IMAContactManager *ws = self;

    [[TIMGroupManager sharedInstance] getGroupList:^(NSArray *array) {
        [ws createGroupList:array];
    } fail:^(int code, NSString *err) {
        DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
        DebugLog(@"code = %d, err = %@", code, err);
    }];
}

- (void)syncGroupList
{
    NSArray *array = [[TIMGroupManager sharedInstance] getGroupInfo:nil];
    [self asyncDetailGroupInfo:array];
}

- (TIMGroupInfo *)syncGetGroupInfo:(NSString *)groupId
{
    NSArray *infos = [[TIMGroupManager sharedInstance] getGroupInfo:@[groupId]];
    if (infos.count  > 0)
    {
        return infos[0];
    }
    return nil;
}

- (void)createBlackList:(NSArray *)array
{
    if (array.count)
    {
        NSMutableArray *ba = [NSMutableArray array];
        for (NSString *userid in array)
        {
            IMAUser *user = [[IMAUser alloc] initWith:userid];
            [ba addObject:user];
        }
        
        if (!_blackList)
        {
            _blackList = [[CLSafeMutableArray alloc] init];
        }
        [_blackList addObjectsFromArray:ba];
    }
}

// 黑名单
- (void)asyncBlackList
{
    __weak IMAContactManager *ws = self;
    [[TIMFriendshipManager sharedInstance] getBlackList:^(NSArray *array) {
        [ws createBlackList:array];
    } fail:^(int code, NSString *err) {
        DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
        DebugLog(@"code = %d, err = %@", code, err);
    }];
}


// 获取公开群
- (NSMutableDictionary *)publicGroups
{
    NSMutableArray *myOwn = [NSMutableArray array];
    NSMutableArray *myMgr = [NSMutableArray array];
    NSMutableArray *myBelongTo = [NSMutableArray array];
    
    for (NSInteger i = 0; i < _groupList.count; i++)
    {
        IMAGroup *group = [_groupList objectAtIndex:i];
        if ([group isPublicGroup])
        {
            if ([group isCreatedByMe])
            {
                [myOwn addObject:group];
            }
            else if ([group isManagedByMe])
            {
                [myMgr addObject:group];
            }
            else
            {
                [myBelongTo addObject:group];
            }
        }
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (myOwn.count > 0)
    {
        [dic setObject:myOwn forKey:@"我创建的群"];
    }
    if (myMgr.count > 0)
    {
        [dic setObject:myMgr forKey:@"我管理的群"];
    }
    if (myBelongTo.count > 0)
    {
        [dic setObject:myBelongTo forKey:@"我加入的群"];
    }
    
    return dic;
}

// 获取聊天室
- (NSMutableArray *)chatRooms
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < _groupList.count; i++)
    {
        IMAGroup *group = [_groupList objectAtIndex:i];
        if ([group isChatRoom])
        {
            [array addObject:group];
        }
    }
    return array;
    
}

// 获取讨论组
- (NSMutableArray *)chatGroup
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < _groupList.count; i++)
    {
        IMAGroup *group = [_groupList objectAtIndex:i];
        if ([group isChatGroup])
        {
            [array addObject:group];
        }
    }
    return array;
}

// 30 字节长度
#define kMaxGroupNameLength 30

- (BOOL)checkGroupParams:(NSString *)name members:(NSArray *)array
{
    if ([name isContainsEmoji])
    {
        [HUDHelper alert:@"群名称不能包含表情"];
        return NO;
    }
    
    if (array.count == 0)
    {
        [HUDHelper alert:@"未选择加入群组的好友"];
        return NO;
    }
    return YES;
}

- (void)asyncGroupInfo:(NSString *)groupId onCreateSucc:(void (^)(IMAGroup *group))succ fail:(TIMFail)fail
{
    // 同步群信息
    // 添加成功
    [[TIMGroupManager sharedInstance] getGroupInfo:@[groupId] succ:^(NSArray *array) {
        
        if (array.count)
        {
            // 只会返回一个信息
            TIMGroupInfo *groupInfo = array[0];
            IMAGroup *sg = [[IMAGroup alloc] initWithInfo:groupInfo];
            [self.groupList addObject:sg];
            
            if (succ)
            {
                succ(sg);
            }
            
        }
    } fail:^(int code, NSString *err) {
        DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
        if (fail)
        {
            fail(code, err);
        }
    }];
}

typedef void (^IMACreateCompletion)(IMAGroup *group);
typedef void (^CreateGroupOperation)(NSString *groupName, NSArray *memids, IMACreateCompletion succ, TIMFail fail);

- (void)onWillCreateGroupWith:(NSString *)name members:(NSArray *)array operation:(CreateGroupOperation)op succ:(void (^)(IMAGroup *group))succ fail:(TIMFail)fail
{
    if (![self checkGroupParams:name members:array])
    {
        return;
    }
    
    size_t length = strlen([name UTF8String]);
    if( length > kMaxGroupNameLength)
    {
        name = [name cutBeyondTextInLength:kMaxGroupNameLength];
    }
    
    NSMutableArray *mems = [NSMutableArray array];
    for (IMAUser *user in array)
    {
        TIMCreateGroupMemberInfo *mem = [[TIMCreateGroupMemberInfo alloc] init];
        mem.member = [user userId];
        mem.role = TIM_GROUP_MEMBER_ROLE_MEMBER;
        [mems addObject:mem];
    }
    
    if (op)
    {
        op(name, mems, succ, fail);
    }
}


- (void)asyncCreateChatGroupWith:(NSString *)name members:(NSArray *)array succ:(void (^)(IMAGroup *group))succ fail:(TIMFail)fail
{
//    __weak IMAContactManager *ws = self;
    [self onWillCreateGroupWith:name members:array operation:^(NSString *groupName, NSArray *memids, IMACreateCompletion succ, TIMFail fail) {
        
        TIMCreateGroupInfo *cgi = [[TIMCreateGroupInfo alloc] init];
        cgi.group = nil;
        cgi.groupName = name;
        cgi.groupType = @"Private";
        cgi.maxMemberNum = 0;
        cgi.membersInfo = memids;
        
        [[TIMGroupManager sharedInstance] createGroup:cgi succ:^(NSString *groupId) {

            TIMGroupInfo *tgi = [TIMGroupInfo instanceFrom:cgi];
            tgi.group = groupId;
            tgi.owner = [[IMAPlatform sharedInstance].host userId];
            
            IMAGroup *g = [[IMAGroup alloc] initWithInfo:tgi];
            
            if (succ)
            {
                succ(g);
            }
        } fail:^(int code, NSString *err) {
            DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
            [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
            if (fail)
            {
                fail(code, err);
            }
        }];
    } succ:succ fail:fail];
    
}

- (void)asyncCreatePublicGroupWith:(NSString *)name members:(NSArray *)array succ:(void (^)(IMAGroup *group))succ fail:(TIMFail)fail
{
//    __weak IMAContactManager *ws = self;
    [self onWillCreateGroupWith:name members:array operation:^(NSString *groupName, NSArray *memids, IMACreateCompletion succ, TIMFail fail) {
        
        TIMCreateGroupInfo *cgi = [[TIMCreateGroupInfo alloc] init];
        cgi.group = nil;
        cgi.groupName = name;
        cgi.groupType = @"Public";
        cgi.addOpt = TIM_GROUP_ADD_ANY;
        cgi.maxMemberNum = 0;
        cgi.membersInfo = memids;
        
        [[TIMGroupManager sharedInstance] createGroup:cgi succ:^(NSString *groupId) {
            //注:这里成功回调时，不能调用getGroupInfo，因为群信息还没有同步下来，必须是在onGroupAdd回调之后才能回去到详细的群信息
            
            TIMGroupInfo *tgi = [TIMGroupInfo instanceFrom:cgi];
            tgi.group = groupId;
            tgi.owner = [[IMAPlatform sharedInstance].host userId];
            
            IMAGroup *g = [[IMAGroup alloc] initWithInfo:tgi];
            
            if (succ)
            {
                succ(g);
            }
        } fail:^(int code, NSString *err) {
            DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
            [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
            if (fail)
            {
                fail(code, err);
            }
        }];
    } succ:succ fail:fail];
}


- (void)asyncCreateChatRoomWith:(NSString *)name members:(NSArray *)array succ:(void (^)(IMAGroup *group))succ fail:(TIMFail)fail
{
//    __weak IMAContactManager *ws = self;
    [self onWillCreateGroupWith:name members:array operation:^(NSString *groupName, NSArray *memids, IMACreateCompletion succ, TIMFail fail) {
        
        TIMCreateGroupInfo *cgi = [[TIMCreateGroupInfo alloc] init];
        cgi.group = nil;
        cgi.groupName = name;
        cgi.groupType = @"ChatRoom";
        cgi.addOpt = TIM_GROUP_ADD_ANY;
        cgi.maxMemberNum = 0;
        cgi.membersInfo = memids;
        
        [[TIMGroupManager sharedInstance] createGroup:cgi succ:^(NSString *groupId) {
            
            TIMGroupInfo *tgi = [TIMGroupInfo instanceFrom:cgi];
            tgi.group = groupId;
            tgi.owner = [[IMAPlatform sharedInstance].host userId];
            
            IMAGroup *g = [[IMAGroup alloc] initWithInfo:tgi];
            
            if (succ)
            {
                succ(g);
            }
        } fail:^(int code, NSString *err) {
            DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
            [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
            if (fail)
            {
                fail(code, err);
            }
        }];
    } succ:succ fail:fail];
}

- (void)asyncGetGroupPendencyList:(TIMGetGroupPendencyListSucc)succ fail:(TIMFail)fail
{
    TIMGroupPendencyOption *opt = [[TIMGroupPendencyOption alloc] init];
    opt.timestamp = 0;
    opt.numPerPage = 100;
    
    [[TIMGroupManager sharedInstance] getPendencyFromServer:opt succ:^(TIMGroupPendencyMeta *meta, NSArray *pendencies) {
        if (succ)
        {
            succ(meta, pendencies);
        }
    } fail:^(int code, NSString *msg) {
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}

- (void)asyncGroupPendencyReport:(uint64_t)timestamp succ:(TIMSucc)succ fail:(TIMFail)fail
{
    [[TIMGroupManager sharedInstance] pendencyReport:timestamp succ:^{
        if (succ)
        {
            succ();
        }
    } fail:^(int code, NSString *msg) {
        DebugLog(@"group pendency report fail (code = %d, msg = %@)",code, msg);
        
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}

- (void)asyncAcceptAddGroup:(NSString*)msg pendencyItem:(TIMGroupPendencyItem *)item succ:(TIMSucc)succ fail:(TIMFail)fail
{
    if (!item)
    {
        return;
    }
    
    [item accept:msg succ:^{
        if (succ)
        {
            succ();
        }
    } fail:^(int code, NSString *msg) {
        
        NSString *errInfo = [NSString stringWithFormat:@"accept fail code = %d,msg = %@", code, msg];
        DebugLog(@"%@", errInfo);
        
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}
- (void)asyncRefuseAddGroup:(NSString*)msg pendencyItem:(TIMGroupPendencyItem *)item succ:(TIMSucc)succ fail:(TIMFail)fail
{
    if (!item)
    {
        return;
    }
    
    [item refuse:msg succ:^{
        if (succ)
        {
            succ();
        }
    } fail:^(int code, NSString *msg) {
        NSString *errInfo = [NSString stringWithFormat:@"refuse fail code = %d,msg = %@", code, msg];
        DebugLog(@"%@", errInfo);
        
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}
@end
