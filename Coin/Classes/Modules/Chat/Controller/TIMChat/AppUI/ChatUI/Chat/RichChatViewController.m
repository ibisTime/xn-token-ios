//
//  RichChatViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/31.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "RichChatViewController.h"

@implementation RichChatViewController

- (void)dealloc
{
    IMAMsg *draft = [_inputView getMsgDraft];
    if (draft)
    {
        [_conversation setDraft:draft.msgDraft];
    }
    else
    {
        [_conversation setDraft:nil];
//        [self adapterConversation];
    }
    
    //这里必须先清空会话列表
    [[[IMAPlatform sharedInstance].conversationMgr conversationList] removeAllObjects];

    [[IMAPlatform sharedInstance].conversationMgr asyncConversationList];
    
    //退出时上报一次已读，以前是没收到一条消息都上报，会导致server接收到大量的已读上报消息
    [_conversation setReadAllMsg];
}

//在退出聊天界面时，判断当前会话是否应该被创建(如果是从联系人列表进入，且没有发送过消息，且会话列表中不存在这个会话，则认为不应该创建这个新会话)
//- (void)adapterConversation
//{
//    if ([AppDelegate sharedAppDelegate].isContactListEnterChatViewController)
//    {
//        if (!_isSendMsg)
//        {
//            if (![[IMAPlatform sharedInstance].conversationMgr queryConversationWith:_receiver])
//            {
//                [[IMAPlatform sharedInstance].conversationMgr removeConversationWithConv:_conversation];
//            }
//        }
//    }
//}

- (void)addInputPanel
{
    _inputView = [[RichChatInputPanel alloc] initRichChatInputPanel];
    _inputView.chatDelegate = self;
    [self.view addSubview:_inputView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    IMAMsg *draftMsg = [IMAMsg msgWithDraft:[_conversation getDraft]];
    
    [_inputView setMsgDraft:draftMsg];
}

@end
