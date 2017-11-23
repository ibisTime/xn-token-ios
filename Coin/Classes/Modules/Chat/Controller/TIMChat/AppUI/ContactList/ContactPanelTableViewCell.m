//
//  ContactPanelTableViewCell.m
//  TIMChat
//
//  Created by AlexiChen on 16/2/18.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ContactPanelTableViewCell.h"

@implementation ContactPanelTableViewCell

- (void)dealloc
{
    [self.KVOController unobserveAll];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addOwnViews];
        [self configOwnViews];
    }
    return self;
}

- (void)addOwnViews
{
    _newFriendBtn = [[ImageTitleButton alloc] initWithStyle:EImageTopTitleBottom];
    [_newFriendBtn setTitle:@"新朋友" forState:UIControlStateNormal];
    [_newFriendBtn.titleLabel setFont:kAppMiddleTextFont];
    _newFriendBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_newFriendBtn setImage:kIconNewFriend forState:UIControlStateNormal];
    [_newFriendBtn addTarget:self action:@selector(onNewFriend) forControlEvents:UIControlEventTouchUpInside];
    _newFriendBtn.margin = UIEdgeInsetsMake(kDefaultMargin, 0, kDefaultMargin, 0);
    [self.contentView addSubview:_newFriendBtn];
    
    _publicGroupBtn = [[ImageTitleButton alloc] initWithStyle:EImageTopTitleBottom];
    [_publicGroupBtn setTitle:@"公开群" forState:UIControlStateNormal];
    [_publicGroupBtn.titleLabel setFont:kAppMiddleTextFont];
    _publicGroupBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_publicGroupBtn setImage:kIconPublicGroup forState:UIControlStateNormal];
    _publicGroupBtn.margin = UIEdgeInsetsMake(kDefaultMargin, 0, kDefaultMargin, 0);
    [_publicGroupBtn addTarget:self action:@selector(onPublicGroup) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_publicGroupBtn];
    
    _chatGroupBtn = [[ImageTitleButton alloc] initWithStyle:EImageTopTitleBottom];
    [_chatGroupBtn setTitle:@"讨论组" forState:UIControlStateNormal];
    [_chatGroupBtn.titleLabel setFont:kAppMiddleTextFont];
    _chatGroupBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_chatGroupBtn setImage:kIconPrivateGroup forState:UIControlStateNormal];
    _chatGroupBtn.margin = UIEdgeInsetsMake(kDefaultMargin, 0, kDefaultMargin, 0);
    [_chatGroupBtn addTarget:self action:@selector(onChatGroup) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_chatGroupBtn];
    
    _chatRoomBtn = [[ImageTitleButton alloc] initWithStyle:EImageTopTitleBottom];
    [_chatRoomBtn setTitle:@"聊天室" forState:UIControlStateNormal];
    [_chatRoomBtn.titleLabel setFont:kAppMiddleTextFont];
    _chatRoomBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_chatRoomBtn setImage:kIconChatroom forState:UIControlStateNormal];
    _chatRoomBtn.margin = UIEdgeInsetsMake(kDefaultMargin, 0, kDefaultMargin, 0);
    [_chatRoomBtn addTarget:self action:@selector(onChatRoom) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_chatRoomBtn];
    
    TIMFriendFutureMeta *meta = [[TIMFriendFutureMeta alloc] init];
    meta.reqNum = 30;
    [[IMAPlatform sharedInstance] asyncGetAllFutureFriends:0XFF meta:meta succ:^(TIMFriendFutureMeta *meta, NSArray *items) {
        [IMAPlatform sharedInstance].contactMgr.hasNewDependency = items.count > 0;
    } fail:nil];
}

- (void)configOwnViews
{
    // 初始化控件的值
    self.KVOController = [FBKVOController controllerWithObserver:self];
    
    __weak ContactPanelTableViewCell *ws = self;
    [self.KVOController observe:[IMAPlatform sharedInstance].contactMgr keyPath:@"hasNewDependency" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [ws onHasNewFriendInfo];
    }];
    
    
    [self onHasNewFriendInfo];
    
}

- (void)onHasNewFriendInfo
{
    
   JSCustomBadge *badge = (JSCustomBadge *)[_newFriendBtn.imageView viewWithTag:1000];
    if (!badge)
    {
        badge = [JSCustomBadge customBadgeWithString:@""];
        badge.hidden = YES;
        badge.userInteractionEnabled = YES;
        badge.tag = 1000;
        [_newFriendBtn.imageView addSubview:badge];
        _newFriendBtn.imageView.clipsToBounds = NO;
        badge.bounds = CGRectMake(0, 0, kDefaultMargin, kDefaultMargin);
    }
    badge.hidden = ![IMAPlatform sharedInstance].contactMgr.hasNewDependency;
}

- (void)onPublicGroup
{
    PublicGroupViewController *vc = [[PublicGroupViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
}

- (void)onChatGroup
{
    ChatGroupViewController *vc = [[ChatGroupViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
}

- (void)onChatRoom
{
    ChatRoomViewController *vc = [[ChatRoomViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
}

- (void)onNewFriend
{
    [IMAPlatform sharedInstance].contactMgr.hasNewDependency = NO;
    FutureFriendsViewController *vc = [[FutureFriendsViewController alloc] init:NO];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.contentView.bounds;
    [self.contentView alignSubviews:@[_newFriendBtn, _publicGroupBtn, _chatGroupBtn, _chatRoomBtn] horizontallyWithPadding:0 margin:0 inRect:rect];
    
    JSCustomBadge *badge = (JSCustomBadge *)[_newFriendBtn.imageView viewWithTag:1000];
    badge.center = CGPointMake(_newFriendBtn.imageView.bounds.origin.x + _newFriendBtn.imageView.bounds.size.width - 4, 5);
}



@end
