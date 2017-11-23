//
//  FutureFriendsViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/23.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "FutureFriendsViewController.h"

@implementation FutureFriendsTableViewCell
- (void)onClickAction:(UIButton *)btn
{
    __weak TIMFriendFutureItem *wi = _item;
    __weak FutureFriendsTableViewCell *ws = self;
    [[IMAPlatform sharedInstance] asyncApplyAddFutureFriend:_item succ:^(NSArray *friends) {
        [ws configWith:wi];
    } fail:nil];
}


- (void)configWith:(TIMFriendFutureItem *)item
{
    _item = item;
    
    BOOL isSendByMe = [_item isSendByMe];
    BOOL isDecide = [_item isDecide];
    //    BOOL isPendency = [_item isPendency];
    //    BOOL isRecommend = [_item isRecormend];
    _action.hidden = isSendByMe;
    
    if (isDecide)
    {
        [_action setTitle:@"已添加" forState:UIControlStateNormal];
        [_action setTitleColor:kGrayColor forState:UIControlStateNormal];
        _action.enabled = NO;
        _action.layer.borderWidth = 0;
        _action.layer.borderColor = nil;
        _action.layer.cornerRadius = 0;
        _action.layer.masksToBounds = NO;
    }
    else
    {
        [_action setTitle:@"同意" forState:UIControlStateNormal];
        [_action setTitleColor:kBlueColor forState:UIControlStateNormal];
        _action.enabled = YES;
        _action.layer.borderWidth = 1;
        _action.layer.borderColor = kBlackColor.CGColor;
        _action.layer.cornerRadius = 3;
        _action.layer.masksToBounds = YES;
    }
    
    [_icon sd_setImageWithURL:[item showIconUrl] placeholderImage:kDefaultUserIcon];
    _title.text = [item showTitle];
    _detail.text = [item detaiInfo];
}

@end

@implementation FutureFriendsViewController

- (instancetype)init:(BOOL)isNewFriend
{
    if (self = [super init])
    {
        _isNewFriend = isNewFriend;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新朋友";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMoveRefused:) name:kNewFriend_RefusedApplayNotification object:nil];
}

- (void)addRefreshScrollView
{
    _tableView = [[SwipeDeleteTableView alloc] init];
    _tableView.frame = self.view.bounds;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = kClearColor;
    _tableView.scrollsToTop = YES;
    [self.view addSubview:_tableView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setTableFooterView:v];
    
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.refreshScrollView = _tableView;
}

- (void)configOwnViews
{
    _datas = [NSMutableArray array];
    [self pinHeaderAndRefresh];
}

- (void)onRefresh
{
    __weak FutureFriendsViewController *ws = self;
    
    _requestItem = [[TIMFriendFutureMeta alloc] init];
    _requestItem.reqNum = 30;
    
    if (_isNewFriend)
    {
        [[IMAPlatform sharedInstance] asyncGetAllFriendPendency:_requestItem succ:^(TIMFriendFutureMeta *meta, NSArray *items) {
            [ws onLoadFutureFriends:meta result:items];
            
            uint64_t time = [[NSDate date] timeIntervalSince1970];
            [[IMAPlatform sharedInstance] asyncFriendPendencyReport:time succ:nil fail:nil];
        } fail:^(int code, NSString *msg) {
            [ws allLoadingCompleted];
        }];
    }
    else
    {
        [[IMAPlatform sharedInstance] asyncGetAllFutureFriends:0XFF meta:_requestItem succ:^(TIMFriendFutureMeta *meta, NSArray *items) {
            [ws onLoadFutureFriends:meta result:items];
        } fail:^(int code, NSString *msg) {
            [ws allLoadingCompleted];
        }];
    }
    
}

- (void)onLoadMore
{
    __weak FutureFriendsViewController *ws = self;
    
    if (_isNewFriend)
    {
        [[IMAPlatform sharedInstance] asyncGetAllFriendPendency:_requestItem succ:^(TIMFriendFutureMeta *meta, NSArray *items) {
            [ws onLoadMoreFutureFriends:meta result:items];
        } fail:^(int code, NSString *msg) {
            [ws allLoadingCompleted];
        }];
    }
    else
    {
        [[IMAPlatform sharedInstance] asyncGetAllFutureFriends:0XFF meta:_requestItem succ:^(TIMFriendFutureMeta *meta, NSArray *pendencies) {
            [ws onLoadMoreFutureFriends:meta result:pendencies];
        } fail:^(int code, NSString *msg) {
            [ws allLoadingCompleted];
        }];
    }
}

- (void)onLoadFutureFriends:(TIMFriendFutureMeta *)meta result:(NSArray *)array
{
    [_datas removeAllObjects];
    
    [self onLoadMoreFutureFriends:meta result:array];
}

- (void)onLoadMoreFutureFriends:(TIMFriendFutureMeta *)meta result:(NSArray *)array
{
    if (array.count)
    {
        _requestItem = (TIMFriendFutureMeta *)meta;
        
        [_datas addObjectsFromArray:array];
        
        self.navigationItem.rightBarButtonItem.enabled = [_datas count] > 0;
    }
    else
    {
        if (_datas.count == 0)
        {
            [HUDHelper alert:@"没有新朋友消息" action:^{
                [[AppDelegate sharedAppDelegate] popViewController];
            }];
        }
    }
    self.canLoadMore = array.count > 0;
    [self reloadData];
}


//- (void)onReloadPendency:(TIMFriendPendencyItem *)item
//{
//    [_tableView beginUpdates];
//    NSInteger idx = [_datas indexOfObject:item];
//    NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
//    [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
//    [_tableView endUpdates];
//}

//- (void)onExecuteApply:(TIMFriendPendencyItem *)item
//{
    //    __weak FutureFriendsViewController *ws = self;
    //    [[IMAPlatform sharedInstance] asyncApplyAddFriend:item succ:^(NSArray *friends) {
    //        [ws onReloadPendency:item];
    //    } fail:nil];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FutureFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewFriends"];
    if (!cell)
    {
        cell = [[FutureFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NewFriends"];
    }
    TIMFriendFutureItem *item = _datas[indexPath.row];
    [cell configWith:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TIMFriendFutureItem *item = _datas[indexPath.row];

    if ([item isMyFriend])
    {
        IMAUser *user = [[IMAUser alloc] initWithUserInfo:item.profile];
        FriendProfileViewController *pro = [[FriendProfileViewController alloc] initWith:user];
        [[AppDelegate sharedAppDelegate] pushViewController:pro withBackTitle:@"返回"];
    }
    else if ([item isRecormend])
    {
        // 推荐的好友，点击去添加
        StrangerProfileViewController *vc = [[StrangerProfileViewController alloc] initWith:[[IMAUser alloc] initWithUserInfo:item.profile]];
        vc.title = @"添加好友";
        [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        
    }
    else if ([item isPendency])
    {
        if ([item isSendByMe])
        {
            // 我发给别人的
            StrangerProfileViewController *vc = [[StrangerProfileViewController alloc] initWith:[[IMAUser alloc] initWithUserInfo:item.profile]];
            vc.title = @"添加好友";
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
        else
        {
            // 别人发给我的
            FutureFriendsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            StrangerApplyViewController *vc = [[StrangerApplyViewController alloc] initWith:item cell:cell];
            [[AppDelegate sharedAppDelegate] pushViewController:vc];
        }
    }
    else if ([item isDecide])
    {
        IMAUser *user = [[IMAUser alloc] initWithUserInfo:item.profile];
        if ([[IMAPlatform sharedInstance].contactMgr isContainUser:user])//如果是我的好友
        {
            FriendProfileViewController *vc = [[FriendProfileViewController alloc] initWith:[[IMAUser alloc] initWithUserInfo:item.profile]];
            vc.title = @"好友资料";
            [[AppDelegate sharedAppDelegate] pushViewController:vc];
        }
        else//如果不是我的好友
        {
            StrangerProfileViewController *vc = [[StrangerProfileViewController alloc] initWith:[[IMAUser alloc] initWithUserInfo:item.profile]];
            vc.title = @"好友资料";
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
    }
}

//被拒绝的好友消息，直接从列表中删除
- (void)onMoveRefused:(NSNotification *)notify
{
    TIMFriendFutureItem *item = (TIMFriendFutureItem *)notify.object;
    NSInteger index = [_datas indexOfObject:item];
    
    __weak NSMutableArray *wd = _datas;
    if (index >= 0 && index < _datas.count)
    {
        [_tableView beginUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [wd removeObject:item];
        [_tableView endUpdates];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TIMFriendFutureItem *item = _datas[indexPath.row];
    __weak NSMutableArray *wd = _datas;
    [[IMAPlatform sharedInstance] asyncDeleteFutureFriend:item succ:^(NSArray *friends) {
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [wd removeObject:item];
        [tableView endUpdates];
        
    } fail:nil];
}


@end

