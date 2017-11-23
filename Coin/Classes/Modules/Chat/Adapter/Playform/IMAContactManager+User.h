//
//  IMAContactManager+User.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/22.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAContactManager.h"

@interface IMAContactManager (User)

- (void)asyncModify:(IMAUser *)user remark:(NSString *)remark succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)asyncModify:(IMAUser *)user subgroup:(IMASubGroup *)sg succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

- (void)asyncMoveToBlackList:(IMAUser *)user succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

- (void)asyncMoveOutBlackList:(IMAUser *)user succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

@end
