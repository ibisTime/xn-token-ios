//
//  ChatRoomViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/1.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatRoomViewController.h"


@implementation ChatRoomViewController

- (void)addRightItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(onClickRightItem)];
    self.title = @"聊天室";
}

- (void)configOwnViews
{
    _datas = [[IMAPlatform sharedInstance].contactMgr chatRooms];
}


- (void)onClickRightItem
{
    NewChatRoomViewController *vc = [[NewChatRoomViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
}


@end
