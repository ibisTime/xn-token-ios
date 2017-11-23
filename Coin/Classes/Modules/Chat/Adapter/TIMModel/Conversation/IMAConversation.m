//
//  IMAConversation.m
//  TIMAdapter
//
//  Created by AlexiChen on 16/1/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAConversation.h"

@interface IMAConversation ()

@property (nonatomic, strong) TIMConversation *conversation;


@end

@implementation IMAConversation

- (instancetype)initWith:(TIMConversation *)conv
{
    if (self = [super init])
    {
        _conversation = conv;
        _msgList = [[CLSafeMutableArray alloc] init];
        
    }
    return self;
}

- (void)copyConversationInfo:(IMAConversation *)conv
{
    _msgList = conv.msgList;
    _imaConType = [conv imaType];
    _lastMessage = [conv lastMessage];
    _receiveMsg = conv.receiveMsg;
}

- (void)asyncLoadLocalLastMsg:(CommonVoidBlock)block
{
    DebugLog(@"============>>>>>>>>> %@", self);
    
    NSArray *msgs = [_conversation getLastMsgs:20];
    
    for (TIMMessage *msg in msgs)
    {
        if (msg.status != TIM_MSG_STATUS_LOCAL_REVOKED)
        {
            IMAMsg *imamsg = [IMAMsg msgWith:msg];
            
            if (imamsg)
            {
                self.lastMessage = imamsg;
                if (block)
                {
                    block();
                }
                return;
            }
        }
    }
//    __weak IMAConversation *ws = self;
//    [_conversation getMessage:1 last:nil succ:^(NSArray *array) {
//        if (array.count > 0)
//        {
//            TIMMessage *msg = array[0];
//            
//            // TODO：此处有可能是已删掉的信息
//            
//            IMAMsg *imamsg = [IMAMsg msgWith:msg];
//            if (imamsg)
//            {
//                ws.lastMessage = imamsg;
//            }
//        }
//        
//        if (block)
//        {
//            block();
//        }
//    } fail:^(int code, NSString *err) {
//        DebugLog(@"未取到最后一条消息");
//        if (block)
//        {
//            block();
//        }
//    }];
}

- (void)releaseConversation
{
    [_msgList removeAllObjects];
    _receiveMsg = nil;
}

- (void)setReadAllMsg
{
    [IMAPlatform sharedInstance].conversationMgr.unReadMessageCount -= [_conversation getUnReadMessageNum];
    [_conversation setReadMessage:nil succ:nil fail:nil];
}

- (NSInteger)unReadCount
{
    NSInteger count = [_conversation getUnReadMessageNum];
    return count;
}

- (IMAConType)imaType
{
    _imaConType = (IMAConType)[self type];
    return _imaConType;
}

- (IMAMsg *)vailedTopMsg
{
    NSInteger count = [_msgList count];
    if (count > 0)
    {
        NSInteger index = 0;
        do
        {
            IMAMsg *msg = [_msgList objectAtIndex:index];
            if ([msg isVailedType])
            {
                return msg;
            }
            index++;
        }
        while (index < count);
    }
    
    return nil;
}

// 切换到本会话前，先加载本地的最后10条聊天的的数据
- (void)asyncLoadRecentMessage:(NSInteger)count completion:(HandleMsgBlock)block;
{
    IMAMsg *top = [self vailedTopMsg];
    [self asyncLoadRecentMessage:count from:top completion:block];
}

- (NSArray *)onLoadRecentMessageSucc:(NSArray *)timmsgList
{
    if (timmsgList.count > 0)
    {
        NSMutableArray *array = [NSMutableArray array];
        
        NSInteger idx = timmsgList.count - 1;
        TIMMessage *temp = nil;
        do
        {
            TIMMessage *msg = timmsgList[idx];
//            if (msg.status == TIM_MSG_STATUS_HAS_DELETED)
//            {
//                idx--;
//                continue;
//            }
            
            NSDate *date = [msg timestamp];
            if (idx == timmsgList.count - 1)
            {
                // 插入标签
                IMAMsg *timeTip = [IMAMsg msgWithDate:date];
                [array addObject:timeTip];
            }
            
            if (temp)
            {
                NSDate *lastDate = [temp timestamp];
                
                NSTimeInterval timeinterval = [date timeIntervalSinceDate:lastDate];
                if (timeinterval > 5 * 60)
                {
                    // 大于五分钟
                    IMAMsg *msg = [IMAMsg msgWithDate:date];
                    [array addObject:msg];
                }
            }
            temp = msg;
            if (msg.status == TIM_MSG_STATUS_LOCAL_REVOKED) {//撤销
                IMAMsg *imamsg = [IMAMsg msgWithRevoked:msg.sender];
                if (imamsg)
                {
                    [array addObject:imamsg];
                }
            }
            else {
                IMAMsg *imamsg = [IMAMsg msgWith:msg];
                if (imamsg)
                {
                    [array addObject:imamsg];
                }
            }
            idx--;
        }
        while (idx >= 0);
        
        [_msgList insertObjectsFromArray:array atIndex:0];
        return array;
    }
    
    return nil;
}


// 用于顶部下拉加载更多历史消息
- (void)asyncLoadRecentMessage:(NSInteger)count from:(IMAMsg *)msg completion:(HandleMsgBlock)block
{
    __weak IMAConversation *ws = self;
    [_conversation getMessage:(int)count last:msg.msg succ:^(NSArray *array) {
        
        NSArray *recentIMAMsg = [ws onLoadRecentMessageSucc:array];
        if (block)
        {
            block(recentIMAMsg, recentIMAMsg.count != 0);
        }
    } fail:^(int code, NSString *err) {
        DebugLog(@"未取到最后一条消息");
        if (block)
        {
            block(nil, NO);
        }
    }];
}


- (TIMConversationType)type
{
    return [_conversation getType];
}

- (NSString *)receiver;
{
    return [_conversation getReceiver];
}

- (BOOL)isChatWith:(IMAUser *)user
{
    return [[_conversation getReceiver] isEqualToString:[user userId]];
}

- (BOOL)isEqualTo:(IMAConversation *)conv
{
    return ([self type] == [conv type]) && ([[self receiver] isEqualToString:[conv receiver]]);
}

- (BOOL)isEqual:(id)object
{
    BOOL equal = [super isEqual:object];
    if (!equal)
    {
        if ([object isKindOfClass:[IMAConversation class]])
        {
            IMAConversation *conv = (IMAConversation *)object;
            equal = [self isEqualTo:conv];
        }
    }
    return equal;
}

- (NSArray *)sendMessage:(IMAMsg *)msg completion:(HandleMsgCodeBlock)block
{
    if (msg)
    {
        NSMutableArray *array = [self addMsgToList:msg];
        
        [msg changeTo:EIMAMsg_Sending needRefresh:NO];
        [_conversation sendMessage:msg.msg succ:^{
            [msg changeTo:EIMAMsg_SendSucc needRefresh:YES];
            if (block)
            {
                block(array, YES, 0);
            }
        } fail:^(int code, NSString *err) {
            [msg changeTo:EIMAMsg_SendFail needRefresh:YES];
            DebugLog(@"发送消息失败");
            if (code != kSaftyWordsCode)
            {
                DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
                [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
            }
            if (block)
            {
                block(array, NO, code);
            }
        }];
        
        return array;
    }
    return nil;
}

- (void)sendOnlineMessage:(TIMMessage*)msg succ:(TIMSucc)succ fail:(TIMFail)fail
{
    [_conversation sendOnlineMessage:msg succ:succ fail:fail];
}

- (NSMutableArray *)addMsgToList:(IMAMsg *)msg
{
    if (msg)
    {
        NSMutableArray *array = [NSMutableArray array];
        
        IMAMsg *timeTip = [self timeTipOnNewMessage:msg];
        if (timeTip)
        {
            [array addObject:timeTip];
        }
        
        // 外部KVO lastmsg
        self.lastMessage = msg;
        [[IMAPlatform sharedInstance].conversationMgr updateOnLastMessageChanged:self];
        
        // 列表更新
        [array addObject:msg];
        
        [_msgList addObjectsFromArray:array];
        return array;
    }
    return nil;
}

- (NSArray *)appendWillSendMsg:(IMAMsg *)msg completion:(HandleMsgBlock)block
{
    if (msg)
    {
        NSArray *array = [self addMsgToList:msg];
        
        [msg changeTo:EIMAMsg_WillSending needRefresh:YES];

        if (block)
        {
            block(array, YES);
        }
        return array;

    }
    return nil;
}

- (void)replaceWillSendMsg:(IMAMsg *)msg with:(IMAMsg *)newMsg completion:(HandleMsgBlock)block
{
    if (msg && newMsg)
    {
        // 还未真正地删除，先只是同步到列表中
        NSInteger oldIdx = [_msgList indexOfObject:msg];
        NSInteger count = [_msgList count];
        if (oldIdx >= 0 && oldIdx < count)
        {
            [newMsg changeTo:EIMAMsg_Sending needRefresh:YES];
            [_msgList replaceObjectAtIndex:oldIdx withObject:newMsg];
            if (self.lastMessage == msg)
            {
                self.lastMessage = newMsg;
            }
            NSArray *reapceArray = @[[_msgList objectAtIndex:oldIdx]];
            if (block)
            {
                block(reapceArray, YES);
            }
            
            [_conversation sendMessage:newMsg.msg succ:^{
                [newMsg changeTo:EIMAMsg_SendSucc needRefresh:YES];
            } fail:^(int code, NSString *err) {
                [newMsg changeTo:EIMAMsg_SendFail needRefresh:YES];
                DebugLog(@"发送消息失败");
            }];
        }
    }

}

- (NSArray *)revokeMsg:(IMAMsg *)msg isRemote:(BOOL)isRemote completion:(RemoveMsgBlock)block
{
    if (msg)
    {
        NSMutableArray *array = [NSMutableArray array];
        
        NSInteger idx = [_msgList indexOfObject:msg];
        
        if (idx >= 0 && idx < _msgList.count)
        {
            NSInteger preIdx = idx - 1;
            IMAMsg *msgReal = [_msgList objectAtIndex:idx];
            if (preIdx >= 0 && preIdx < _msgList.count)
            {
                IMAMsg *preMsg = [_msgList objectAtIndex:preIdx];
                
                if (preMsg.type == EIMAMSG_TimeTip)
                {
                    if (idx == _msgList.count - 1)
                    {
                        // 最后两条消息
                        [array addObject:preMsg];
                        [array addObject:msgReal];
                    }
                    else
                    {
                        NSInteger nextIdx = idx + 1;
                        
                        if (nextIdx >= 0 && nextIdx < _msgList.count)
                        {
                            IMAMsg *nextMsg = [_msgList objectAtIndex:nextIdx];
                            if (nextMsg.type == EIMAMSG_TimeTip)
                            {
                                [array addObject:nextMsg];
                                [array addObject:msgReal];
                            }
                            else
                            {
                                [array addObject:msgReal];
                            }
                        }
                    }
                }
                else
                {
                    IMAMsg *msgReal = [_msgList objectAtIndex:idx];
                    [array addObject:msgReal];
                }
            }
            else
            {
                IMAMsg *msgReal = [_msgList objectAtIndex:idx];
                [array addObject:msgReal];
            }
        }
        
        if (block)
        {
            __weak CLSafeMutableArray *wcl = _msgList;
            IMAMsg *msgReal = [_msgList objectAtIndex:idx];
            NSUInteger index = [wcl indexOfObject:msgReal];
            IMAMsg *imamsg = [IMAMsg msgWithRevoked:msgReal.msg.sender];
            [wcl replaceObjectAtIndex:index withObject:imamsg];
            
            for (IMAMsg *removemsg in array)
            {
                if (removemsg.type == EIMAMSG_TimeTip || removemsg.type == EIMAMSG_SaftyTip)
                {
                    // 属于自定义的类型，不在IMSDK数据库里面，不能调remove接口
                    continue;
                }
                if (isRemote)
                {
                    block(array, YES, nil);
                }
                else
                {
                    [_conversation revokeMessage:removemsg.msg succ:^{
                        NSLog(@"revoke succ");
                        block(array, YES, nil);
                    } fail:^(int code, NSString *msg) {
                        NSLog(@"revoke fail");
                        NSString *info = [NSString stringWithFormat:@"消息撤回失败,code=%d,msg=%@",code,msg];
                        [[HUDHelper sharedInstance] tipMessage:info delay:3];
                        block(array, NO, nil);
                    }];
                }
                break;
            }
            
        }
        return array;
    }
    return nil;
}

- (NSArray *)removeMsg:(IMAMsg *)msg completion:(RemoveMsgBlock)block
{
    if (msg)
    {
        NSMutableArray *array = [NSMutableArray array];
        
        NSInteger idx = [_msgList indexOfObject:msg];
        
        if (idx >= 0 && idx < _msgList.count)
        {
            NSInteger preIdx = idx - 1;
            IMAMsg *msgReal = [_msgList objectAtIndex:idx];
            if (preIdx >= 0 && preIdx < _msgList.count)
            {
                IMAMsg *preMsg = [_msgList objectAtIndex:preIdx];
                
                if (preMsg.type == EIMAMSG_TimeTip)
                {
                    if (idx == _msgList.count - 1)
                    {
                        // 最后两条消息
                        [array addObject:preMsg];
                        [array addObject:msgReal];
                    }
                    else
                    {
                        NSInteger nextIdx = idx + 1;
                        
                        if (nextIdx >= 0 && nextIdx < _msgList.count)
                        {
                            IMAMsg *nextMsg = [_msgList objectAtIndex:nextIdx];
                            if (nextMsg.type == EIMAMSG_TimeTip)
                            {
                                [array addObject:nextMsg];
                                [array addObject:msgReal];
                            }
                            else
                            {
                                [array addObject:msgReal];
                            }
                        }
                    }
                }
                else
                {
                    IMAMsg *msgReal = [_msgList objectAtIndex:idx];
                    [array addObject:msgReal];
                }
            }
            else
            {
                IMAMsg *msgReal = [_msgList objectAtIndex:idx];
                [array addObject:msgReal];
            }
        }
        
        if (block)
        {
            __weak CLSafeMutableArray *wcl = _msgList;
            CommonVoidBlock action = ^{
                for (IMAMsg *removemsg in array)
                {
                    [removemsg remove];
                }
                
                [wcl removeObjectsInArray:array];
            };
            
            
            block(array, YES, action);
        }
        
        return array;
    }
    
    return nil;
}

- (IMAMsg *)timeTipOnNewMessage:(IMAMsg *)msg
{
    if (_lastMessage)
    {
        NSDate *lastDate = [_lastMessage.msg timestamp];
        
        NSDate *followDate = [msg.msg timestamp];
        
        NSTimeInterval timeinterval = [followDate timeIntervalSinceDate:lastDate];
        if (timeinterval > 5 * 60)
        {
            // 大于五分钟
            IMAMsg *msg = [IMAMsg msgWithDate:followDate];
            return msg;
        }
        
    }
    
    return nil;
}

- (void)onReceiveNewMessage:(IMAMsg *)msg
{
    NSMutableArray *array = [NSMutableArray array];
    
    IMAMsg *timeTip = [self timeTipOnNewMessage:msg];
    
    if (timeTip)
    {
        [array addObject:timeTip];
    }
    
    [array addObject:msg];
    
    [_msgList addObjectsFromArray:array];
    if (_receiveMsg)
    {
        _receiveMsg(array, YES);
    }
}

- (void)setDraft:(TIMMessageDraft *)draft
{
    [_conversation setDraft:draft];
}

- (TIMMessageDraft *)getDraft
{
    return [_conversation getDraft];
}
@end
