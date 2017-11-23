//
//  IMAConversation+ShowAPIs.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/28.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAConversation+ShowAPIs.h"

@implementation IMAConversation (ShowAPIs)

- (Class)showCellClass
{
    return [ConversationListTableViewCell class];
}

- (IMAConType)conversationType
{
    return [self imaType];
}

- (NSInteger)showHeight
{
    return 65;
}
- (NSString *)showReuseIndentifier
{
    return @"IMAConversation_ReuseIndentifier";
}
// 显示的标题
- (NSString *)showTitle
{
    NSString *recerive = [_conversation getReceiver];
    TIMConversationType type = self.type;
    IMAUser *user = nil;
    if (type == TIM_C2C)
    {
        user = [[IMAPlatform sharedInstance].contactMgr getUserByUserId:recerive];
    }
    else if (type == TIM_GROUP)
    {
        user = [[IMAPlatform sharedInstance].contactMgr getUserByGroupId:recerive];
    }
    
    
    
    return user ? [user showTitle] : ![NSString isEmpty:recerive] ? recerive : @"系统消息";
}

- (UIImage *)defaultShowImage
{
    TIMConversationType type = [self type];
    if (type == TIM_C2C)
    {
        return kDefaultUserIcon;
    }
    else if (type == TIM_GROUP)
    {
        return kDefaultGroupIcon;
    }
    else
    {
        return kDefaultSystemIcon;
    }
}

// 显示图像的地址
- (NSURL *)showIconUrl
{
    NSString *recerive = [_conversation getReceiver];
    IMAUser *user = [[IMAPlatform sharedInstance].contactMgr getUserByUserId:recerive];
    
    return [user showIconUrl];
}
- (NSString *)lastMsgTime
{
    return [_lastMessage msgTime];
}
- (NSString *)lastMsg
{
    if (_lastMessage == nil)
    {
        [self asyncLoadLocalLastMsg:nil];
    }
    return [_lastMessage messageTip];
}
- (NSAttributedString *)lastAttributedMsg
{
    if (_lastMessage == nil)
    {
        [self asyncLoadLocalLastMsg:nil];
    }
    return [_lastMessage showLastMsgAttributedText];
}

- (NSAttributedString *)attributedDraft
{
    TIMMessageDraft *msgDraft = [_conversation getDraft];
    if (!msgDraft)
    {
        return nil;
    }
    IMAMsg *msg = [IMAMsg msgWithDraft:msgDraft];
    
    NSMutableAttributedString *flag = [[NSMutableAttributedString alloc] initWithString:@"[草稿]" attributes:@{NSFontAttributeName : [msg tipFont], NSForegroundColorAttributeName : kRedColor}];
    NSAttributedString *draftStr = [msg showDraftMsgAttributedText];
    
    [flag appendAttributedString:draftStr];
    
    return flag;
}

@end


@implementation IMAConnectConversation(ShowAPIs)

- (Class)showCellClass
{
    return [ConnectStatusTableViewCell class];
}

//- (BOOL)isConversation
//{
//    return NO;
//}

- (NSInteger)showHeight
{
    return 32;
}
- (NSString *)showReuseIndentifier
{
    return @"IMAConnectConversation_ReuseIndentifier";
}
// 显示的标题
- (NSString *)showTitle
{
    return @"世界上最遥远的距离就是没网，检查设置";
}

- (UIImage *)defaultShowImage
{
    return [UIImage imageNamed:@"sending_failed"];
}

// 显示图像的地址
- (NSURL *)showIconUrl
{
    return nil;
}
- (NSString *)lastMsgTime
{
    return nil;
}
- (NSString *)lastMsg
{
    return nil;
}
- (NSAttributedString *)lastAttributedMsg
{
    return nil;
}

- (NSString *)draft
{
    return nil;
}

- (NSAttributedString *)attributedDraft
{
    return nil;
}

- (NSInteger)unReadCount
{
    return 0;
}

@end