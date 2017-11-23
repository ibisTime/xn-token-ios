//
//  ContactController.m
//  TIMChat
//
//  Created by wilderliao on 16/2/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ContactListViewController.h"

@interface ContactListViewController ()

@end

@implementation ContactListViewController


- (void)addIMListener
{
    __weak ContactListViewController *ws = self;
    [IMAPlatform sharedInstance].contactMgr.contactChangedCompletion = ^(IMAContactChangedNotifyItem *item){
        [ws onContactChanged:item];
    };
    
}

- (void)onContactChanged:(IMAContactChangedNotifyItem *)item
{
    switch (item.type)
    {
        case EIMAContact_SubGroupReloadAll:
        {
            [self.tableView reloadData];
        }
            break;
        case EIMAContact_AddNewSubGroup:
        {
            
            [self.tableView beginUpdates];
            NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:item.index + 1];
            [self.tableView insertSections:indexset withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
        }
            break;
        case EIMAContact_DeleteSubGroup:
        {
            
            [self.tableView beginUpdates];
            NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:item.index + 1];
            [self.tableView deleteSections:indexset withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
            break;
        case EIMAContact_AddFriend:
        {
            
            NSInteger section = [_contact indexOfObject:item.subGroup] + 1;
            if (!item.subGroup.isFold)
            {
                [self.tableView beginUpdates];
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:section];
                [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            }
            ContactDrawerView *view = (ContactDrawerView *)[self.tableView headerViewForSection:section];
            [view updateDrawer];
        }
            break;
        case EIMAContact_DeleteFriend:
        {
            
            NSInteger section = [_contact indexOfObject:item.subGroup] + 1;
            if (!item.subGroup.isFold)
            {
                [self.tableView beginUpdates];
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:section];
                [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            }
            ContactDrawerView *view = (ContactDrawerView *)[self.tableView headerViewForSection:section];
            [view updateDrawer];
        }
            break;
        case EIMAContact_LoadDefaultFriends:
        {
            
            [self.tableView beginUpdates];
            NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:item.index + 1];
            [self.tableView insertSections:indexset withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
        }
            break;
        case EIMAContact_FriendInfoChanged:
        {
            
            if (!item.subGroup.isFold)
            {
                [self.tableView beginUpdates];
                
                NSInteger section = [_contact indexOfObject:item.subGroup] + 1;
                NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:section];
                [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
                
                [self.tableView endUpdates];
            }
            
        }
            break;
        case EIMAContact_SubGroupChanged:
        {
            
            NSInteger section = [_contact indexOfObject:item.subGroup] + 1;
            if (!item.subGroup.isFold)
            {
                [self.tableView beginUpdates];
                NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:section];
                [self.tableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            }
            
            ContactDrawerView *view = (ContactDrawerView *)[self.tableView headerViewForSection:section];
            [view updateDrawer];
        }
            break;
            
        case EIMAContact_MoveFriend:
        {
            DebugLog(@"====>onMove UI");
            [self.tableView beginUpdates];
            
            {
                NSInteger section = [_contact indexOfObject:item.subGroup] + 1;
                if (!item.subGroup.isFold)
                {
                    
                    NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:section];
                    [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
                    
                }
                ContactDrawerView *view = (ContactDrawerView *)[self.tableView headerViewForSection:section];
                [view updateDrawer];
            }
            
            {
                NSInteger section = [_contact indexOfObject:item.toItem.subGroup] + 1;
                if (!item.toItem.subGroup.isFold)
                {
                    NSIndexPath *index = [NSIndexPath indexPathForRow:item.toItem.index inSection:section];
                    [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
                }
                ContactDrawerView *view = (ContactDrawerView *)[self.tableView headerViewForSection:section];
                [view updateDrawer];
            }
            
            [self.tableView endUpdates];
            DebugLog(@"====>onMove UI end");
        }
            break;
        default:
            break;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"联系人";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:kIconAdd style:UIBarButtonItemStylePlain target:self action:@selector(onRightItem:)];
}

- (void)onRightItem:(UIBarButtonItem *)baritem
{
    MenuItem *addFriend = [[PopupMenuItem alloc] initWithTitle:@"添加好友" icon:[UIImage imageNamed:@"addfriend"] action:^(id<MenuAbleItem> menu) {
        AddFriendViewController *vc = [[AddFriendViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
    }];
    
    MenuItem *addGroup = [[PopupMenuItem alloc] initWithTitle:@"添加群组" icon:[UIImage imageNamed:@"add_group40"] action:^(id<MenuAbleItem> menu) {
        AddGroupViewController *vc = [[AddGroupViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
    }];
    
    
    MenuItem *subgroupMgr = [[PopupMenuItem alloc] initWithTitle:@"分组管理" icon:[UIImage imageNamed:@"subgroup_mgr"] action:^(id<MenuAbleItem> menu) {
        SubGroupMgrViewController *vc = [[SubGroupMgrViewController alloc] init];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
    }];
    UIView *view = [baritem valueForKey:@"view"];
    CGRect barRect = [view relativePositionTo:self.navigationController.view];
    [PopupMenu showMenuInView:self.navigationController.view fromRect:barRect menuItems:@[addFriend, addGroup, subgroupMgr]];
}

- (void)addSearchController
{
}

- (NSUInteger)indexOfObject:(id<IMAContactDrawerShowAble>)drawer
{
    return [_contact indexOfObject:drawer] + 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + [super numberOfSectionsInTableView:tableView]; // _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else
    {
        return [super tableView:tableView heightForHeaderInSection:section - 1];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    else
    {
        return [super tableView:tableView viewForHeaderInSection:section - 1];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 20;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        // 功能面板
        return 75;
    }
    else
    {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        // 功能面板
        return 1;
    }
    else
    {
        return [super tableView:tableView numberOfRowsInSection:section-1];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ContactPanelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactPanelTableViewCell"];
        if (!cell)
        {
            cell = [[ContactPanelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactPanelTableViewCell"];
        }
        return cell;
    }
    else
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
        return [super tableView:tableView cellForRowAtIndexPath:path];
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 进入C2C聊天界面
    id<IMAContactDrawerShowAble> drawer = [_contact objectAtIndex:indexPath.section-1];
    IMAUser *user = (IMAUser *)[[drawer items] objectAtIndex:indexPath.row];
    
    //跳转到AIO
//    [AppDelegate sharedAppDelegate].isContactListEnterChatViewController = YES;
    
    [[AppDelegate sharedAppDelegate] pushToChatViewControllerWith:user];
}

@end
