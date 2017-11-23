//
//  StrangerApplyViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/23.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "UserProfileViewController.h"

#import "FutureFriendsViewController.h"

@interface StrangerApplyViewController : UserProfileViewController
{
    TIMFriendFutureItem *_item;
    FutureFriendsTableViewCell *_cell;
}

- (instancetype)initWith:(TIMFriendFutureItem *)item cell:(FutureFriendsTableViewCell *)cell;
@end
