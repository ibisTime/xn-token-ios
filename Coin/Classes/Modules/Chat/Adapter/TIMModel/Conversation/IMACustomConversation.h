//
//  IMACustomConversation.h
//  TIMChat
//
//  Created by AlexiChen on 16/4/7.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAConversation.h"

typedef  void (^SaveMsgSucc)(int newUnRead);

// 此类会话会在初始化的时候设置好imaType
@interface IMACustomConversation : IMAConversation

@property (nonatomic, assign) NSInteger unReadMsgCount;

+ (NSString *)getCustomConversationID:(IMAMsg *)msg;

- (instancetype)initWith:(TIMConversation *)conv andMsg:(IMAMsg *)msg;

- (void)saveMessage:(IMAMsg *)msg succ:(SaveMsgSucc)succ;



@end
