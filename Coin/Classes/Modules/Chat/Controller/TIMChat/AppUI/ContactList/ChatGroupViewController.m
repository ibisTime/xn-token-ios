
//
//  ChatGroupViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/1.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatGroupViewController.h"

@implementation ChatGroupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRightItem];
}

- (void)addHeaderView
{
    
}

- (void)addFooterView
{
    
}

- (void)configOwnViews
{
    _datas = [[IMAPlatform sharedInstance].contactMgr chatGroup];
}

- (void)addRightItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(onClickRightItem)];
    self.title = @"讨论组";
}

- (void)onClickRightItem
{
    NewChatGroupViewController *vc = [[NewChatGroupViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
}

- (void)addSearchController
{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
    if (!cell)
    {
        cell = [[GroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GroupCell"];
    }
    
    id<IMAGroupShowAble> chat = [_datas objectAtIndex:indexPath.row];
    [cell configWith:chat];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMAUser *group = [_datas objectAtIndex:indexPath.row];
    [[AppDelegate sharedAppDelegate] pushToChatViewControllerWith:group];
}


@end
