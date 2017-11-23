//
//  CustomChatUIViewController.m
//  TIMChat
//
//  Created by wilderliao on 16/6/27.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "CustomChatUIViewController.h"

@interface CustomChatUIViewController ()

@end

@implementation CustomChatUIViewController

//如果要使用自己的输入面板，可以重写这个函数
//- (void)addInputPanel
//{
//}

//添加右上角按钮
- (void)addChatSettingItem
{
    //用户在这里自定义右上角按钮，不实现本函数则右上角没有按钮
    BOOL isUser = [_receiver isC2CType];
    
    UIImage *norimage =  isUser ? [UIImage imageNamed:@"person"] :  [UIImage imageNamed:@"group"];
    UIImage *higimage =  isUser ? [UIImage imageNamed:@"person_hover"] :  [UIImage imageNamed:@"group_hover"];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, norimage.size.width, norimage.size.height)];
    [btn setImage:norimage forState:UIControlStateNormal];
    [btn setImage:higimage forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onClickChatSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = bar;
}

//右上角按钮
- (void)onClickChatSetting
{
    //用户自己实现需要的操作，在demo中，这里是跳转到聊天对象的资料页
    
    //如果是创建群，直接进入聊天界面时，_receiver是临时创建的群，这里需要在ongroupAdd之后，重新获取一次详细群信息
    IMAGroup *group = [[IMAGroup alloc] initWith:_receiver.userId];
    NSInteger index = [[IMAPlatform sharedInstance].contactMgr.groupList indexOfObject:group];
    if (index >= 0 && index < [IMAPlatform sharedInstance].contactMgr.groupList.count)
    {
        _receiver = [[IMAPlatform sharedInstance].contactMgr.groupList objectAtIndex:index];
    }
    
    if ([_receiver isC2CType])
    {
        IMAUser *user = (IMAUser *)_receiver;
        if ([[IMAPlatform sharedInstance].contactMgr isMyFriend:user])
        {
            FriendProfileViewController *vc = [[FriendProfileViewController alloc] initWith:user];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
        else
        {
            StrangerProfileViewController *vc = [[StrangerProfileViewController alloc] initWith:user];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
    }
    else if ([_receiver isGroupType])
    {
        IMAGroup *user = (IMAGroup *)_receiver;
        
        if ([user isPublicGroup])
        {
            
            GroupProfileViewController *vc = [[GroupProfileViewController alloc] initWith:user];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
        else if ([user isChatGroup])
        {
            ChatGroupProfileViewController *vc = [[ChatGroupProfileViewController alloc] initWith:user];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
        else if ([user isChatRoom])
        {
            ChatRoomProfileViewController *vc = [[ChatRoomProfileViewController alloc] initWith:user];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        }
        else
        {
            // do nothing
        }
    }
}
@end
