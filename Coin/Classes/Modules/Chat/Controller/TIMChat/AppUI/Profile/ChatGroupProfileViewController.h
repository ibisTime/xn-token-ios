//
//  ChatGroupProfileViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/4.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "UserProfileViewController.h"

#import "RichCellMenuItem.h"

@interface ChatGroupProfileViewController : UserProfileViewController

- (void)onEditRecvMsgOption:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell;

- (void)loadMember:(NSMutableArray *)members;

- (void)addToMemberDic:(NSArray *)admins others:(NSArray *)otherMembers targetArray:(NSMutableArray *)members;

- (void)onEditGroupAddOpt:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell;


@end
