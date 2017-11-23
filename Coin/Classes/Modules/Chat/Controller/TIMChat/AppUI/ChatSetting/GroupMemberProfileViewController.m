//
//  GroupMemberProfileViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "GroupMemberProfileViewController.h"

#import "GroupMemberInfoCell.h"

#import "IMAGroup+MemberList.h"

#import "IMAGroup+Admin.h"


@interface GroupMemberProfileViewController ()

@end

@implementation GroupMemberProfileViewController

- (instancetype)init:(IMAGroupMember *)groupMember groupInfo:(IMAGroup *)groupInfo
{
    if (self = [super init])
    {
        _user = groupMember;
        _group =  groupInfo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"成员资料";
    
}
- (void)configOwnViews
{
    _dataDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *items = [NSMutableArray array];
    
    __weak GroupMemberProfileViewController *ws = self;
    
    if ([_group isManagedByMe] || [_group isCreatedByMe])
    {
        id<IMAShowAble> able = _user;
        RichCellMenuItem *nameCard = [[RichCellMenuItem alloc] initWith:@"群名片" value:[able showTitle] type:ERichCell_TextNext action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
            [ws onEditNameCard:menu cell:cell];
        }];
        [items addObject:nameCard];
    }
    
    BOOL needSetAdmin = NO;
    BOOL needForbid = NO;
    if (![_group isChatGroup])
    {
        if ([_group isCreatedByMe])
        {
            needSetAdmin = YES;
            needForbid = YES;
        }
        else if ([_group isManagedByMe])
        {
            if ([_user isNormalMember])
            {
                needForbid = YES;
            }
        }
    }
    
    if (needSetAdmin)
    {
        RichCellMenuItem *setAdmin = [[RichCellMenuItem alloc] initWith:@"设为管理员" value:nil type:ERichCell_Switch action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
            [ws setAdmin:menu cell:cell];
        }];
        setAdmin.switchValue = [_user isGroupAdmin];
        [items addObject:setAdmin];
    }
    if (needForbid)
    {
        RichCellMenuItem *forbid = [[RichCellMenuItem alloc] initWith:@"禁言" value:nil type:ERichCell_Switch action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
            [ws setSilence:menu cell:cell];
        }];
        forbid.switchValue = [_user isSilence];
        [items addObject:forbid];
    }
    [_dataDictionary setObject:items forKey:@(1)];
}

- (void)setAdmin:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    BOOL isAdmin = [_user isGroupAdmin];
    
    __weak RichCellMenuItem *wm = menu;
    __weak RichMenuTableViewCell *wc = (RichMenuTableViewCell *)cell;
    __weak IMAUser *wu = _user;
    [_group asyncModifyGroupMemberRole:_user role:isAdmin ? TIM_GROUP_MEMBER_ROLE_MEMBER : TIM_GROUP_MEMBER_ROLE_ADMIN succ:^{
        wm.switchValue = !wm.switchValue;
        [wc configWith:menu];
        [[NSNotificationCenter defaultCenter] postNotificationName:kGroup_SetAdminNotification object:wu];
    } fail:nil];
}

- (void)setSilence:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    uint32_t stime = 0;
    
    __weak RichCellMenuItem *wm = menu;
    if (!wm.switchValue)
    {
        stime = kDefaultSilentUntil;
    }
    __weak RichMenuTableViewCell *wc = (RichMenuTableViewCell *)cell;
    
    __weak IMAGroupMember *wu = _user;
    [_group asyncModifyGroupMemberInfoSetSilence:_user stime:stime succ:^{
        wm.switchValue = !wm.switchValue;
        [wc configWith:menu];
        uint32_t curTime = [[NSDate date] timeIntervalSince1970];
        wu.memberInfo.silentUntil = curTime + kDefaultSilentUntil;
    } fail:nil];
}

- (NSString *)removeGroupTitle
{
    return @"将其从群中移除";
}

- (void)addFooterView
{
    BOOL needAddFooter = NO;
    
    if ([_group isCreatedByMe])
    {
        needAddFooter = YES;
    }
    else if ([_group isManagedByMe])
    {
        if ([_user isNormalMember])
        {
            needAddFooter = YES;
        }
    }
    else
    {
        // do nothing
    }
    if (!needAddFooter)
    {
        return;
    }
    __weak GroupMemberProfileViewController *ws = self;
    UserActionItem *removeGroup = [[UserActionItem alloc] initWithTitle:[self removeGroupTitle] icon:nil action:^(id<MenuAbleItem> menu) {
        [ws onRemoveGroup];
    }];
    removeGroup.normalBack = [UIImage imageWithColor:kRedColor size:CGSizeMake(32, 32)];
    
    UserProfileFooterPanel *footer = [[UserProfileFooterPanel alloc] initWith:@[removeGroup]];
    [footer setFrameAndLayout:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    _tableView.tableFooterView = footer;
}

- (void)onRemoveGroup
{
    __weak GroupMemberProfileViewController *ws = self;
    NSArray *array = [NSArray arrayWithObject:_user.userId];
    [_group asyncRemoveMembersOf:array succ:^(NSArray *members) {
        [[HUDHelper sharedInstance] tipMessage:@"移除成功" delay:0.5];
        [ws dismissSelf];
    } fail:nil];
}

- (void)dismissSelf
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kGroup_RemoveMemberNotification object:_user];
    [[AppDelegate sharedAppDelegate] popViewController];
}

- (void)onEditNameCard:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak IMAGroup *wg = _group;
    __weak IMAGroupMember *wu = _user;
    [self onEdit:menu cell:cell action:^(NSString *editText) {
        [wg asyncModifyGroupNameCard:editText user:wu.userId succ:^{
            // TODO：网络更新讨论组名
            menu.value = editText;
            [(RichMenuTableViewCell *)cell configWith:menu];
            
            wu.memberInfo.nameCard = editText;
            [[NSNotificationCenter defaultCenter] postNotificationName:kGroup_ModifyNameCardNotification object:_user];
        } fail:nil];
    }];
    
}

- (void)onEdit:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell action:(void (^)(NSString *editText))handle
{
    
    EditInfoViewController *vc = [[EditInfoViewController alloc] initWith:[NSString stringWithFormat:@"修改%@", menu.tip] text:menu.value completion:^(EditInfoViewController *selfPtr, BOOL isFinished) {
        if (isFinished)
        {
            NSString *editText = selfPtr.editText;
            
            if (handle)
            {
                handle(editText);
            }
        }
    }];
    [[AppDelegate sharedAppDelegate] presentViewController:vc animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 70;
    }
    else
    {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataDictionary count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    
    NSArray *array = _dataDictionary[@(section)];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        GroupMemberInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberIconCell"];
        if (!cell)
        {
            cell = [[GroupMemberInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MemberIconCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [cell configWith:_user];
        return cell;
    }
    else
    {
       return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if ([[IMAPlatform sharedInstance].host isMe:_user])
        {
        }
        else if ([[IMAPlatform sharedInstance].contactMgr isMyFriend:_user])
        {
            FriendProfileViewController *vc = [[FriendProfileViewController alloc] initWith:_user];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
        else
        {
            StrangerProfileViewController *vc = [[StrangerProfileViewController alloc] initWith:_user];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
    }
    else
    {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

@end
