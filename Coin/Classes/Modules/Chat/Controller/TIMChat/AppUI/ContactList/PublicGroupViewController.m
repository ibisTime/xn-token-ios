//
//  PublicGroupViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/1.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "PublicGroupViewController.h"

@implementation PublicGroupViewController

- (void)addRightItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(onClickRightItem)];
    self.title = @"公开群";
}


- (void)onClickRightItem
{
    NewPublicGroupViewController *vc = [[NewPublicGroupViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
}

- (void)configOwnViews
{
    //调试手动设置管理员
//    [[IMAPlatform sharedInstance].groupAssistant ModifyGroupMemberInfoSetRole:@"@TGS#2ZHYURAEJ" user:@"wilderdev0" role:TIM_GROUP_MEMBER_ROLE_ADMIN succ:^{
//        NSLog(@"succ");
//    } fail:^(int code, NSString *msg) {
//        NSLog(@"fail");
//    }];
    
     _groupDictionary = [[IMAPlatform sharedInstance].contactMgr publicGroups];
}

- (void)addSearchController
{
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_groupDictionary count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [_groupDictionary allKeys];
    NSString *key = array[section];
    NSArray *groups = _groupDictionary[key];
    return groups.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerViewId = @"TextTableViewHeaderFooterView";
    TextTableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
    if (!headerView)
    {
        headerView = [[TextTableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewId];
    }
    
    NSArray *array = [_groupDictionary allKeys];
    
    headerView.tipLabel.text = array[section];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
    if (!cell)
    {
        cell = [[GroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GroupCell"];
    }
    
    NSArray *array = [_groupDictionary allKeys];
    NSString *key = array[indexPath.section];
    NSArray *groups = _groupDictionary[key];
    
    id<IMAGroupShowAble> chat = [groups objectAtIndex:indexPath.row];
    [cell configWith:chat];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [_groupDictionary allKeys];
    NSString *key = array[indexPath.section];
    NSArray *groups = _groupDictionary[key];
    
    IMAUser *group = [groups objectAtIndex:indexPath.row];
    [[AppDelegate sharedAppDelegate] pushToChatViewControllerWith:group];
    
}




@end
