//
//  IMAConversationManager.h
//  TIMAdapter
//
//  Created by AlexiChen on 16/2/18.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//


typedef NS_OPTIONS(NSUInteger, IMAConversationChangedNotifyType) {
    EIMAConversation_SyncLocalConversation =    0x01,               // 同步本地会话结束
    EIMAConversation_BecomeActiveTop    =       0x01 << 1,          // 当前会话放在会话列表顶部
    EIMAConversation_NewConversation    =       0x01 << 2,          // 新增会话
    EIMAConversation_DeleteConversation =       0x01 << 3,          // 删除会话
    
    EIMAConversation_Connected          =       0x01 << 4,          // 网络连上
    EIMAConversation_DisConnected       =       0x01 << 5,          // 网络连上
    
    EIMAConversation_ConversationChanged    =       0x01 << 6,          // 会话有更新
    
    
    
    EIMAConversation_AllEvents         = EIMAConversation_SyncLocalConversation | EIMAConversation_BecomeActiveTop | EIMAConversation_NewConversation | EIMAConversation_DeleteConversation |  EIMAConversation_Connected | EIMAConversation_DisConnected | EIMAConversation_ConversationChanged,
};


@interface IMAConversationChangedNotifyItem : NSObject

@property (nonatomic, assign) IMAConversationChangedNotifyType type;
@property (nonatomic, strong) IMAConversation *conversation;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger toIndex;

- (instancetype)initWith:(IMAConversationChangedNotifyType)type;
- (NSString *)notificationName;
- (NSNotification *)changedNotification;
@end

typedef void (^IMAConversationChangedCompletion)(IMAConversationChangedNotifyItem *item);

@interface IMAConversationManager : NSObject<TIMMessageListener, TIMMessageRevokeListener>
{
@protected
    CLSafeMutableArray          *_conversationList;
    NSInteger                   _refreshStyle;
    IMAConversation             *_chattingConversation;      // 正在聊
}

@property (nonatomic, readonly) CLSafeMutableArray *conversationList;
@property (nonatomic, assign) NSInteger unReadMessageCount;
@property (nonatomic, copy) IMAConversationChangedCompletion  conversationChangedCompletion;

//- (void)addConversationChangedObserver:(id)observer handler:(SEL)selector forEvent:(NSUInteger)eventID;
//
//- (void)removeConversationChangedObser:(id)observer;

// 释放当前正在聊天的conversation
- (void)releaseChattingConversation;

// 删除会话
- (void)deleteConversation:(IMAConversation *)conv needUIRefresh:(BOOL)need;

// 更新会话列表
- (void)asyncConversationList;

// 开始与user聊天，会产生新的conversationa或更新原conversation的位置
- (IMAConversation *)chatWith:(IMAUser *)user;

// 查询列表conversationList中与user的conversation;
// 如果存在，则返回在conversationList的对象，否则返回nil
// 与chatWith区别其不会产生新的会话
- (IMAConversation *)queryConversationWith:(IMAUser *)user;

// 删除与某人的会话
- (void)removeConversationWith:(IMAUser *)user;

// 移除sdk生成的会话(不一定在_converdationlist中)
//- (void)removeConversationWithConv:(IMAConversation *)conv;

// 更新与user的会话
- (void)updateConversationWith:(IMAUser *)user;

@end


@interface IMAConversationManager (Protected)

// TIMAdapter内部调用，外部不要调用
// 当连接上
- (void)onConnect;
// 网络断开
- (void)onDisConnect;

// 同步完列表数据后，更新会话列表里面的显示
- (void)updateOnAsyncLoadContactComplete;

// 加载本地会话消息完成，通知外部更新
- (void)updateOnLocalMsgComplete;

// 会话，如果发消息，才更新其在列表中的位置
- (void)updateOnLastMessageChanged:(IMAConversation *)conv;

// conv并非新建，而是已在列表中，有收到新消息 或 chatwith后，将conv移到从列表index处移到0;
// 外部先删除index，然后再插入0
- (void)updateOnChat:(IMAConversation *)conv moveFromIndex:(NSUInteger)index;

- (void)updateOnDelete:(IMAConversation *)conv atIndex:(NSUInteger)index;

- (void)updateOnNewConversation:(IMAConversation *)conv;

- (void)updateOnConversationChanged:(IMAConversation *)conv;

@end
