//
//  ChatRoomProfileViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/25.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatRoomProfileViewController.h"

@implementation ChatRoomProfileViewController

- (void)onSkipGroupMemberList:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    ChatRoomMemberListViewController *vc = [[ChatRoomMemberListViewController alloc] initWith:(IMAGroup *)_user];
    [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
}


//- (NSString *)exitGroupTitle
//{
//    IMAGroup *group = [[IMAGroup alloc] initWith:_user.userId];
//    
//    if ([group isCreatedByMe])
//    {
//        return @"解散该聊天室";
//    }
//    return @"退出该聊天室";
//}

@end
