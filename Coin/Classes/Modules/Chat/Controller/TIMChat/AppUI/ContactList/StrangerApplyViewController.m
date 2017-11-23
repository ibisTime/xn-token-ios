//
//  StrangerApplyViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/23.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "StrangerApplyViewController.h"

@implementation StrangerApplyViewController

- (instancetype)initWith:(TIMFriendFutureItem *)item cell:(FutureFriendsTableViewCell *)cell
{
    if (self = [super init])
    {
        _item = item;
        _cell = cell;
        _user = [[IMAUser alloc] initWithUserInfo:item.profile];
    }
    return self;
}

- (void)addFooterView
{
    __weak StrangerApplyViewController *ws = self;
    
    UserActionItem *refuseApply = [[UserActionItem alloc] initWithTitle:@"拒绝" icon:nil action:^(id<MenuAbleItem> menu) {
        [ws onRefuseApply];
    }];
    refuseApply.normalBack = [UIImage imageWithColor:kRedColor size:CGSizeMake(32, 32)];
    
    UserActionItem *acceptApply = [[UserActionItem alloc] initWithTitle:@"同意" icon:nil action:^(id<MenuAbleItem> menu) {
        [ws onAcceptApply];
    }];
    acceptApply.normalBack = [UIImage imageWithColor:kGreenColor size:CGSizeMake(32, 32)];
    
    UserProfileFooterPanel *footer = [[UserProfileFooterPanel alloc] initWith:@[refuseApply, acceptApply]];
    [footer setFrameAndLayout:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    _tableFooter = footer;
    
    _tableView.tableFooterView = _tableFooter;
}

- (void)configOwnViews
{
    _dataDictionary = [NSMutableDictionary dictionary];
    
    RichCellMenuItem *uid = [[RichCellMenuItem alloc] initWith:@"帐号ID" value:[_user userId] type:ERichCell_Text action:nil];
    
    [_dataDictionary setObject:@[uid] forKey:@(0)];
}

- (void)onAcceptApply
{
    __weak FutureFriendsTableViewCell *wc = _cell;
    __weak TIMFriendFutureItem *wi = _item;
    [[IMAPlatform sharedInstance] asyncApplyAddFutureFriend:_item succ:^(NSArray *friends) {
        wi.type = TIM_FUTURE_FRIEND_DECIDE_TYPE;
        [wc configWith:wi];
        [[AppDelegate sharedAppDelegate] popViewController];
    } fail:nil];
}

- (void)onRefuseApply
{
    __weak StrangerApplyViewController *ws = self;
    __weak TIMFriendFutureItem *wi = _item;
    [[IMAPlatform sharedInstance] asyncRefuseFutureFriend:_item succ:^(NSArray *friends) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNewFriend_RefusedApplayNotification object:wi];
        [ws onDismissSelf];
    } fail:nil];
}

- (void)onDismissSelf
{
    [[AppDelegate sharedAppDelegate] popViewController];
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
                cell.edit.userInteractionEnabled = NO;
                cell.edit.text = _item.addWording;

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
