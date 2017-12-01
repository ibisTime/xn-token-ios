//
//  ChatGroupProfileViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/4.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatGroupProfileViewController.h"

#import "IMAGroup+MemberList.h"

@implementation ChatGroupProfileViewController

- (void)addHeaderView
{
    
}

- (void)addFooterView
{
    __weak ChatGroupProfileViewController *ws = self;
    UserActionItem *exitGroup = [[UserActionItem alloc] initWithTitle:@"退出讨论组" icon:nil action:^(id<MenuAbleItem> menu) {
        [ws onExitGroup];
    }];
    exitGroup.normalBack = [UIImage imageWithColor:kRedColor size:CGSizeMake(32, 32)];
    
    UserProfileFooterPanel *footer = [[UserProfileFooterPanel alloc] initWith:@[exitGroup]];
    [footer setFrameAndLayout:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    _tableFooter = footer;
    
    _tableView.tableFooterView = _tableFooter;
}

- (void)onExitGroup
{
    IMAGroup *group = (IMAGroup *)_user;
    [group asyncExitGroupSucc:^{
        [[AppDelegate sharedAppDelegate] popToRootViewController];
    } fail:nil];
}


- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onJoinedGroup:) name:kGroup_InviteJoinedMemberNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRemoveGroup:) name:kGroup_RemoveMemberNotification object:nil];
}

- (void)onJoinedGroup:(NSNotification *)notify
{
    NSArray *users = (NSArray *)notify.object;
    if (!users)
    {
        return;
    }
    
    IMAGroup *group = (IMAGroup *)_user;
    
    NSArray *section0 = [_dataDictionary objectForKey:@(0)];
    RichCellMenuItem *gmc = [section0 objectAtIndex:0];
    gmc.value = [NSString stringWithFormat:@"%d人", (int)[group memberCount]  + (uint32_t)users.count];
    
    [self.tableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
}

- (void)onRemoveGroup:(NSNotification *)notify
{
    IMAUser *removeUser = (IMAUser *)notify.object;
    if (!removeUser)
    {
        return;
    }
    
    IMAGroup *group = (IMAGroup *)_user;
    
    NSArray *section0 = [_dataDictionary objectForKey:@(0)];
    RichCellMenuItem *gmc = [section0 objectAtIndex:0];
    gmc.value = [NSString stringWithFormat:@"%d人", (int)[group memberCount] - 1 ];
    
    [self.tableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
}

- (void)configOwnViews
{
    [self addNotification];
    
    _dataDictionary = [NSMutableDictionary dictionary];
    
    IMAGroup *group = (IMAGroup *)_user;
    
    __weak ChatGroupProfileViewController *ws = self;
    
    
    RichCellMenuItem *gmc = [[RichCellMenuItem alloc] initWith:@"讨论成员" value:[NSString stringWithFormat:@"%d人", (int)[group memberCount]] type:ERichCell_Member action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onSkipGroupMemberList:menu cell:cell];
    }];
    
    // TODO:设置成员数量
    RichMemersMenuItem *gmcPanel = [[RichMemersMenuItem alloc] initWith:nil value:nil type:ERichCell_MemberPanel action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onSkipGroupMemberList:menu cell:cell];
    }];
    gmcPanel.members = [NSMutableArray array];
    [self loadMember:gmcPanel.members];
    
    [_dataDictionary setObject:@[gmc, gmcPanel] forKey:@(0)];
    
    RichCellMenuItem *chatId = [[RichCellMenuItem alloc] initWith:@"讨论组ID" value:[group userId] type:ERichCell_Text action:nil];
    
    RichCellMenuItem *gName = [[RichCellMenuItem alloc] initWith:@"讨论组名称" value:[group showTitle] type:ERichCell_TextNext action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onEditRemark:menu cell:cell];
    }];
    
    RichCellMenuItem *msgNotify = [[RichCellMenuItem alloc] initWith:@"消息提醒" value:[group receiveMessageOpt] type:ERichCell_TextNext action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        // TODO：设置消息提醒
        [ws onEditRecvMsgOption:menu cell:cell];
    }];
    
    [_dataDictionary setObject:@[chatId, gName, msgNotify] forKey:@(1)];
}

- (void)loadMember:(NSMutableArray *)members
{
    __weak ChatGroupProfileViewController * ws = self;
    IMAGroup *group = (IMAGroup *)_user;
    __weak NSMutableArray *wm = members;
    [group asyncMembersV2Of:_pageItem succ:^(uint64_t nextSeq, NSArray *admins, NSArray *otherMembers) {
        [ws addToMemberDic:admins others:otherMembers targetArray:wm];
        [ws reloadData];
    } fail:^(int code, NSString *msg) {
        DebugLog(@"获取群成员失败。code=%d,err=%@",code,msg);
    }];
}

- (void)addToMemberDic:(NSArray *)admins others:(NSArray *)otherMembers targetArray:(NSMutableArray *)members
{
    [members addObjectsFromArray:admins];
    [members addObjectsFromArray:otherMembers];
}

- (void)onChangeReceiveMessageOptionTo:(TIMGroupReceiveMessageOpt)opt
{
    __weak ChatGroupProfileViewController *ws = self;
    IMAGroup *group = (IMAGroup *)_user;
    [group asyncModifyReciveMessageOption:opt succ:^{
        group.groupInfo.selfInfo.recvOpt = opt;
        
        RichCellMenuItem *item = [ws getItemWithKey:@"消息提醒"];
        if (item)
        {
            item.value = [group getReceiveMessageTip:opt];
            NSIndexPath *index = [ws getIndexOfKey:@"消息提醒"];
            if (index)
            {
                [ws.tableView beginUpdates];
                [ws.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
                [ws.tableView endUpdates];
            }
        }
        
        
    } fail:nil];
}

- (void)onChangeGroupAddOptTo:(TIMGroupAddOpt)opt
{
    __weak ChatGroupProfileViewController *ws = self;
    IMAGroup *group = (IMAGroup *)_user;
    
    [group asyncModifyGroupAddOpt:opt succ:^{
        group.groupInfo.addOpt = opt;
        RichCellMenuItem *item = [ws getItemWithKey:@"加群验证"];
        if (item)
        {
            item.value = [group getGroupAddOptTip:opt];
            NSIndexPath *index = [ws getIndexOfKey:@"加群验证"];
            if (index)
            {
                [ws.tableView beginUpdates];
                [ws.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
                [ws.tableView endUpdates];
            }
        }
    } fail:nil];
}

- (void)onEditRecvMsgOption:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    NSDictionary *dic = [IMAGroup groupReceiveMessageTips];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    
    __weak ChatGroupProfileViewController *ws = self;
    NSArray *array = [dic allKeys];
    for (NSString *key in array)
    {
        [sheet bk_addButtonWithTitle:key handler:^{
            TIMGroupReceiveMessageOpt type = (TIMGroupReceiveMessageOpt)[(NSNumber *)[dic valueForKey:key] integerValue];
            [ws onChangeReceiveMessageOptionTo:type];
        }];
    }
    
    [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [sheet showInView:self.view];
}

- (void)onEditGroupAddOpt:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    NSDictionary *dic = [IMAGroup groupAddOptTips];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    
    __weak ChatGroupProfileViewController *ws = self;
    NSArray *array = [dic allKeys];
    for (NSString *key in array)
    {
        [sheet bk_addButtonWithTitle:key handler:^{
            TIMGroupAddOpt type = (TIMGroupAddOpt)[(NSNumber *)[dic valueForKey:key] integerValue];
            [ws onChangeGroupAddOptTo:type];
        }];
    }
    
    [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [sheet showInView:self.view];
}

- (void)onEditRemark:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak IMAGroup *wg = (IMAGroup *)_user;
    __weak ChatGroupProfileViewController *ws = self;
    EditInfoViewController *vc = [[EditInfoViewController alloc] initWith:@"修改讨论组名" text:menu.value completion:^(EditInfoViewController *selfPtr, BOOL isFinished) {
        if (isFinished)
        {
            NSString *editText = selfPtr.editText;
            [wg asyncModifyGroupName:editText succ:^{
                // TODO：网络更新讨论组名
                [wg setRemark:editText];
                menu.value = editText;
                [(RichMenuTableViewCell *)cell configWith:menu];
                ws.title = [NSString stringWithFormat:@"%@的资料", [wg showTitle]];
            } fail:nil];
        }
    }];
    [[AppDelegate sharedAppDelegate] presentViewController:vc animated:YES completion:nil];
}

- (void)onSkipGroupMemberList:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    ChatGroupMemberListViewController *vc = [[ChatGroupMemberListViewController alloc] initWith:(IMAGroup *)_user];
    [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
}

- (void)inviteJoin:(NSArray *)array
{
    IMAGroup *group = (IMAGroup *)_user;
    [group asyncInviteMembers:array succ:^(NSArray *members) {
        [[HUDHelper sharedInstance] tipMessage:@"邀请成功"];
    } fail:nil];
}

- (BOOL)isCanInvite
{
    IMAGroup *group = (IMAGroup *)_user;
    return ![group isChatRoom] && ![group isPublicGroup];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForItem:(RichCellMenuItem *)item
{
    NSString *reuse = [RichCellMenuItem reuseIndentifierOf:item.type];
    if (item.type == ERichCell_MemberPanel)
    {
        RichMemerPanelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell)
        {
            cell = [[RichMemerPanelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse hasAdd:[self isCanInvite]];
        }
        
        [cell configGroup:(IMAGroup *)_user];
        [cell configWith:item];
        return cell;
    }
    else
    {
        RichMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell)
        {
            cell = [[RichMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell configWith:item];
        return cell;
    }
}

@end
