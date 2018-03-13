//
//  ChatInputTextView.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/31.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatTextView.h"

// 普通文本的输入与UITextView中一致

@interface ChatInputTextView : ChatTextView

// 目前只处理系统的表情
- (void)appendSystemFace:(TIMElem *)elem ofMsg:(IMAMsg *)msg;

- (IMAMsg *)getMultiMsg;

- (IMAMsg *)getDraftMsg;

- (void)setDraftMsg:(IMAMsg *)draft;

@end
