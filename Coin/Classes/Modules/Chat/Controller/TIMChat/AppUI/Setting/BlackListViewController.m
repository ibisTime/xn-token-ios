//
//  BlackListViewController.m
//  TIMChat
//
//  Created by wilderliao on 16/3/31.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "BlackListViewController.h"

@interface BlackListViewController ()

@end

@implementation BlackListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"黑名单";
    
    [self loadBlackList];
}

- (void)loadBlackList
{
    _datas = [NSMutableArray array];
    [_datas addObjectsFromArray:[IMAPlatform sharedInstance].contactMgr.blackList.safeArray];
}

- (void)addIMListener
{
    [[IMAPlatform sharedInstance].contactMgr addContactChangedObserver:self handler:@selector(onBlackListChanged:) forEvent:EIMAContact_BlackListEvents];
}

- (void)onBlackListChanged:(NSNotification *)notify
{
    dispatch_async(dispatch_get_main_queue(), ^{
        IMAContactChangedNotifyItem *item = (IMAContactChangedNotifyItem *) notify.object;
        
        if ([IMAPlatform sharedInstance].contactMgr.blackList.safeArray.count == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [_datas removeAllObjects];
            [_datas addObjectsFromArray:[IMAPlatform sharedInstance].contactMgr.blackList.safeArray];
            [self reloadData];
        }
        
        
    });
    
}


- (void)addHeaderView
{
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    
    headerView.tipLabel.text = [NSString stringWithFormat:@"共 %ld 人",_datas.count];
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactItemTableViewCell"];
    if (!cell)
    {
        cell = [[ContactItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactItemTableViewCell"];
    }
    
//    KeyValue *kv = [self getKeyValue:indexPath.section];
//    if (!kv)
//    {
//        return nil;
//    }
    id<IMAContactItemShowAble> user =  _datas[indexPath.row];
//    NSArray *items = kv.value;
//    id<IMAContactItemShowAble> user = [items objectAtIndex:indexPath.row];
    [cell configWithItem:user];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMAUser *user =  _datas[indexPath.row];
    
    StrangerProfileViewController *vc = [[StrangerProfileViewController alloc] initWith:user];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        IMAUser *user = _datas[indexPath.row];
        __weak IMAUser *wu = user;
        __weak BlackListViewController *ws = self;
        __weak NSMutableArray *wd = _datas;
        
        [[IMAPlatform sharedInstance].contactMgr asyncMoveOutBlackList:wu succ:^(NSArray *friends) {
            [wd removeObject:wu];
            if (wd.count != 0)
            {
                [ws reloadData];
            }
            else
            {
                [ws.navigationController popViewControllerAnimated:YES];
            }
            [[HUDHelper sharedInstance] tipMessage:@"移除黑名单成功"];
        } fail:nil];
    }
}

@end
