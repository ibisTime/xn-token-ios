//
//  IMACustomConversation.m
//  TIMChat
//
//  Created by AlexiChen on 16/4/7.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMACustomConversation.h"

@implementation IMACustomConversation

+ (NSString *)getCustomConversationID:(IMAMsg *)msg
{
    NSString *receiver = nil;
    if (msg.type == EIMAMSG_SNSSystem)
    {
        // 新朋友消息
        receiver = [NSString stringWithFormat:@"新朋友"];
    }
    else if (msg.type == EIMAMSG_GroupSystem)
    {
        // 群消息
        receiver = [NSString stringWithFormat:@"群系统消息"];
    }
    return receiver;
}


+ (IMAConType)getTypOfSystemConversation:(TIMConversation *)conv
{
    NSString *receiver = [conv getReceiver];
    IMAConType type = IMA_Unknow;
    if ([receiver isEqualToString:@"新朋友"])
    {
        type = IMA_Sys_NewFriend;
    }
    else if ([receiver isEqualToString:@"群系统消息"])
    {
        type = IMA_Sys_GroupTip;
    }
    return type;
}

- (instancetype)initWith:(TIMConversation *)conv
{

    IMAConType type = [IMACustomConversation getTypOfSystemConversation:conv];
    
    if (type == IMA_Unknow)
    {
        return nil;
    }
    
    if (self = [super initWith:conv])
    {
        _imaConType = type;
    }
    return self;
}

- (instancetype)initWith:(TIMConversation *)conv andMsg:(IMAMsg *)msg
{
    IMAConType type = [IMACustomConversation getTypOfSystemConversation:conv];
    if (type == IMA_Unknow)
    {
        return nil;
    }
    if (self = [super initWith:conv])
    {
        _imaConType = type;
    }
    return self;
}

- (void)saveMessage:(IMAMsg *)msg succ:(SaveMsgSucc)succ
{
    __weak IMACustomConversation *ws = self;
    __weak TIMConversation *wc = _conversation;
    
    if (_imaConType == IMA_Sys_NewFriend)
    {
        TIMFriendFutureMeta *meta = [[TIMFriendFutureMeta alloc] init];
        meta.reqNum = 30;
        meta.timestamp = 0;
        [[IMAPlatform sharedInstance] asyncGetAllFriendPendency:meta succ:^(TIMFriendFutureMeta *meta, NSArray *items) {
            NSInteger curUnRead = ws.unReadMsgCount;
            NSInteger realUnRead = meta.pendencyUnReadCnt;
            
            if (curUnRead != realUnRead)
            {
                [wc saveMessage:msg.msg sender:[msg.msg sender] isReaded:NO];
                ws.unReadMsgCount = realUnRead;
                ws.lastMessage = msg;
            }
            
            if (succ)
            {
                succ((int)(realUnRead-curUnRead));
            }
        } fail:nil];
    }
    
    if (_imaConType == IMA_Sys_GroupTip)
    {
        [[IMAPlatform sharedInstance].contactMgr asyncGetGroupPendencyList:^(TIMGroupPendencyMeta *meta, NSArray *pendencies) {
            NSInteger curUnRead = ws.unReadMsgCount;
            NSInteger realUnRead = meta.unReadCnt;
            
            if (curUnRead != realUnRead)
            {
                [wc saveMessage:msg.msg sender:[msg.msg sender] isReaded:NO];
                ws.unReadMsgCount = realUnRead;
                ws.lastMessage = msg;
            }
            
            if (succ)
            {
                succ((int)(realUnRead-curUnRead));
            }
        } fail:nil];
    }
}

- (IMAConType)imaType
{
    return _imaConType;
}

- (BOOL)isEqualTo:(IMAConversation *)conv
{
    return ([self imaType] == [conv imaType]) && ([[self receiver] isEqualToString:[conv receiver]]);
}

- (void)setReadAllMsg
{
    
//2.0之前的版本不支持 getConversationList 接口
    NSArray *conversationList = [[TIMManager sharedInstance] getConversationList];
    
    for (TIMConversation * conversation in conversationList)
    {
        if ([conversation getType] == TIM_SYSTEM)
        {
            if (_imaConType == [IMACustomConversation getTypOfSystemConversation:conversation])
            {
                [conversation setReadMessage:nil succ:nil fail:nil];
            }
        }
    }
    
    [_conversation setReadMessage:nil succ:nil fail:nil];
    
    [IMAPlatform sharedInstance].conversationMgr.unReadMessageCount -= self.unReadMsgCount;
    
    self.unReadMsgCount = 0;

}

- (NSInteger)unReadCount
{
    return self.unReadMsgCount;
}

@end
