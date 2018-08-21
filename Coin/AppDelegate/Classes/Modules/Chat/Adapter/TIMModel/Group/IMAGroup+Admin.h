//
//  IMAGroup+Admin.h
//  TIMChat
//
//  Created by wilderliao on 16/3/30.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAGroup.h"

// 群管理员相关的操作

@interface IMAGroup (Admin)

- (void)asyncModifyGroupMemberRole:(IMAGroupMember *)member role:(TIMGroupMemberRole)role succ:(TIMSucc)succ fail:(TIMFail)fail;

//stime=0则解除禁言
- (void)asyncModifyGroupMemberInfoSetSilence:(IMAGroupMember *)member stime:(uint32_t)stime succ:(TIMSucc)succ fail:(TIMFail)fail;

@end
