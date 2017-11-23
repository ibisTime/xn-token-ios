//
//  AddGroupViewController.m
//  TIMChat
//
//  Created by wilderliao on 16/3/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "AddGroupViewController.h"

#import "SearchGroupResultCell.h"

#import "AddGroupProfileViewController.h"

@implementation AddGroupSearchResultViewController

- (void)addNoDataView
{
    [super addNoDataView];
    _noResultTip.text = @"没有查找到对应的群组，请检查输入是否正确";//@"根据群ID或群名称搜索要添加的群组";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    AddFriendPageItem *item = (AddFriendPageItem *)_pageItem;
    if (![item.key isEqualToString:searchBar.text])
    {
        item.key = searchBar.text;
        _pageItem.pageIndex = 0;
        
        __weak AddGroupSearchResultViewController *ws = self;
        [[IMAPlatform sharedInstance] asyncSearchGroupBy:((AddFriendPageItem *)_pageItem).key with:_pageItem succ:^(NSArray *arr) {
            [ws onSearchTextResult:arr];
        } fail:^(int code, NSString *msg) {
            DebugLog(@"code=%d,msg=%@,fun=%s", code, msg,__func__);
            DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, msg,__func__);
            [ws onSearchTextResult:nil];
        }];
    }
}

- (void)onLoadMore
{
    __weak AddGroupSearchResultViewController *ws = self;
    [[IMAPlatform sharedInstance] asyncSearchGroupBy:((AddFriendPageItem *)_pageItem).key with:_pageItem succ:^(NSArray *arr) {
        [ws onSearchTextResult:arr];
    } fail:^(int code, NSString *msg) {
        [ws allLoadingCompleted];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDefaultCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchGroupResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchGroup"];
    if (!cell)
    {
        cell = [[SearchGroupResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchGroup"];
    }
    
    id<IMAGroupShowAble> groupAble = _datas[indexPath.row];
    
    [cell configInfo:groupAble];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TIMGroupInfo *groupInfo = _datas[indexPath.row];
    IMAGroup *group = (IMAGroup *)[[IMAPlatform sharedInstance].contactMgr getUserByGroupId:groupInfo.group];
    if (group)
    {
        if ([group isPublicGroup])
        {
            GroupProfileViewController *vc = [[GroupProfileViewController alloc] initWith:group];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
        else if ([group isChatGroup])
        {
            ChatGroupProfileViewController *vc = [[ChatGroupProfileViewController alloc] initWith:group];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
        else if ([group isChatRoom])
        {
            ChatRoomProfileViewController *vc = [[ChatRoomProfileViewController alloc] initWith:group];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
    }
    else
    {
        IMAGroup *imgroup = [[IMAGroup alloc] initWithInfo:groupInfo];
        AddGroupProfileViewController *vc = [[AddGroupProfileViewController alloc] initWith:imgroup];
        [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
    }
}

@end


@implementation AddGroupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加群组";
}

- (Class)searchResultControllerClass
{
    return [AddGroupSearchResultViewController class];
}

- (void)addSearchController
{
    [super addSearchController];
    if (_searchController)
    {
        _searchController.searchBar.placeholder = @"群ID/群名称";
    }
    if (_searchDisController)
    {
        _searchDisController.searchBar.placeholder = @"群ID/群名称";;
    }
}

@end
