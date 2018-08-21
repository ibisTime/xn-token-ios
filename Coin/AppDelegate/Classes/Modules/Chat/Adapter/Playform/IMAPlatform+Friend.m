//
//  IMAPlatform+Friend.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/7.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAPlatform+Friend.h"

// 当前好友相关的逻辑
@implementation IMAPlatform (Friend)


- (void)asyncDeleteFriend:(IMAUser *)user succ:(TIMFriendSucc)succ fail:(TIMFail)fail
{
    if (user)
    {
        NSString *uid = [user userId];
        [[TIMFriendshipManager sharedInstance] delFriend:TIM_FRIEND_DEL_BOTH users:@[uid] succ:^(NSArray *array) {
            
            // 从本地好友中找到该人，并删除
            // 只会返回一个
            for (TIMFriendResult *res in array)
            {
                IMAUser *temp = [[IMAUser alloc] initWith:res.identifier];
                [self.contactMgr removeUser:temp];
            }
        
            if (succ)
            {
                succ(array);
            }
        } fail:fail];
        
        
    }
}

@end
