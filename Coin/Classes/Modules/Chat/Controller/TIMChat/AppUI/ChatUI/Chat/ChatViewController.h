//
//  ChatViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/2/23.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MicroVideoView.h"
#import "ChatUserProfile.h"

//#import "TCVideoRecordViewController.h"
//#import "TCNavigationController.h"

typedef NS_ENUM(NSInteger, SendInputStatus)
{
    SendInputStatus_notSend = 0,
    SendInputStatus_Send,
};
@class MyChatToolBarView;

@interface ChatViewController : TableRefreshViewController<MyChatToolBarViewDelegate, MyMoreViewDelegate, MicroVideoDelegate>
{
@protected
    IMAConversation                     *_conversation;
    
    IMAUser                             *_receiver;
    FBKVOController                     *_receiverKVO;
    
    __weak CLSafeMutableArray           *_messageList;
    
@protected
    MyChatToolBarView                   *_toolbar;
    SendInputStatus                     _sendInputStatus;
    NSTimer                             *_inputStatusTimer;
    
//@protected
//    BOOL   _isSendMsg;//判断是否发送过消息。当从联系人列表进入聊天界面时，如果没有发送消息，则不生成新的会话（将生产的新会话删除）
}

@property (nonatomic, strong) ChatUserProfile *userInfo;

- (instancetype)initWith:(IMAUser *)user;

- (void)configWithUser:(IMAUser *)user;

- (void)modifySendInputStatus:(SendInputStatus)status;

- (void)addChatSettingItem;
- (void)onClickChatSetting;


// 加载历史信息
- (void)loadHistotyMessages;

// 添加收到的信息
- (void)appendReceiveMessage;

- (void)sendMsg:(IMAMsg *)msg;

- (void)updateOnSendMessage:(NSArray *)msglist succ:(BOOL)succ;

@end
