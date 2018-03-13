//
//  IMAGroup+Profile.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/25.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAGroup.h"

// 群资料相关的API

@interface IMAGroup (Profile)

+ (NSDictionary *)groupAddOptTips;

+ (NSDictionary *)groupReceiveMessageTips;

- (NSString *)getGroupAddOptTip:(TIMGroupAddOpt)opt;

- (NSString *)getReceiveMessageTip:(TIMGroupReceiveMessageOpt)opt;

- (void)asyncModifyGroupName:(NSString *)name succ:(TIMSucc)succ fail:(TIMFail)fail;
- (void)asyncModifyGroupNameCard:(NSString *)name user:(NSString *)userId succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)asyncModifyGroupIntroduction:(NSString *)name succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)asyncModifyGroupNotify:(NSString *)name succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)asyncExitGroupSucc:(TIMSucc)succ fail:(TIMFail)fail;

- (void)asyncModifyReciveMessageOption:(TIMGroupReceiveMessageOpt)opt succ:(TIMSucc)succ fail:(TIMFail)fail;
- (void)asyncModifyReciveMessage:(BOOL)receive succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)asyncJoinGroup:(NSString*)msg succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)asyncUpdateGroupInfo:(TIMSucc)succ fail:(TIMFail)fail;

- (void)asyncModifyGroupAddOpt:(TIMGroupAddOpt)opt succ:(TIMSucc)succ fail:(TIMFail)fail;

@end
