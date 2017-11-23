//
//  ChatInputToolBar.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/17.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ChatInputToolBar;
@protocol ChatInputToolBarDelegate <NSObject>

- (void)onToolBarClickEmoj:(ChatInputToolBar *)bar show:(BOOL)isShow;
- (void)onToolBarClickMore:(ChatInputToolBar *)bar show:(BOOL)isShow;

@end


@interface ChatInputToolBar : ChatInputBaseView<UITextViewDelegate, MyEmojBoardDelegate, ChatSystemFaceInputDelegate>
{
@protected
    UIButton                *_audio;
@protected
    UIButton                *_audioPressed;
    UITextView              *_textView;
    
@protected
    UIButton                *_emoj;
    
@protected
    UIButton                *_more;

@protected
    NSTimer                 *_inputStatusTimer;
    BOOL                    _isInLoop;//每3秒执行一次，如果在3秒之内，则不发送输入状态
    
@protected
    __weak id<ChatInputToolBarDelegate> _toolBarDelegate;
}

@property (nonatomic, weak) id<ChatInputToolBarDelegate> toolBarDelegate;

- (BOOL)isEditing;

- (void)setInputText:(NSString *)text;

@end


// 因表情在各端不统一
// ChatInputToolBar 中的表情是unicode编码，但在各平台台不能解析
// 为统一表情，各端统一使用表情图片代替原unicode字符串
@interface RichChatInputToolBar : ChatInputToolBar

- (IMAMsg *)getMsgDraft;

- (void)setMsgDraft:(IMAMsg *)draft;

@end
