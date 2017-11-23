//
//  FriendListViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/2/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TableSearchViewController.h"

#import "ContactItemTableViewCell.h"

@interface FriendListViewController : TableSearchViewController
{
    __weak CLSafeMutableArray *_contact;
}

@end



@interface FriendPickerViewController : FriendListViewController <ContactPickItemTableViewCellDelegate>
{
@protected
    NSString        *_rightTip;
    NSMutableArray  *_selectedFriends;
    
@protected
    NSMutableArray  *_existedFriends;   // 此部份好友默认选中，且不能取消选中
}

@property (nonatomic, readonly) NSArray *selectedFriends;
@property (nonatomic, readonly) NSArray *existedFriends;

@property (nonatomic, copy) CommonCompletionBlock pickCompletion;

- (instancetype)initWithCompletion:(CommonCompletionBlock)completion;
- (instancetype)initWithCompletion:(CommonCompletionBlock)completion right:(NSString *)right;

- (instancetype)initWithCompletion:(CommonCompletionBlock)completion existedMembers:(NSMutableArray *)array right:(NSString *)right;

@end
