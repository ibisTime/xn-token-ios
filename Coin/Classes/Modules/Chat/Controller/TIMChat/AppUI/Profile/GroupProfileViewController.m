//
//  GroupProfileViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/2/23.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "GroupProfileViewController.h"

#import "IMAGroup+MemberList.h"

@implementation GroupProfileViewController

- (void)onExitGroup
{
    IMAGroup *group = (IMAGroup *)_user;
    [group asyncExitGroupSucc:^{
        [[AppDelegate sharedAppDelegate] popToRootViewController];
    } fail:nil];
}

- (NSString *)exitGroupTitle
{
    IMAGroup *group = (IMAGroup *)_user;
    BOOL canEditByMe = [group isCreatedByMe];
    return canEditByMe ? @"解散该群组" : @"退出该群组";
}

- (void)addFooterView
{
    __weak GroupProfileViewController *ws = self;
    UserActionItem *exitGroup = [[UserActionItem alloc] initWithTitle:[self exitGroupTitle] icon:nil action:^(id<MenuAbleItem> menu) {
        [ws onExitGroup];
    }];
    exitGroup.normalBack = [UIImage imageWithColor:kRedColor size:CGSizeMake(32, 32)];
    
    UserProfileFooterPanel *footer = [[UserProfileFooterPanel alloc] initWith:@[exitGroup]];
    [footer setFrameAndLayout:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    _tableFooter = footer;
    _tableView.tableFooterView = _tableFooter;
}


- (void)configOwnViews
{
    _dataDictionary = [NSMutableDictionary dictionary];
    
    IMAGroup *group = (IMAGroup *)_user;
    
    BOOL canEditByMe = [group isCreatedByMe] || [group isManagedByMe];
    
    __weak GroupProfileViewController *ws = self;
    
    RichCellMenuItem *gmc = [[RichCellMenuItem alloc] initWith:@"群成员" value:[NSString stringWithFormat:@"%d人", (int)[group memberCount]] type:ERichCell_Member action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onSkipGroupMemberList:menu cell:cell];
    }];
    
    RichMemersMenuItem *gmcPanel = [[RichMemersMenuItem alloc] initWith:nil value:nil type:ERichCell_MemberPanel action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onSkipGroupMemberList:menu cell:cell];
    }];
    gmcPanel.members = [NSMutableArray array];
    [self loadMember:gmcPanel.members];
    [_dataDictionary setObject:@[gmc, gmcPanel] forKey:@(0)];
    
    RichCellMenuItem *chatId = [[RichCellMenuItem alloc] initWith:@"群组ID" value:[group userId] type:ERichCell_Text action:nil];
    
    RichCellMenuItem *gName = [[RichCellMenuItem alloc] initWith:@"群名称" value:[group showTitle] type:canEditByMe ? ERichCell_TextNext : ERichCell_Text action:canEditByMe ? ^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onEditRemark:menu cell:cell];
    } : nil];
    
    RichCellMenuItem *gintro = [[RichCellMenuItem alloc] initWith:@"群介绍" value:[group.groupInfo introduction] type:canEditByMe ? ERichCell_RichTextNext : ERichCell_RichText  action:canEditByMe ? ^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onEditIntroduction:menu cell:cell];
    } : nil];
    
    RichCellMenuItem *namecard = [[RichCellMenuItem alloc] initWith:@"我的群名片" value:[group selfNamecard] type:ERichCell_TextNext action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onEditNameCard:menu cell:cell];
    }];
    
    //群主修改群成员的群名片是没有消息通知的。所以需要在每次进入群资料页的时候，重新获取一下群名片，防止群名片被群主改了，但本地没有更新
    [self asyncGetNameCard:namecard];
    
    
    RichCellMenuItem *msgNotify = [[RichCellMenuItem alloc] initWith:@"消息提醒" value:[group receiveMessageOpt] type:ERichCell_TextNext action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        // TODO：设置消息提醒
        [ws onEditRecvMsgOption:menu cell:cell];
    }];
    
    BOOL isModifyGroupVeri = [group isManagedByMe] | [group isCreatedByMe];
    RichCellMenuItem *groupVeri = [[RichCellMenuItem alloc] initWith:@"加群验证" value:[group groupAddOpt] type:isModifyGroupVeri ? ERichCell_TextNext : ERichCell_Text action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        if (isModifyGroupVeri)
        {
            [ws onEditGroupAddOpt:menu cell:cell];
        }
    }];
    
    [_dataDictionary setObject:@[chatId, gName, gintro, namecard, msgNotify, groupVeri] forKey:@(1)];
    
    
    RichCellMenuItem *gnotifu = [[RichCellMenuItem alloc] initWith:@"群公告" value:[group.groupInfo notification] type:canEditByMe ? ERichCell_RichTextNext : ERichCell_RichText action:canEditByMe ? ^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onEditNotify:menu cell:cell];
    } : nil];
    [_dataDictionary setObject:@[gnotifu] forKey:@(2)];
}


- (void)asyncGetNameCard:(RichCellMenuItem *)item
{
    IMAGroup *group = (IMAGroup *)_user;
    __weak GroupProfileViewController *ws = self;
    [[TIMGroupManager sharedInstance] getGroupSelfInfo:group.groupInfo.group succ:^(TIMGroupMemberInfo *selfInfo) {
        [ws modifyNameCard:selfInfo item:item];
    } fail:^(int code, NSString *msg) {
        DebugLog(@"code = %d,msg = %@", code, msg);
    }];
}

- (void)modifyNameCard:(TIMGroupMemberInfo *)selfInfo item:(RichCellMenuItem *)item
{
    IMAGroup *group = (IMAGroup *)_user;
    NSString *curNameCard = [group selfNamecard];
    
    if (![curNameCard isEqualToString:selfInfo.nameCard])
    {
        [group modifySelfGroupNameCard:selfInfo.nameCard];
        item.value = selfInfo.nameCard;
        [self.tableView reloadData];
    }
}

- (void)onEditNotify:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak IMAGroup *wg = (IMAGroup *)_user;
    __weak UITableView *wt = self.tableView;
    EditTextViewController *vc = [[EditTextViewController alloc] initWith:[NSString stringWithFormat:@"修改%@", menu.tip] text:menu.value completion:^(EditInfoViewController *selfPtr, BOOL isFinished) {
        if (isFinished)
        {
            NSString *editText = selfPtr.editText;
            
            [wg asyncModifyGroupNotify:editText succ:^{
                // TODO：网络更新讨论组名
                menu.value = editText;
                [(RichMenuTableViewCell *)cell configWith:menu];
                
                NSIndexPath *index = [wt indexPathForCell:cell];
                
                [wt beginUpdates];
                [wt reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
                [wt endUpdates];
            } fail:nil];
        }
    }];
    [[AppDelegate sharedAppDelegate] presentViewController:vc animated:YES completion:nil];
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



- (void)onEditRemark:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak IMAGroup *wg = (IMAGroup *)_user;
    __weak GroupProfileViewController *ws = self;
    [self onEdit:menu cell:cell action:^(NSString *editText) {
        [wg asyncModifyGroupName:editText succ:^{
            // TODO：网络更新讨论组名
            menu.value = editText;
            [(RichMenuTableViewCell *)cell configWith:menu];
            ws.title = [NSString stringWithFormat:@"%@的资料", [wg showTitle]];
        } fail:nil];
    }];
    
}


- (void)onEditNameCard:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak IMAGroup *wg = (IMAGroup *)_user;
    __weak IMAUser *host = [IMAPlatform sharedInstance].host;
    [self onEdit:menu cell:cell action:^(NSString *editText) {
        [wg asyncModifyGroupNameCard:editText user:[host userId] succ:^{
            // TODO：网络更新讨论组名
            [wg modifySelfGroupNameCard:editText];
            menu.value = editText;
            [(RichMenuTableViewCell *)cell configWith:menu];
        } fail:nil];
    }];
    
}

- (void)onEditIntroduction:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak IMAGroup *wg = (IMAGroup *)_user;
    __weak GroupProfileViewController *ws = self;
    EditTextViewController *vc = [[EditTextViewController alloc] initWith:[NSString stringWithFormat:@"修改%@", menu.tip] text:menu.value completion:^(EditInfoViewController *selfPtr, BOOL isFinished) {
        if (isFinished)
        {
            NSString *editText = selfPtr.editText;
            
            [wg asyncModifyGroupIntroduction:editText succ:^{
                // TODO：网络更新讨论组名
                menu.value = editText;
                
                [(RichMenuTableViewCell *)cell configWith:menu];
                
                NSIndexPath *index = [ws.tableView indexPathForCell:cell];
                
                [ws.tableView beginUpdates];
                [ws.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
                [ws.tableView endUpdates];
                
                ws.title = [NSString stringWithFormat:@"%@的资料", [wg showTitle]];
            } fail:nil];
        }
    }];
    [[AppDelegate sharedAppDelegate] presentViewController:vc animated:YES completion:nil];
    
}

- (void)onSkipGroupMemberList:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    GroupMemberListViewController *vc = [[GroupMemberListViewController alloc] initWith:(IMAGroup *)_user];
    [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 30;
    }
    
    return 5;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        static NSString *headerViewId = @"TextTableViewHeaderFooterView";
        TextTableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
        if (!headerView)
        {
            headerView = [[TextTableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewId];
        }
        
        headerView.tipLabel.text = @"群组成员的变更与管理";
        
        return headerView;
    }
    return nil;
}


@end
