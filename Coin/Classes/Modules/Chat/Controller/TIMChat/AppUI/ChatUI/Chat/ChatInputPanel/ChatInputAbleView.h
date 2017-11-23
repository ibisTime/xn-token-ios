//
//  ChatInputAbleView.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/17.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChatInputAbleViewDelegate;

@protocol ChatInputAbleView <NSObject>

@required

@property (nonatomic, weak) id<ChatInputAbleViewDelegate> chatDelegate;

// 方便外部KVO;
@property (nonatomic, assign) NSInteger contentHeight;
//- (void)getFocus;

@end


@protocol ChatInputAbleViewDelegate <NSObject>

@optional

- (void)sendInputStatus;

- (void)sendStopInputStatus;

- (void)onChatInput:(UIView<ChatInputAbleView> *)chatInput sendMsg:(IMAMsg *)msg;

// 效果参考ios微信发语间消息效果
// 即将发送msg
- (void)onChatInput:(UIView<ChatInputAbleView> *)chatInput willSendMsg:(IMAMsg *)msg;

// 使用新消息替换原来的
- (void)onChatInput:(UIView<ChatInputAbleView> *)chatInput replaceWith:(IMAMsg *)newMsg oldMsg:(IMAMsg *)msg;

// 取消即将发送的
- (void)onChatInput:(UIView<ChatInputAbleView> *)chatInput cancelSendMsg:(IMAMsg *)msg;


@optional
- (void)onChatInputSendImage:(UIView<ChatInputAbleView> *)chatInput;
- (void)onChatInputTakePhoto:(UIView<ChatInputAbleView> *)chatInput;
- (void)onChatInputSendFile:(UIView<ChatInputAbleView> *)chatInput;
- (void)onChatInputRecordVideo:(UIView<ChatInputAbleView> *)chatInput;

@end