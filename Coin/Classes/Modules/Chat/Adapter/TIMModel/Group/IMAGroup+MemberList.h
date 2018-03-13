//
//  IMAGroup+MemberList.h
//  TIMChat
//
//  Created by wilderliao on 16/3/25.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAGroup.h"

// 群成员相关的操作
/**
 *  @param admins 群主、管理员
 *  @param otherMembers 其他成员
 */
typedef void (^TIMGroupMembers)(uint64_t nextSeq, NSArray *admins, NSArray * otherMembers);
typedef void (^TIMGroupMemberInfoSucc)(TIMGroupMemberInfo *info);

@interface IMAGroup (MemberList)

- (void)asyncInviteMembers:(NSArray *)members succ:(TIMGroupMemberSucc)succ fail:(TIMFail)fail;

- (void)asyncMembersV2Of:(RequestPageParamItem *)item succ:(TIMGroupMembers)succ fail:(TIMFail)fail;
- (void)asyncMembersOf:(TIMGroupMemberSucc)succ fail:(TIMFail)fail;


- (void)asyncRemoveMembersOf:(NSArray *)members succ:(TIMGroupMemberSucc)succ fail:(TIMFail)fail;
//- (void)asyncManagersOf:(RequestPageParamItem *)item succ:(TIMGroupMemberSuccV2)succ fail:(TIMFail)fail;
//-(int) DeleteGroupMember:(NSString*)group members:(NSArray*)members succ:(TIMGroupMemberSucc)succ fail:(TIMFail)fail;

- (void)asyncGetGroupMemberInfo:(NSString *)members succ:(TIMGroupMemberInfoSucc)succ fail:(TIMFail)fail;

@end
