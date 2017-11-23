//
//  SubGroupMgrViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/2/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "SubGroupMgrViewController.h"

@implementation SubGroupMgrViewController

- (void)dealloc
{
    [[IMAPlatform sharedInstance].contactMgr removeContactChangedObser:self];
}

- (void)addHeaderView
{
    
}

- (void)addFooterView
{
    
}

- (void)addIMListener
{
    [[IMAPlatform sharedInstance].contactMgr addContactChangedObserver:self handler:@selector(onSubGroupChanged:) forEvent:EIMAContact_AddNewSubGroup | EIMAContact_DeleteSubGroup];
}

- (void)onSubGroupChanged:(NSNotification *)notify
{
    dispatch_async(dispatch_get_main_queue(), ^{
        IMAContactChangedNotifyItem *item = (IMAContactChangedNotifyItem *)notify.object;
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:1];
        
        [_tableView beginUpdates];
        
        switch (item.type)
        {
            case EIMAContact_AddNewSubGroup:
                [_tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case EIMAContact_DeleteSubGroup:
                [_tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
                break;
            default:
                break;
        }
        [_tableView endUpdates];
    });
    
}

- (void)configOwnViews
{
    NSString * log = [NSString stringWithFormat:@"_subGroups.count = %ld,fun = %s",(long)_subGroups.count, __func__];
    [[TIMManager sharedInstance] log:TIM_LOG_ERROR tag:@"ui crash" msg:log];
    
    _subGroups = [[IMAPlatform sharedInstance].contactMgr subGroupList];
    
    NSString * log1 = [NSString stringWithFormat:@"_subGroups.count = %ld,fun = %s",(long)_subGroups.count, __func__];
    [[TIMManager sharedInstance] log:TIM_LOG_ERROR tag:@"ui crash" msg:log1];
    
    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    self.title = @"分组管理";
    
    
}

- (void)addRefreshScrollView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.frame = self.view.bounds;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = kClearColor;
    _tableView.scrollsToTop = YES;
    [self.view addSubview:_tableView];
    
    self.view.backgroundColor = RGB(240, 240, 240);
    
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.refreshScrollView = _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        NSString * log1 = [NSString stringWithFormat:@"_subGroups.count = %ld,fun = %s",(long)_subGroups.count, __func__];
        [[TIMManager sharedInstance] log:TIM_LOG_ERROR tag:@"ui crash" msg:log1];
        return _subGroups.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddSubGroup"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddSubGroup"];
            cell.textLabel.textColor = RGB(80, 120, 200);
        }
        
        cell.textLabel.text = @"添加分组";
        cell.imageView.image = [UIImage imageNamed:@"addsubgroup"];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubGroup"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddSubGroup"];
            cell.textLabel.textColor = RGB(80, 80, 80);
        }
        id<IMAContactDrawerShowAble> drawe = [_subGroups objectAtIndex:indexPath.row];
        cell.textLabel.text = [drawe showTitle];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self inputNewSubGroupName];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        IMASubGroup *sg = [_subGroups objectAtIndex:indexPath.row];
        
        if (sg.friends.count > 0)
        {
            UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"删除分组后，该分组内的好友自动移动至默认分组" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                [[IMAPlatform sharedInstance].contactMgr asyncDeleteSubGroup:sg succ:nil fail:nil];
            }];
            [alert show];
        }
        else
        {
            [[IMAPlatform sharedInstance].contactMgr asyncDeleteSubGroup:sg succ:nil fail:nil];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UITextField *tf= [alertView textFieldAtIndex:0];
        if (![NSString isEmpty:tf.text])
        {
            if ([tf.text utf8Length] > kSubGroupMaxLength)
            {
                [[HUDHelper sharedInstance] tipMessage:@"分组名超过长度限制(最长30个字符)"];
            }
            else
            {
                [self onInputSubGroupName:tf.text];
            }
        }
        else
        {
            [[HUDHelper sharedInstance] tipMessage:@"分组名不能不空"];
        }
    }
}

- (void)inputNewSubGroupName
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"创建分组" message:@"填写新分组的名字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}


- (void)onInputSubGroupName:(NSString *)sgName
{
    // 检查当前分组名是否与现有的重复
    BOOL isVailedName = [[IMAPlatform sharedInstance].contactMgr isValidSubGroupName:sgName];
    if (!isVailedName || [sgName isEqualToString:@"我的好友"])
    {
        [[HUDHelper sharedInstance] tipMessage:@"该分组名已存在"];
        return;
    }
    
    [[IMAPlatform sharedInstance].contactMgr asyncCreateSubGroup:sgName succ:nil fail:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return NO;
    }
    else
    {
        IMASubGroup *sg = [_subGroups objectAtIndex:indexPath.row];
        return ![sg isDefaultSubGroup];
    }
}

@end
