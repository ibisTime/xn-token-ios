//
//  ChatGroupMemberListViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/4.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatGroupMemberListViewController.h"

#import "IMAGroup+MemberList.h"

#define kAdmin @"admin"
#define kMember @"member"

@implementation ChatGroupMemberListViewController

- (instancetype)initWith:(IMAGroup *)group
{
    if (self = [super init])
    {
        _group = group;
        self.title = [NSString stringWithFormat:@"成员列表(%u)",_group.groupInfo.memberNum];
       
        _memberDic = [NSMutableDictionary dictionary];
        
        NSMutableArray  *adminsArray = [NSMutableArray array];
        KeyValue *kvAdmin = [[KeyValue alloc] initWithKey:[self section0:1] value:adminsArray];
        
        [_memberDic setObject:kvAdmin forKey:kAdmin];
        
        NSMutableArray  *memberArray = [NSMutableArray array];
        KeyValue *kvMember = [[KeyValue alloc] initWithKey:[self section1:1] value:memberArray];
        
        [_memberDic setObject:kvMember forKey:kMember];
        
        [self addNotification];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self canAddRightBarItem])
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加成员" style:UIBarButtonItemStylePlain target:self action:@selector(onRightItem:)];
    }
    
    [self loadMember];
}

//type:1:公开群 2:讨论组 3:聊天室
- (NSString *)section0:(NSInteger)type
{
    if (type == 1)
    {
        return @"群主、管理员";
    }
    return nil;
}

- (NSString *)section1:(NSInteger)type
{
    if (type == 1)
    {
        return @"其它成员";
    }
    return nil;
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onModifyNameCard:) name:kGroup_ModifyNameCardNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSetAdmin:) name:kGroup_SetAdminNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRemoveGroup:) name:kGroup_RemoveMemberNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onJoinedGroup:) name:kGroup_InviteJoinedMemberNotification object:nil];
}

- (void)onModifyNameCard:(NSNotification *)notify
{
    IMAGroupMember *user = (IMAGroupMember *)notify.object;
    
    KeyValue *kvAdmin = [self getAdminKeyValue];
    NSMutableArray *admins = kvAdmin.value;
    
    NSInteger index = [admins indexOfObject:user];
    if (index >= 0 && index < admins.count)//修改的是管理员的群名片
    {
        IMAGroupMember *groupMember = [admins objectAtIndex:index];
        groupMember.memberInfo.nameCard = user.memberInfo.nameCard;
        [self reloadData];
        return;
    }
    
    KeyValue *kvOtherMember = [self getOtherMemberKeyValue];
    NSMutableArray *otherMembers = kvOtherMember.value;
    
    index = [otherMembers indexOfObject:user];
    if (index >= 0 && index < otherMembers.count)//修改的是普通成员的群名片
    {
        IMAGroupMember *groupMember = [otherMembers objectAtIndex:index];
        groupMember.memberInfo.nameCard = user.memberInfo.nameCard;
        [self reloadData];
        return;
    }
}

- (void)onSetAdmin:(NSNotification *)notify
{
    IMAUser *user = (IMAUser *)notify.object;
    
    [self swapRoleData:user];
    [self reloadData];
}

- (void)swapRoleData:(IMAUser *)user
{
    if (!user)
    {
        return;
    }
    KeyValue *kvAdmin = [self getAdminKeyValue];
    NSMutableArray *admins = (NSMutableArray *)kvAdmin.value;
    
    KeyValue *kvOtherMember = [self getOtherMemberKeyValue];
    NSMutableArray *otherMembers = (NSMutableArray *)kvOtherMember.value;
    
    NSInteger index = [admins indexOfObject:user];
    if (index >= 0 && index < admins.count)
    {
        // cancel admin
        [admins removeObject:user];
        [otherMembers insertObject:user atIndex:0];
//        kvAdmin.key = [NSString stringWithFormat:@"群主、管理员(%ld人)", admins.count];
//        kvOtherMember.key = [NSString stringWithFormat:@"其他成员(%ld人)",otherMembers.count];
        ((IMAGroupMember *)user).memberInfo.role = TIM_GROUP_MEMBER_ROLE_MEMBER;
        
        if ([self adminsCount] < 1)
        {
            [_memberDic removeObjectForKey:kAdmin];
        }
        return;
    }
    
    index = [otherMembers indexOfObject:user];
    if (index >= 0 && index < otherMembers.count)
    {
        // set admin
        [otherMembers removeObject:user];
        [admins addObject:user];
//        kvOtherMember.key = [NSString stringWithFormat:@"其他成员(%ld人)",otherMembers.count];
//        kvAdmin.key = [NSString stringWithFormat:@"群主、管理员(%ld人)", admins.count];

        ((IMAGroupMember *)user).memberInfo.role = TIM_GROUP_MEMBER_ROLE_ADMIN;
        
        if ([self otherMemberCount] < 1)
        {
            [_memberDic removeObjectForKey:kMember];
        }
        return;
    }
}

- (void)onRemoveGroup:(NSNotification *)notify
{
    IMAUser *user = (IMAUser *)notify.object;
    
    KeyValue *kvAdmin = [self getAdminKeyValue];
    NSMutableArray *admins = kvAdmin.value;
    
    NSInteger index = [admins indexOfObject:user];
    if (index >= 0 && index < admins.count)//移除的成员是管理员
    {
        [admins removeObjectAtIndex:index];
//        kvAdmin.key = [NSString stringWithFormat:@"群主、管理员(%ld人)", admins.count];
        if ([self adminsCount] < 1)
        {
            [_memberDic removeObjectForKey:kAdmin];
        }
        
    }
    else//移除的成员是普通成员
    {
        KeyValue *kvOtherMember = [self getOtherMemberKeyValue];
        NSMutableArray *otherMembers = kvOtherMember.value;
        
        index = [otherMembers indexOfObject:user];
        if (index >= 0 && index < otherMembers.count)
        {
            [otherMembers removeObjectAtIndex:index];
            //        kvOtherMember.key = [NSString stringWithFormat:@"其他成员(%ld人)",otherMembers.count];
            if ([self otherMemberCount] < 1)
            {
                [_memberDic removeObjectForKey:kMember];
            }
        }
    }
    [self reloadData];
    
    self.title = [NSString stringWithFormat:@"成员列表(%u)", _group.groupInfo.memberNum-1];
    
}

- (void)onJoinedGroup:(NSNotification *)notify
{
    NSArray *users = (NSArray *)notify.object;
    if (!users)
    {
        return;
    }
    
    KeyValue *kvOtherMember = [self getOtherMemberKeyValue];
    NSMutableArray *otherMembers = kvOtherMember.value;
    
    if (!otherMembers)
    {
        return;
    }
    
    for (TIMGroupMemberResult *result in users)
    {
        IMAUser *temp = [[IMAUser alloc] initWith:result.member];
        [otherMembers addObject:temp];
    }
    
    [self reloadData];
    
    self.title = [NSString stringWithFormat:@"成员列表(%u)", _group.groupInfo.memberNum + (uint32_t)users.count];
}

- (BOOL)canAddRightBarItem
{
    BOOL noCanAdd = [_group isChatRoom] | [_group isPublicGroup];//聊天室和公开群不能邀请好友
    if (noCanAdd)
    {
        return NO;
    }
    return YES;
}

- (void)inviteJoin:(NSArray *)array
{
    [_group asyncInviteMembers:array succ:^(NSArray *members) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kGroup_InviteJoinedMemberNotification object:members];
        [[HUDHelper sharedInstance] tipMessage:@"邀请成功"];
    } fail:nil];
}

- (void)onRightItem:(UIBarButtonItem *)baritem
{
    __weak ChatGroupMemberListViewController *ws = self;
    
    NSMutableArray *existedMembers = [NSMutableArray array];
    NSArray *keys = [_memberDic allKeys];
    for (id key in keys)
    {
        KeyValue *kv = [_memberDic objectForKey:key];
        [existedMembers addObjectsFromArray:kv.value];
    }
    FriendPickerViewController *pvc = [[FriendPickerViewController alloc] initWithCompletion:^(FriendPickerViewController *selfPtr, BOOL isFinished) {
        if (isFinished)
        {
            [ws inviteJoin:selfPtr.selectedFriends];
        }
    } existedMembers:existedMembers right:@"发送邀请"];
    
    [[AppDelegate sharedAppDelegate] presentViewController:pvc animated:YES completion:nil];
}


- (void)addHeaderView
{
    
}

- (BOOL)hasData
{
    return YES;
}

- (void)loadMember
{
    __weak ChatGroupMemberListViewController * ws = self;
    __weak RequestPageParamItem *wp = _pageItem;
    [_group asyncMembersV2Of:_pageItem succ:^(uint64_t nextSeq, NSArray *admins, NSArray *otherMembers) {
        
        ws.canLoadMore = wp.canLoadMore;
        
        [ws addToMemberDic:admins others:otherMembers];
        [ws reloadData];
    } fail:^(int code, NSString *msg) {
        DebugLog(@"获取群成员失败。code=%d,err=%@",code,msg);
    }];
}

//不考虑性能的情况下，设置管理员，移除群成员，修改群名片可以调用这个函数
//优点是逻辑简单，缺点是性能低
- (void)reLoadMemeber
{
    _pageItem.pageIndex = 0;
    
    NSArray *keys = [_memberDic allKeys];
    for (NSString *key in keys)
    {
        KeyValue *kv = [_memberDic objectForKey:key];
        NSMutableArray *array = kv.value;
        [array removeAllObjects];
    }
    
    [self loadMember];
}

- (void)onLoadMore
{
    if (_pageItem.pageIndex!=0)
    {
        [self loadMember];
    }
}

- (void)addToMemberDic:(NSArray *)admins others:(NSArray *)otherMembers
{
    if ([_group isChatGroup])
    {
        [_memberDic removeObjectForKey:kAdmin];
        
        KeyValue *kv = [self getOtherMemberKeyValue];
        
        NSMutableArray *kvOtherMembers = kv.value;
        [kvOtherMembers addObjectsFromArray:admins];
        [kvOtherMembers addObjectsFromArray:otherMembers];

        kv.key = [NSString stringWithFormat:@"讨论组成员"];
        
        if (kvOtherMembers.count < 1)
        {
            [_memberDic removeObjectForKey:kMember];
        }
    }
    else
    {
        if (admins.count > 0)
        {
            KeyValue *kv = [self getAdminKeyValue];
            
            NSMutableArray *kvaAmins = kv.value;
            [kvaAmins addObjectsFromArray:admins];

//            kv.key = [NSString stringWithFormat:@"群主、管理员(%ld人)",kvaAmins.count];
        }
        if (otherMembers.count > 0)
        {
            KeyValue *kv = [self getOtherMemberKeyValue];
            
            NSMutableArray *kvOtherMembers = kv.value;
            [kvOtherMembers addObjectsFromArray:otherMembers];

//            kv.key = [NSString stringWithFormat:@"其他成员(%ld人)",kvOtherMembers.count];
        }
        
        if ([self adminsCount] < 1)
        {
            [_memberDic removeObjectForKey:kAdmin];
        }
        if ([self otherMemberCount] < 1)
        {
            [_memberDic removeObjectForKey:kMember];
        }
    }
}

- (KeyValue *)getAdminKeyValue
{
    KeyValue *kv = [_memberDic objectForKey:kAdmin];
    if (!kv)
    {
        NSMutableArray  *memberArray = [NSMutableArray array];
        kv = [[KeyValue alloc] initWithKey:[self section0:1] value:memberArray];
        [_memberDic setObject:kv forKey:kAdmin];
    }
    return kv;
}

- (KeyValue *)getOtherMemberKeyValue
{
    KeyValue *kv = [_memberDic objectForKey:kMember];
    if (!kv)
    {
        NSMutableArray  *memberArray = [NSMutableArray array];
        kv = [[KeyValue alloc] initWithKey:[self section1:1] value:memberArray];
        [_memberDic setObject:kv forKey:kMember];
    }
    return kv;
}

- (NSInteger)adminsCount
{
    KeyValue *kv = [_memberDic objectForKey:kAdmin];

    if (kv)
    {
        NSArray *array = kv.value;
        return array.count;
    }
    return 0;
}

- (NSInteger)otherMemberCount
{
    KeyValue *kv = [_memberDic objectForKey:kMember];
    
    if (kv)
    {
        NSArray *array = kv.value;
        return array.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_group isChatGroup])
    {
        return 1;
    }
    else
    {
        return [_memberDic count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    KeyValue *kv = [self getKeyValue:section];
    if (!kv)
    {
        return 0;
    }
    NSMutableArray *members = kv.value;
    return members.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerViewId = @"TextTableViewHeaderView";
    TextTableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
    if (!headerView)
    {
        headerView = [[TextTableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewId];
    }
    
    KeyValue *kv = [self getKeyValue:section];
    if (!kv)
    {
        return nil;
    }

    headerView.tipLabel.text = kv ? kv.key : @"成员列表";
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactItemTableViewCell"];
    if (!cell)
    {
        cell = [[ContactItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactItemTableViewCell"];
    }
    
    KeyValue *kv = [self getKeyValue:indexPath.section];
    if (!kv)
    {
        return nil;
    }
    
    NSArray *items = kv.value;
    id<IMAContactItemShowAble> user = [items objectAtIndex:indexPath.row];
    [cell configWithItem:user];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeyValue *kv = [self getKeyValue:indexPath.section];
    if (!kv)
    {
        return;
    }
    NSMutableArray *members = kv.value;
    IMAGroupMember *groupUser = [members objectAtIndex:indexPath.row];
    
    if ([[IMAPlatform sharedInstance].host isMe:groupUser])
    {
        MyProfileViewController *vc = [[MyProfileViewController alloc] initWith:[IMAPlatform sharedInstance].host];
        [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
    }
    else //是好友或陌生人都是同样的显示方式
    {
        GroupMemberProfileViewController *vc = [[GroupMemberProfileViewController alloc] init:groupUser groupInfo:_group];
        [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
    }
}

- (KeyValue *)getKeyValue:(NSInteger)section
{
    KeyValue *kv = nil;
    if ([_group isChatGroup])
    {
        kv = [_memberDic objectForKey:kMember];
    }
    else
    {
        if (section == 0)
        {
            kv = [_memberDic objectForKey:kAdmin];
            if (!kv)
            {
                kv = [_memberDic objectForKey:kMember];
            }
        }
        else if (section == 1)
        {
            kv = [_memberDic objectForKey:kMember];
        }
    }
    return kv;
}
@end
