//
//  FutureFriendsViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/23.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TableRefreshViewController.h"


@interface FutureFriendsTableViewCell : FriendNotifyTableViewCell
{
@protected
    __weak TIMFriendFutureItem *_item;
}


- (void)configWith:(TIMFriendFutureItem *)item;



@end

@interface FutureFriendsViewController : TableRefreshViewController
{
@protected
    TIMFriendFutureMeta *_requestItem;
    
    BOOL _isNewFriend;//会话列表中点击新朋友时传入true
}

- (instancetype)init:(BOOL)isNewFriend;

@end

