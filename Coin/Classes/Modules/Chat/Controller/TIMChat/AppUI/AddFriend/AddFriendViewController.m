//
//  AddFriendViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/2/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "AddFriendViewController.h"


@implementation AddFriendPageItem

@end


@implementation AddFriendSearchResultViewController

- (void)addHeaderView
{
    
}

- (void)configOwnViews
{
    _pageItem = [[AddFriendPageItem alloc] init];
    _datas = [NSMutableArray array];
}

- (void)showNoDataView
{
    [_noResultTip sizeWith:CGSizeMake(_noDataView.bounds.size.width, 60)];
    [_noResultTip alignParentTopWithMargin:40 + 64];
}

- (void)addNoDataView
{
    _noDataView = [[UIView alloc] init];
    _noDataView.backgroundColor = kLightGrayColor;
    [self.view addSubview:_noDataView];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = kLightGrayColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.text = @"没有搜索到对应用户,请检查输入是否正确";//@"根据用户ID或手机号搜索要添加的好友";
    [self.view addSubview:label];
    [_noDataView addSubview:label];
    _noResultTip = label;
    
}


- (void)onSearchTextResult:(NSArray *)data
{
    [_datas removeAllObjects];
    [self onLoadMoreSearchTextResult:data];
}

- (void)onLoadMoreSearchTextResult:(NSArray *)data
{
    [_datas addObjectsFromArray:data];
    self.canLoadMore = _pageItem.canLoadMore;
    [self reloadData];
    
    if (_searchDisController)
    {
        [_searchDisController.searchResultsTableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *string = [[TLSHelper getInstance] getSDKVersion];
    NSLog(@"%@",string);
    [searchBar resignFirstResponder];
    
    AddFriendPageItem *item = (AddFriendPageItem *)_pageItem;
    if (![item.key isEqualToString:searchBar.text])
    {
        item.key = searchBar.text;
        _pageItem.pageIndex = 0;
        
        __weak AddFriendSearchResultViewController *ws = self;
        [[IMAPlatform sharedInstance] asyncSearchUserBy:((AddFriendPageItem *)_pageItem).key with:_pageItem succ:^(NSArray *ul) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws onSearchTextResult:ul];
            });
        } fail:^(int code, NSString *err) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
                [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
                [ws allLoadingCompleted];
            });
        }];
    }
    
}

- (void)onLoadMore
{
    __weak AddFriendSearchResultViewController *ws = self;
    [[IMAPlatform sharedInstance] asyncSearchUserBy:((AddFriendPageItem *)_pageItem).key with:_pageItem succ:^(NSArray *ul) {
        [ws onLoadMoreSearchTextResult:ul];
    } fail:^(int code, NSString *err) {
        DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
        [ws allLoadingCompleted];
    }];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    _searchController = searchController;
    if (searchController.searchResultsController.view.hidden)
    {
        searchController.searchResultsController.view.hidden = NO;
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    DebugLog(@"searchString = %@",searchString);
    _searchDisController = controller;
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchUser"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchUser"];
        cell.imageView.layer.cornerRadius = 16;
        
    }
    
    id<IMAUserShowAble> user = _datas[indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[user showIconUrl] placeholderImage:kDefaultUserIcon];
    cell.textLabel.text = [user showTitle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TIMUserProfile *userProfile = (TIMUserProfile *)_datas[indexPath.row];
    IMAUser *user = [[IMAPlatform sharedInstance].contactMgr getUserByUserId:userProfile.identifier];
    if (user)
    {
        FriendProfileViewController *vc = [[FriendProfileViewController alloc] initWith:user];
        [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];

    }
    else
    {
        IMAUser *temp = [[IMAUser alloc] initWithUserInfo:userProfile];
        if ([[IMAPlatform sharedInstance].host isMe:temp])
        {
            MyProfileViewController *vc = [[MyProfileViewController alloc] initWith:[IMAPlatform sharedInstance].host];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
        else
        {
            StrangerProfileViewController *vc = [[StrangerProfileViewController alloc] initWith:temp];
            vc.title = @"添加好友";
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
        

    }
    
}

@end


@implementation AddFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加好友";
}

- (void)addHeaderView
{

}
- (void)addFooterView
{
    
}
- (Class)searchResultControllerClass
{
    return [AddFriendSearchResultViewController class];
}

- (void)addSearchController
{
    [super addSearchController];
    
    if (_searchController)
    {
        _searchController.searchBar.placeholder = @"用户ID/昵称";
    }
    if (_searchDisController)
    {
        _searchDisController.searchBar.placeholder = @"用户ID/昵称";
    }
}

@end
