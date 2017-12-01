//
//  StrangerProfileViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/4.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "StrangerProfileViewController.h"

@interface StrangerProfileViewController ()

@end

@implementation StrangerProfileViewController

- (void)addFooterView
{
    __weak StrangerProfileViewController *ws = self;
    UserActionItem *addFriend = [[UserActionItem alloc] initWithTitle:@"发送添加好友邀请" icon:nil action:^(id<MenuAbleItem> menu) {
        [ws onSendAddFriensRequest];
    }];
    addFriend.normalBack = [UIImage imageWithColor:RGB(20, 90, 190) size:CGSizeMake(32, 32)];
    
    
    UserProfileFooterPanel *footer = [[UserProfileFooterPanel alloc] initWith:@[addFriend]];
    [footer setFrameAndLayout:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    _tableFooter = footer;
    
    _tableView.tableFooterView = _tableFooter;
}

- (void)onEditRemark:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak IMAUser *wu = _user;
    EditInfoViewController *vc = [[EditInfoViewController alloc] initWith:@"修改备注名" text:menu.value completion:^(EditInfoViewController *selfPtr, BOOL isFinished) {
        if (isFinished)
        {
            NSString *editText = selfPtr.editText;
            [wu setRemark:editText];
            menu.value = editText;
            [(RichMenuTableViewCell *)cell configWith:menu];
        }
    }];
    [[AppDelegate sharedAppDelegate] presentViewController:vc animated:YES completion:nil];
}

- (void)onEditSubGroup:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak StrangerProfileViewController *ws =  self;
    SubGroupPickerViewController *vc = [[SubGroupPickerViewController alloc] initWithCompletion:^(SubGroupPickerViewController *selfPtr, BOOL isFinished) {
        
        ws.selectedSubGroup = selfPtr.selectedSubGroup;
        NSString *group = [selfPtr.selectedSubGroup showTitle];
        menu.value = group;
        [(RichMenuTableViewCell *)cell configWith:menu];
    }];
    vc.selectedSubGroup = _selectedSubGroup;
    [[AppDelegate sharedAppDelegate] presentViewController:vc animated:YES completion:nil];
}


- (void)configOwnViews
{
    _dataDictionary = [NSMutableDictionary dictionary];
    
    __weak StrangerProfileViewController *ws = self;
    RichCellMenuItem *uid = [[RichCellMenuItem alloc] initWith:@"帐号ID" value:[_user userId] type:ERichCell_Text action:nil];
    
    RichCellMenuItem *remark = [[RichCellMenuItem alloc] initWith:@"备注名" value:[_user showTitle] type:ERichCell_TextNext action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onEditRemark:menu cell:cell];
    }];
    
    _selectedSubGroup = [[IMAPlatform sharedInstance].contactMgr defaultAddToSubGroup];
    RichCellMenuItem *sg = [[RichCellMenuItem alloc] initWith:@"分组" value:[_selectedSubGroup showTitle] type:ERichCell_TextNext action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onEditSubGroup:menu cell:cell];
    }];
    
    [_dataDictionary setObject:@[uid, remark, sg] forKey:@(0)];
}

- (void)removeFromBlackListAndSendAddFriend:(NSString *)remark desc:(NSString *)desc
{
    __weak IMAUser *wu = _user;
    __weak IMASubGroup *sg = _selectedSubGroup;
    [[IMAPlatform sharedInstance].contactMgr asyncMoveOutBlackList:_user succ:^(NSArray *friends) {
        [[IMAPlatform sharedInstance] asyncSendAddFriend:wu withRemark:remark applyInfo:desc toSubGroup:sg succ:^(NSArray *friends) {
            if (friends.count > 0)
            {
                [[HUDHelper sharedInstance] tipMessage:@"添加成功" delay:0.5];
            }
            [[AppDelegate sharedAppDelegate] popViewController];
        } fail:nil];
        
    } fail:nil];
}

- (void)onSendAddFriensRequest
{
    RichCellMenuItem *remarkItem = [self getItemWithKey:@"备注名"];
    NSString *remark = remarkItem.value;
    
    TextViewTableViewCell *descCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString *desc = descCell.edit.text;
    
    
    BOOL isInBalckList = [[IMAPlatform sharedInstance].contactMgr isInBlackListByID:[_user userId]];
    if (isInBalckList)
    {
        __weak StrangerProfileViewController *ws = self;
        [HUDHelper alert:@"用户已在黑名单中，确认移除黑名单并添加好友" action:^{
            [ws removeFromBlackListAndSendAddFriend:remark desc:desc];
        }];
        
    }
    else
    {
        [[IMAPlatform sharedInstance] asyncSendAddFriend:_user withRemark:remark applyInfo:desc toSubGroup:_selectedSubGroup succ:^(NSArray *friends) {
            if (friends.count > 0)
            {
                [[HUDHelper sharedInstance] tipMessage:@"添加成功" delay:0.5];
            }
            [[AppDelegate sharedAppDelegate] popViewController];
        } fail:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 1)
    {
        return 30;
    }
    else
    {
        return 5;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        static NSString *headerViewId = @"TextTableViewHeaderFooterView";
        TextTableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
        if (!headerView)
        {
            headerView = [[TextTableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewId];
        }
        
        headerView.tipLabel.text = @"附加信息";
        
        return headerView;
    }
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 1;
    }
    else
    {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return 120;
    }
    else
    {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            return [super tableView:tableView cellForRowAtIndexPath:indexPath];
        }
            break;
        case 1:
        {
            TextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Remark"];
            if (!cell)
            {
                cell = [[TextViewTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Remark"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
#if DEBUG
                cell.edit.text = @"这是一个测试";
#endif
            }
            
            return cell;
        }
            break;
        default:
            return 0;
            break;
    }
    return nil;
}
@end
