//
//  IMAGroup+Admin.m
//  TIMChat
//
//  Created by wilderliao on 16/3/30.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAGroup+Admin.h"

@implementation IMAGroup (Admin)

- (void)asyncModifyGroupMemberRole:(IMAGroupMember *)member role:(TIMGroupMemberRole)role succ:(TIMSucc)succ fail:(TIMFail)fail
{
    if (!member || !member.memberInfo)
    {
        DebugLog(@"参数不正确");
        return ;
    }

    [[TIMGroupManager sharedInstance] modifyGroupMemberInfoSetRole:self.groupInfo.group user:member.memberInfo.member role:role succ:^{
        if (succ)
        {
            succ();
        }
    } fail:^(int code, NSString *msg) {
        DebugLog(@"---修改角色失败code=%d,err=%@---",code,msg);
        [[HUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"---code=%d,err=%@---",code,msg]];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}

- (void)asyncModifyGroupMemberInfoSetSilence:(IMAGroupMember *)member stime:(uint32_t)stime succ:(TIMSucc)succ fail:(TIMFail)fail
{
    if (!member || !member.memberInfo)
    {
        DebugLog(@"参数不正确");
        return ;
    }
    [[TIMGroupManager sharedInstance] modifyGroupMemberInfoSetSilence:self.groupInfo.group user:member.memberInfo.member stime:stime succ:^{
        if (succ)
        {
            succ();
        }
    } fail:^(int code, NSString *msg) {
        DebugLog(@"---禁言失败code=%d,err=%@---",code,msg);
        [[HUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"---code=%d,err=%@---",code,msg]];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}

@end
