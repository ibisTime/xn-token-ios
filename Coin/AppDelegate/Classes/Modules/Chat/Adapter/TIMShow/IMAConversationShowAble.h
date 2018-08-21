//
//  IMAConversationShowAble.h
//  TIMAdapter
//
//  Created by AlexiChen on 16/2/18.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol IMAConversationShowAble <IMAShowAble>

@required

// 对应显示的Cell的类型
- (Class)showCellClass;

// 是否是会话，像网络断开数据也抽象成IMAConversationShowAble
- (IMAConType)conversationType;

// 显示的高度
- (NSInteger)showHeight;

// 重用identifier
- (NSString *)showReuseIndentifier;

// 会话默认图片
- (UIImage *)defaultShowImage;

// 最后一条消息的时间
- (NSString *)lastMsgTime;

// 最后一条消息（普通文本）
- (NSString *)lastMsg;

// 最后一条消息（富文本）
- (NSAttributedString *)lastAttributedMsg;

//// 草稿(普通文本)
//- (NSString *)draft;

// 草稿(富文本)
- (NSAttributedString *)attributedDraft;

// 会话未读数
- (NSInteger)unReadCount;

@end
