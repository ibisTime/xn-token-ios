//
//  IMAConnectConversation.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/28.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAConnectConversation.h"

@implementation IMAConnectConversation

- (instancetype)initWith:(TIMConversation *)conv
{
    return nil;
}


- (void)asyncLoadLocalLastMsg:(CommonVoidBlock)block
{
    // do nothing
}


- (void)releaseConversation
{
    // do nothing
}

- (void)asyncLoadRecentMessage:(NSInteger)count completion:(HandleMsgBlock)block
{
    // do nothing
}


- (void)asyncLoadRecentMessage:(NSInteger)count from:(IMAMsg *)msg completion:(HandleMsgBlock)block
{
    // do nothing
}

- (TIMConversationType)type
{
    // do nothing
    return TIM_SYSTEM;
}

- (NSString *)receiver
{
    return @"-10000";
}

- (BOOL)isChatWith:(IMAUser *)user
{
    return NO;
}

- (NSArray *)sendMessage:(IMAMsg *)msg completion:(HandleMsgCodeBlock)block
{
    return nil;
}

- (NSArray *)appendWillSendMsg:(IMAMsg *)msg completion:(HandleMsgBlock)block
{
    return nil;
}
- (void)replaceWillSendMsg:(IMAMsg *)msg with:(IMAMsg *)newMsg completion:(HandleMsgBlock)block
{
    // do nothing
}
- (NSArray *)removeMsg:(IMAMsg *)msg completion:(RemoveMsgBlock)block
{
    return nil;
}

- (NSArray *)revokeMsg:(IMAMsg *)msg isRemote:(BOOL)isRemote completion:(RemoveMsgBlock)block
{
    return nil;
}

- (void)setReadAllMsg
{
    // do nothing
}


//===========================
// Protected方法
- (void)onReceiveNewMessage:(IMAMsg *)msg
{
    // do nothing
}
- (BOOL)isEqualTo:(IMAConversation *)conv
{
    return [conv isKindOfClass:[IMAConnectConversation class]];
}

- (IMAConType)imaType
{
    return IMA_Connect;
}

@end







