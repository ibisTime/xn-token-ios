//
//  IMAPlatform+Friend.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/7.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAPlatform.h"

@interface IMAPlatform (Friend)

// 删除好友
- (void)asyncDeleteFriend:(IMAUser *)user succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

@end
