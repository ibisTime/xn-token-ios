//
//  UserProfileViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

- (instancetype)initWith:(IMAUser *)user
{
    if (self = [super init])
    {
        _user = user;
        self.title = [NSString stringWithFormat:@"%@的资料", [user showTitle]];
    }
    return self;
}

- (void)addHeaderView
{
    // do nothing
    UserProfileHeaderView *view = [[UserProfileHeaderView alloc] initWith:_user];
    [view setFrameAndLayout:CGRectMake(0, 0, self.view.bounds.size.width, 160)];
    _tableView.tableHeaderView = view;
    _tableHeader = view;
    
}

- (void)addFooterView
{
    // do nothing
    
//    __weak IMAUser *wi = _user;
//    
//    UserActionItem *delFriend = [[UserActionItem alloc] initWithTitle:@"删除好友" icon:nil action:^(id<MenuAbleItem> menu) {
//        UserProfileViewController *vc = [[UserProfileViewController alloc] initWith:wi];
//        [[AppDelegate sharedAppDelegate] pushViewController:vc];
//    }];
//    
//    
//    
//    UserActionItem *sendMsg = [[UserActionItem alloc] initWithTitle:@"发送消息" icon:nil action:^(id<MenuAbleItem> menu) {
//        
//    }];
//    
//    UserProfileFooterPanel *footer = [[UserProfileFooterPanel alloc] initWith:@[delFriend, sendMsg]];
//    [_tableFooter setFrameAndLayout:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
//    _tableFooter = footer;
}



@end
