//
//  FriendListViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/2/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "FriendListViewController.h"


@implementation FriendListViewController

- (void)addHeaderView
{
    
}

- (void)addFooterView
{
    
}

- (void)configOwnViews
{
    NSString * log1 = [NSString stringWithFormat:@"subGroupList.count = %ld,fun = %s",(long)[[IMAPlatform sharedInstance].contactMgr subGroupList].count, __func__];
    [[TIMManager sharedInstance] log:TIM_LOG_ERROR tag:@"ui crash" msg:log1];
    _contact = [[IMAPlatform sharedInstance].contactMgr subGroupList];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _contact.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
    
}

- (BOOL)isDrawerFolded:(id<IMAContactDrawerShowAble>)drawer
{
    return [drawer isFold];
}

- (NSUInteger)indexOfObject:(id<IMAContactDrawerShowAble>)drawer
{
    return [_contact indexOfObject:drawer];
}

- (void)onTapDrawer:(ContactDrawerView *)drawerView
{
    id<IMAContactDrawerShowAble> drawer = drawerView.drawer;
    BOOL isFold = [self isDrawerFolded:drawer];
    
    
    NSUInteger section = [self indexOfObject:drawer];
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *drawItems = [drawer items];
    
    for (NSInteger i = 0; i < drawItems.count; i++)
    {
        [array addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    [self.tableView beginUpdates];
    if (!isFold)
    {
        // 展开
        [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        // 折叠
        [self.tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView endUpdates];
}

- (ContactDrawerView *)createDrawerWith:(NSString *)reuse
{
    return [[ContactDrawerView alloc] initWithReuseIdentifier:reuse];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerViewId = @"ContactDrawerView";
    ContactDrawerView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
    if (!headerView)
    {
        __weak FriendListViewController *ws = self;
        headerView = [self createDrawerWith:headerViewId];
        headerView.tapDrawerCompletion = ^(ContactDrawerView *drawerView) {
            [ws onTapDrawer:drawerView];
        };
    }
    
    id<IMAContactDrawerShowAble> drawer = [_contact objectAtIndex:section];
    [headerView configWithDrawer:drawer];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<IMAContactDrawerShowAble> drawer = [_contact objectAtIndex:section];
    if ([self isDrawerFolded:drawer])
    {
        return 0;
    }
    else
    {
        return [drawer items].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactItemTableViewCell"];
    if (!cell)
    {
        cell = [[ContactItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactItemTableViewCell"];
    }
    id<IMAContactDrawerShowAble> drawer = [_contact objectAtIndex:indexPath.section];
    id<IMAContactItemShowAble> user = [[drawer items] objectAtIndex:indexPath.row];
    [cell configWithItem:user];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    ContactPickItemTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell onPick];
}



@end



@implementation FriendPickerViewController

- (instancetype)initWithCompletion:(CommonCompletionBlock)completion
{
    return [self initWithCompletion:completion right:@"完成"];
}

- (instancetype)initWithCompletion:(CommonCompletionBlock)completion right:(NSString *)right
{
    if (self = [super init])
    {
        _rightTip = right;
        self.pickCompletion = completion;
        _selectedFriends = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithCompletion:(CommonCompletionBlock)completion existedMembers:(NSMutableArray *)array right:(NSString *)right
{
    if (self = [self initWithCompletion:completion right:right])
    {
        _existedFriends = array;
    }
    return self;
}

- (void)configOwnViews
{
    _contact = [[IMAPlatform sharedInstance].contactMgr clearPickedSubGroupList];
    
    if (_existedFriends)
    {
        for (IMAUser *user in _existedFriends)
        {
            IMAUser *u = [[IMAPlatform sharedInstance].contactMgr isContainUser:user];
            if (u)
            {
                u.isSelected = YES;
            }
        }
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"选择联系人";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_rightTip style:UIBarButtonItemStylePlain target:self action:@selector(onCompletion)];
    
    if (self.navigationController != [[AppDelegate sharedAppDelegate] navigationViewController])
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelPick)];
    }
    
}


- (BOOL)isDrawerFolded:(id<IMAContactDrawerShowAble>)drawer
{
    return [drawer isPicked];
}

- (void)addSearchController
{
    // do nothing
}

- (void)onCancelPick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onCompletion
{
    if (_pickCompletion)
    {
        _pickCompletion(self, YES);
    }
    
    if (self.navigationController == [[AppDelegate sharedAppDelegate] navigationViewController])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (ContactDrawerView *)createDrawerWith:(NSString *)reuse
{
    return [[ContactDrawerView alloc] initWithPickReuseIdentifier:reuse];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactPickItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactItemTableViewCell"];
    if (!cell)
    {
        cell = [[ContactPickItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactItemTableViewCell"];
    }
    id<IMAContactDrawerShowAble> drawer = [_contact objectAtIndex:indexPath.section];
    id<IMAContactItemShowAble> user = [[drawer items] objectAtIndex:indexPath.row];
    [cell configWithItem:user];
    [cell setDelegate:self];
    
    if (_existedFriends)
    {
        // 如果在_existedFriends中，不可点击
        BOOL cont = [_existedFriends containsObject:user];
        cell.pick.enabled = !cont;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    ContactPickItemTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    id<IMAContactItemShowAble> item = [cell item];
    if (_existedFriends)
    {
        BOOL cont = [_existedFriends containsObject:item];
        if (cont)
        {
            // 如果在_existedFriends中，不可点击
            return;
        }
    }

    [cell onPick];
}

- (void)onPickAction:(id<IMAContactItemShowAble>)item
{
    if ([item isSelected])
    {
        [_selectedFriends addObject:item];
    }
    else
    {
        [_selectedFriends removeObject:item];
    }
    NSString *title = _selectedFriends.count > 0 ? [NSString stringWithFormat:@"%@(%d)", _rightTip, (int)_selectedFriends.count] : _rightTip;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(onCompletion)];
    
    [self.navigationItem setRightBarButtonItem:right animated:YES];
}


@end
