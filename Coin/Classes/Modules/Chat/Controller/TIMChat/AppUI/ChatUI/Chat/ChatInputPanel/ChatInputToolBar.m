
//
//  ChatInputToolBar.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/17.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatInputToolBar.h"

@implementation ChatInputToolBar

#define kButtonSize 36
#define kTextViewMaxHeight 72
#define kVerMargin 7

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ChatSoundRecorder destory];
    [ChatSoundPlayer destory];
}


- (instancetype)init
{
    if (self = [super init])
    {
        self.backgroundColor = RGBAOF(0xEEEEEE, 1);
    }
    return self;
}

- (void)setInputText:(NSString *)text
{
    _textView.text = text;
}

- (UITextView *)inputTextView
{
    return [[UITextView alloc] init];
}

- (void)addOwnViews
{
    _audio = [[UIButton alloc] init];
    [_audio setImage:[UIImage imageNamed:@"chat_toolbar_voice_nor"] forState:UIControlStateNormal];
    [_audio setImage:[UIImage imageNamed:@"chat_toolbar_voice_press"] forState:UIControlStateHighlighted];
    [_audio setImage:[UIImage imageNamed:@"chat_toolbar_keyboard_nor"] forState:UIControlStateSelected];
    [_audio addTarget:self action:@selector(onClickAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_audio];
    
    // 语音按钮
    _audioPressed = [[UIButton alloc] init];
    _audioPressed.layer.cornerRadius = 6;
    _audioPressed.layer.borderColor = kGrayColor.CGColor;
    _audioPressed.layer.shadowColor = kBlackColor.CGColor;
    _audioPressed.layer.shadowOffset = CGSizeMake(1, 1);
    _audioPressed.layer.borderWidth = 0.5;
    _audioPressed.layer.masksToBounds = YES;
    [_audioPressed setBackgroundImage:[UIImage imageWithColor:RGBAOF(0xEEEEEE, 1)] forState:UIControlStateNormal];
    [_audioPressed setBackgroundImage:[UIImage imageWithColor:kLightGrayColor] forState:UIControlStateSelected];
    
    [_audioPressed setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_audioPressed setTitle:@"松开 结束" forState:UIControlStateSelected];
    
    _audioPressed.titleLabel.font = kAppMiddleTextFont;
    
    [_audioPressed addTarget:self action:@selector(onClickRecordTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_audioPressed addTarget:self action:@selector(onClickRecordDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [_audioPressed addTarget:self action:@selector(onClickRecordDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [_audioPressed addTarget:self action:@selector(onClickRecordTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [_audioPressed addTarget:self action:@selector(onClickRecordTouchUpOutside:) forControlEvents:UIControlEventTouchUpInside];
    
    _audioPressed.hidden = YES;
    [self addSubview:_audioPressed];
    
    _textView = [self inputTextView];
    _textView.frame = CGRectMake(0, 0, self.frame.size.width, CHAT_BAR_MIN_H);
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textView.scrollEnabled = YES;
    //        _textInputView.backgroundColor = [UIColor redColor];
    _textView.returnKeyType = UIReturnKeySend;
    _textView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    _textView.delegate = self;
    _textView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    _textView.layer.borderWidth = 0.6;
    _textView.layer.cornerRadius = 6;
    _textView.font = kAppLargeTextFont;
    
    _textView.textContainerInset = UIEdgeInsetsMake(6, 6, 6, 6);
    [self addSubview:_textView];
    
    
    _emoj = [[UIButton alloc] init];
    [_emoj setImage:[UIImage imageNamed:@"chat_toolbar_smile_nor"] forState:UIControlStateNormal];
    [_emoj setImage:[UIImage imageNamed:@"chat_toolbar_smile_press"] forState:UIControlStateHighlighted];
    [_emoj addTarget:self action:@selector(onClikEmoj:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_emoj];
    
    
    _more = [[UIButton alloc] init];
    [_more setImage:[UIImage imageNamed:@"chat_toolbar_more_nor"] forState:UIControlStateNormal];
    [_more setImage:[UIImage imageNamed:@"chat_toolbar_more_press"] forState:UIControlStateHighlighted];
    [_more addTarget:self action:@selector(onClickMore:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_more];
}

- (void)setChatDelegate:(id<ChatInputAbleViewDelegate>)delegate
{
    _chatDelegate = delegate;
    [ChatSoundRecorder sharedInstance].recorderDelegate = delegate;
}

- (void)configOwnViews
{
    self.KVOController = [FBKVOController controllerWithObserver:self];
    __weak ChatInputToolBar *ws = self;
    [self.KVOController observe:[ChatSoundRecorder sharedInstance] keyPath:@"recordState" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [ws onRecordStoped];
    }];
}

- (void)onRecordStoped
{
    if ([ChatSoundRecorder sharedInstance].recordState == EChatRecorder_Stoped)
    {
        _audioPressed.selected = NO;
        [_audioPressed setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_audioPressed setTitle:@"松开 结束" forState:UIControlStateSelected];
    }
}

// 默认高度
- (void)onClickRecordTouchDown:(UIButton *)button
{
    DebugLog(@"======>>>>>>>");
    _audioPressed.selected = YES;
    [[ChatSoundRecorder sharedInstance] startRecord];
}

- (void)onClickRecordDragExit:(UIButton *)button
{
    _audioPressed.selected = YES;
    [_audioPressed setTitle:@"按住 说话" forState:UIControlStateSelected];
    [[ChatSoundRecorder sharedInstance] willCancelRecord];
}

- (void)onClickRecordDragEnter:(UIButton *)button
{
    // 通知界面界面
    [[ChatSoundRecorder sharedInstance] continueRecord];
}

- (void)onClickRecordTouchUpOutside:(UIButton *)button
{
    _audioPressed.selected = NO;
    [_audioPressed setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_audioPressed setTitle:@"松开 结束" forState:UIControlStateSelected];
    
    [[ChatSoundRecorder sharedInstance] stopRecord];
}



- (void)relayoutFrameOfSubViews
{
    [_audio sizeWith:CGSizeMake(kButtonSize, kButtonSize)];
    [_audio alignParentBottomWithMargin:kVerMargin];
    [_audio alignParentLeftWithMargin:kDefaultMargin];
    
    
    [_more sameWith:_audio];
    [_more alignParentRightWithMargin:kDefaultMargin];
    
    [_emoj sameWith:_more];
    [_emoj layoutToLeftOf:_more margin:kDefaultMargin/2];
    
    [_audioPressed sameWith:_audio];
    [_audioPressed layoutToRightOf:_audio margin:kDefaultMargin/2];
    [_audioPressed scaleToLeftOf:_emoj margin:kDefaultMargin/2];
    
    CGRect rect = self.bounds;
    CGRect apframe = _audioPressed.frame;
    
//    rect.origin.x = apframe.origin.x;
    rect.origin.x = kDefaultMargin;
    rect.origin.y = kVerMargin;
    rect.size.height -= 2 * kVerMargin;
    rect.size.width = apframe.size.width + kButtonSize;
    _textView.frame = rect;
    
}

- (BOOL)isEditing
{
    return [_textView isFirstResponder];
}

- (void)onClickMore:(UIButton *)button
{
    if ([_textView isFirstResponder])
    {
        [_textView resignFirstResponder];
    }
    
    _emoj.selected = NO;
    
    button.selected = !button.selected;
    if ([_toolBarDelegate respondsToSelector:@selector(onToolBarClickMore:show:)])
    {
        [_toolBarDelegate onToolBarClickMore:self show:button.selected];
    }
}

- (void)onClikEmoj:(UIButton *)button
{
    if ([_textView isFirstResponder])
    {
        [_textView resignFirstResponder];
    }
    
    _more.selected = NO;
    
    button.selected = !button.selected;
    
    if ([_toolBarDelegate respondsToSelector:@selector(onToolBarClickEmoj:show:)])
    {
        [_toolBarDelegate onToolBarClickEmoj:self show:button.selected];
    }
    
    if (_audio.selected)
    {
        [self onClickAudio:_audio];
    }
}


- (void)onClickAudio:(UIButton *)button
{
    _audio.selected = !_audio.selected;
    _audioPressed.hidden = !_audio.selected;
    _textView.hidden = _audio.selected;
    
    _audioPressed.selected = NO;
    [_audioPressed setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_audioPressed setTitle:@"松开 结束" forState:UIControlStateSelected];
    
    if (!_audioPressed.hidden)
    {
        if ([_textView isFirstResponder])
        {
            [_textView resignFirstResponder];
        }
        // 语音模式
        NSInteger toh = kButtonSize + 2 * kVerMargin;
        if (toh != _contentHeight)
        {
            self.contentHeight = toh;
        }
    }
    else
    {
        // 文字模式
        [self willShowInputTextViewToHeight:[self getTextViewContentH:_textView]];
    }
}


#pragma mark- MyEmojBoardDelegate

- (void)emojSelect:(EmojInfo *)info
{
    NSString *chatText = _textView.text;
    _textView.text = [NSString stringWithFormat:@"%@%@", chatText, info.emjStr];
    [self textViewDidChange:_textView];
}


- (void)emojDelete
{
    NSString *chatText = _textView.text;
    if (chatText.length >= 2)
    {
        NSString *subStr = [chatText substringFromIndex:chatText.length - 2];
        if ([EmojHelper isEmojStr:subStr])
        {
            _textView.text = [chatText substringToIndex:chatText.length - 2];
            [self textViewDidChange:_textView];
            return;
        }
    }
    
    if (chatText.length > 0)
    {
        _textView.text = [chatText substringToIndex:chatText.length - 1];
    }
}

- (BOOL)resignFirstResponder
{
    _emoj.selected = NO;
    _more.selected = NO;
    [_textView resignFirstResponder];
    return [super resignFirstResponder];
}


#pragma mark- UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _audioPressed.hidden = YES;
    _emoj.selected = NO;
    _more.selected = NO;
    return YES;
}

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    DebugLog(@"textViewDidBeginEditing");
//}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    DebugLog(@"textViewDidEndEditing");
    
    [self requestSendStopInputStatus];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if ([_chatDelegate respondsToSelector:@selector(onChatInput:sendMsg:)])
        {
            if (textView.text.length > 0)
            {
                IMAMsg *msg = [IMAMsg msgWithText:textView.text];
                [_chatDelegate onChatInput:self sendMsg:msg];
            }
            _textView.text = @"";
            [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
        }
        
        return NO;
    }
    return YES;
}

- (NSInteger)getTextViewContentH:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        return kButtonSize;
    }
    if ([IOSDeviceConfig sharedConfig].isIOS6Later)
    {
        return (NSInteger)([textView sizeThatFits:textView.bounds.size].height + 1);
    }
    else
    {
        return (NSInteger)(textView.contentSize.height + 1);
    }
}


- (void)textViewDidChange:(UITextView *)textView
{
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
    
    if (textView.text.length == 0)
    {
        [self requestSendStopInputStatus];
    }
    else
    {
        [self requestSendInputStatus];
    }
}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    CGFloat textViewToHeight = toHeight;
    
    if (toHeight < kButtonSize)
    {
        textViewToHeight = kButtonSize;
    }
    
    if (toHeight > kTextViewMaxHeight)
    {
        textViewToHeight = kTextViewMaxHeight;
    }
    
    NSInteger conHeight = textViewToHeight + 2 * kVerMargin;
    if (_contentHeight != conHeight)
    {
        self.contentHeight = conHeight;
    }
    NSInteger off = _textView.contentSize.height - textViewToHeight;
    if (off > 0)
    {
        [_textView setContentOffset:CGPointMake(0, off) animated:YES];
    }
}

//发送"对方正在输入..."消息
- (void)requestSendInputStatus
{
    if (_isInLoop)
    {
        return;
    }
    
    _isInLoop = YES;
    
    [_chatDelegate sendInputStatus];
    
    if (_inputStatusTimer)
    {
        [_inputStatusTimer invalidate];
        _inputStatusTimer = nil;
    }
    _inputStatusTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(onModifyLoopFlag:) userInfo:nil repeats:YES];

}

- (void)onModifyLoopFlag:(NSTimer *)timer
{
    _isInLoop = NO;
}

//发送对方停止输入消息
- (void)requestSendStopInputStatus
{
    if (_inputStatusTimer)
    {
        [_inputStatusTimer invalidate];
        _inputStatusTimer = nil;
    }
    _isInLoop = NO;
    [_chatDelegate sendStopInputStatus];
}

// 按下情情符号
- (void)onInputSystemFace:(ChatSystemFaceItem *)item
{
    // do nothing
}
// 按下删除
- (void)onDelete
{
    // do nothing
}

@end


@implementation RichChatInputToolBar

- (UITextView *)inputTextView
{
    return [[ChatInputTextView alloc] init];
}

#pragma mark- MyEmojBoardDelegate


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if ([_chatDelegate respondsToSelector:@selector(onChatInput:sendMsg:)])
        {
            if (_textView.textStorage.length > 0)
            {
                IMAMsg *msg = [(ChatInputTextView *)_textView getMultiMsg];
                [_chatDelegate onChatInput:self sendMsg:msg];
            }
            [(ChatInputTextView *)_textView clearAll];
            [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
        }
        
        return NO;
    }

    return YES;
}

// 按下情情符号
- (void)onInputSystemFace:(ChatSystemFaceItem *)item
{
    IMAMsg *temp = [[IMAMsg alloc] init];
    
    TIMFaceElem *elem = [[TIMFaceElem alloc] init];
    elem.index = (int)item.emojiIndex;
    elem.data = [item.emojiTag dataUsingEncoding:NSUTF8StringEncoding];
    
    [(ChatInputTextView *)_textView appendSystemFace:elem ofMsg:temp];
    [self willShowInputTextViewToHeight:[self getTextViewContentH:_textView]];
    
    if (_textView.text.length == 0)
    {
        [self requestSendStopInputStatus];
    }
    else
    {
        [self requestSendInputStatus];
    }
}
// 按下删除
- (void)onDelete
{
    [_textView deleteBackward];
}

- (IMAMsg *)getMsgDraft
{
    return [(ChatInputTextView *)_textView getDraftMsg];
}

- (void)setMsgDraft:(IMAMsg *)draft
{
    [(ChatInputTextView *)_textView setDraftMsg:draft];
}
@end
