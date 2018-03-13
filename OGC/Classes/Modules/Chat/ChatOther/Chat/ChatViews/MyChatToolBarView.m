//
// Copyright 1999-2015 MyApp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "MyChatToolBarView.h"
#import "MyEmojView.h"
#import "MyMoreView.h"
#import "MyAudioInputView.h"
#import "EmojHelper.h"
#import "MyUIDefine.h"
@interface MyChatToolBarView(){
    TIMConversationType _type;
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
}


- (void)btnAction:(id)sender;

@end
@implementation MyChatToolBarView

- (id)initWithFrame:(CGRect)frame chatType:(TIMConversationType)type{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBACOLOR(0xEE, 0xEE, 0xEE, 1);
        _type = type;
//        self.toolBarView.frame = frame;
        [self.toolBarView addSubview:self.audioBtn];
        [self.toolBarView addSubview:self.textInputView];
        [self.toolBarView addSubview:self.emojBtn];
        [self.toolBarView addSubview:self.moreBtn];
//        [self.toolBarView addSubview:self.sendBtn];
        [self addSubview:self.toolBarView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (UIButton*) audioBtn{
    if (_audioBtn == nil) {
        _audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_audioBtn setImage:[UIImage imageNamed:@"chat_toolbar_voice_nor"] forState:UIControlStateNormal];
        [_audioBtn setImage:[UIImage imageNamed:@"chat_toolbar_voice_press"] forState:UIControlStateHighlighted];
        [_audioBtn setImage:[UIImage imageNamed:@"chat_toolbar_keyboard_nor"] forState:UIControlStateSelected];
        [_audioBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _audioBtn.tag = MyTagChatToolbarKeyboard;
        [self addSubview:_audioBtn];
        
    }
    return _audioBtn;
}

- (UIView*)toolBarView
{
    if (_toolBarView == nil)
    {
        _toolBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CHAT_BAR_MIN_H+2*CHAT_BAR_VECTICAL_PADDING)];
    }
    return _toolBarView;
}

- (UIButton*) emojBtn
{
    if (_emojBtn == nil)
    {
        _emojBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_emojBtn setImage:[UIImage imageNamed:@"chat_toolbar_smile_nor"] forState:UIControlStateNormal];
        [_emojBtn setImage:[UIImage imageNamed:@"chat_toolbar_smile_press"] forState:UIControlStateHighlighted];
        [_emojBtn setImage:[UIImage imageNamed:@"chat_toolbar_keyboard_nor"] forState:UIControlStateSelected];
        [_emojBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _emojBtn.tag = MyTagChatToolbarEmoj;
        [self addSubview:_emojBtn];
    }
    return _emojBtn;
}

-(UIButton*) moreBtn{
    if (_moreBtn == nil) {
        _moreBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_moreBtn setImage:[UIImage imageNamed:@"chat_toolbar_more_nor"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"chat_toolbar_more_press"] forState:UIControlStateHighlighted];
        [_audioBtn setImage:[UIImage imageNamed:@"chat_toolbar_keyboard_nor"] forState:UIControlStateSelected];
        [_moreBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.tag = MyTagChatToolbarMore;
        [self addSubview:_moreBtn];
        [self setSubviewsLayout];
    }
    return _moreBtn;
}


-(UIView*) emojView{
    if (_emojView == nil){
        _emojView = [[MyEmojView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CHAT_EMOJ_VIEW_H)];
        _emojView.delegate = self;
    }
    return _emojView;
}

-(UIView*) moreView{
    if (_moreView == nil){
        _moreView = [[MyMoreView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CHAT_MORE_VIEW_H) type:_type];
    }
    return _moreView;
}

- (UIView *) recordView{
    if (_recordView == nil) {
        _recordView = [[MyAudioInputView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CHAT_RECORD_VIEW_H)];
        _recordView.delegate = self;
    }
    return _recordView;
}

-(UITextView*) textInputView{
    if (_textInputView == nil) {
        _textInputView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CHAT_BAR_MIN_H)];
        _textInputView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _textInputView.scrollEnabled = YES;
//        _textInputView.backgroundColor = [UIColor redColor];
        _textInputView.returnKeyType = UIReturnKeySend;
        _textInputView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
        _textInputView.delegate = self;
        _textInputView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
        _textInputView.layer.borderWidth = 0.65f;
        _textInputView.layer.cornerRadius = 6.0f;
        _textInputView.font = [UIFont systemFontOfSize:16];
        _previousTextViewContentHeight = [self getTextViewContentH:_textInputView];
        _textInputView.textContainerInset = UIEdgeInsetsMake(kDefaultMargin/4, kDefaultMargin/4, kDefaultMargin/4, kDefaultMargin/4);
        [self addSubview:_textInputView];
    }
    return _textInputView;
}

- (void)setSubviewsLayout{
    
    CGFloat kViewWidth = self.bounds.size.width;
    
    self.emojBtn.frame = CGRectMake(CHAT_BAR_HORIZONTAL_PADDING, CHAT_BAR_VECTICAL_PADDING, CHAT_BAR_MIN_H, CHAT_BAR_MIN_H);
    self.moreBtn.frame = CGRectMake(CGRectGetMaxX(_emojBtn.frame)+CHAT_BAR_HORIZONTAL_PADDING, CHAT_BAR_VECTICAL_PADDING, CHAT_BAR_MIN_H, CHAT_BAR_MIN_H);
    self.audioBtn.frame = CGRectMake(kViewWidth-CHAT_BAR_HORIZONTAL_PADDING-CHAT_BAR_MIN_H, CHAT_BAR_VECTICAL_PADDING, CHAT_BAR_MIN_H, CHAT_BAR_MIN_H);
    CGFloat textInputWidth = CGRectGetMinX(self.audioBtn.frame)-CGRectGetMaxX(self.moreBtn.frame)-2*CHAT_BAR_HORIZONTAL_PADDING;
    
    self.textInputView.frame = CGRectMake(CGRectGetMaxX(self.moreBtn.frame)+CHAT_BAR_HORIZONTAL_PADDING, CHAT_BAR_VECTICAL_PADDING, textInputWidth, CHAT_BAR_MIN_H);
    
    
    self.moreView.frame = CGRectMake(0, CGRectGetMaxY(self.textInputView.frame)+CHAT_BAR_VECTICAL_PADDING, kViewWidth, CHAT_MORE_VIEW_H);
    
    self.emojView.frame = CGRectMake(0, CGRectGetMaxY(self.textInputView.frame)+CHAT_BAR_VECTICAL_PADDING, kViewWidth, CHAT_EMOJ_VIEW_H);
    
    self.recordView.frame = CGRectMake(0, CGRectGetMaxY(self.textInputView.frame)+CHAT_BAR_VECTICAL_PADDING, kViewWidth, CHAT_RECORD_VIEW_H);
}

- (void)updateEmoj{
    CGFloat kViewWidth = self.bounds.size.width;
    self.emojView.frame = CGRectMake(0, CGRectGetMaxY(self.textInputView.frame)+CHAT_BAR_VECTICAL_PADDING, kViewWidth, CHAT_EMOJ_VIEW_H);
}
- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    if ([IOSDeviceConfig sharedConfig].isIOS6Later)
    {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    }
    else
    {
        return textView.contentSize.height;
    }
}

- (void)btnAction:(id)sender{
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    switch (btn.tag) {
        case MyTagChatToolbarKeyboard:
            self.moreBtn.selected = NO;
            self.emojBtn.selected = NO;
            self.textInputView.hidden = btn.selected;
            if (btn.selected) {
                // 获取麦克风权限
                AVAudioSession *avSession = [AVAudioSession sharedInstance];
                if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {
                    [avSession requestRecordPermission:^(BOOL available) {
                        if (available) {
                            //completionHandler
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[[UIAlertView alloc] initWithTitle:@"无法录音" message:@"请在“设置-隐私-麦克风”中允许访问麦克风。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                            });
                        }
                    }];
                }
                
                [self.textInputView resignFirstResponder];
                [self updateButtomView:self.recordView];
                [btn setImage:[UIImage imageNamed:@"chat_toolbar_keyboard_press"] forState:UIControlStateHighlighted];
            }else{
                [self.textInputView becomeFirstResponder];
                [btn setImage:[UIImage imageNamed:@"chat_toolbar_audio_press"] forState:UIControlStateHighlighted];
            }
            break;
        case MyTagChatToolbarEmoj:
            if (btn.selected) {
                [btn setImage:[UIImage imageNamed:@"chat_toolbar_keyboard_press"] forState:UIControlStateHighlighted];
                _moreBtn.selected = NO;
                
                //如果选择表情并且处于录音状态，切换成文字输入状态，但是不显示键盘
                if (self.audioBtn.selected) {
                    self.audioBtn.selected = NO;
                }
                else{//如果处于文字输入状态，使文字输入框失去焦点
                    [self.textInputView resignFirstResponder];
                }
                self.textInputView.hidden = !btn.selected;
                [self updateButtomView:self.emojView];
            } else {
                [btn setImage:[UIImage imageNamed:@"chat_toolbar_smile_press"] forState:UIControlStateHighlighted];
                [self updateButtomView:nil];
//                if (!self.inputChangeBtn.selected) {
//                    [self.textInputView becomeFirstResponder];
//                }
            }
            break;

        case MyTagChatToolbarMore:
            if (btn.selected) {
                _emojBtn.selected = NO;
                
                [btn setImage:[UIImage imageNamed:@"chat_toolbar_keyboard_press"] forState:UIControlStateHighlighted];
                
                //如果选择表情并且处于录音状态，切换成文字输入状态，但是不显示键盘
                if (self.audioBtn.selected) {
                    self.audioBtn.selected = NO;
                }
                else{//如果处于文字输入状态，使文字输入框失去焦点
                    [self.textInputView resignFirstResponder];
                }
                _moreView.frame = CGRectMake(0, CGRectGetMaxY(self.textInputView.frame)+CHAT_BAR_VECTICAL_PADDING, self.frame.size.width, CHAT_MORE_VIEW_H);
                [self updateButtomView:self.moreView];
                self.textInputView.hidden = !btn.selected;
            }else {
                [btn setImage:[UIImage imageNamed:@"chat_toolbar_more_press"] forState:UIControlStateHighlighted];
                [self updateButtomView:nil];
            }
            
            break;
            
        default:
            break;
    }
}


- (void)updateBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = _toolBarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    if(bottomHeight == 0 && self.frame.size.height == _toolBarView.frame.size.height)
    {
        return;
    }
    
    self.frame = toFrame;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeToolBarHight:)]) {
        [_delegate didChangeToolBarHight:toHeight];
    }
}


- (void)keyboardwillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    if (self.buttomView) {
        [self updateButtomView:nil];
    }
    void(^animations)() = ^{
        [self showKeyboard:beginFrame toFrame:endFrame];
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}


- (void)updateButtomView:(UIView*)buttomView{
    
    if (buttomView != nil
        && (self.buttomView==nil || CGRectGetHeight(self.buttomView.bounds) != CGRectGetHeight(buttomView.bounds))) {
        [self updateBottomHeight:buttomView.bounds.size.height];
    }
    else if(buttomView == nil){
        [self updateBottomHeight:0.0f];
    }
    
    if (self.buttomView != nil) {
        [self.buttomView removeFromSuperview];
    }
    
    self.buttomView = buttomView;
    if (self.buttomView != nil) {
        [self addSubview:self.buttomView];
    }
}


- (void)showKeyboard:(CGRect)beginFrame toFrame:(CGRect)toFrame{

    [self updateBottomHeight:toFrame.size.height];
}


- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    CGFloat textViewToHeight = toHeight;
    if (toHeight < CHAT_BAR_MIN_H) {
        textViewToHeight = CHAT_BAR_MIN_H;
    }
    if (toHeight > CHAT_BAR_MAX_H) {
        textViewToHeight = CHAT_BAR_MAX_H;
    }
    
    if (textViewToHeight == self.textInputView.frame.size.height)
    {
        if (toHeight != _previousTextViewContentHeight) {
            if ([[IOSDeviceConfig sharedConfig] isIOS7Later])
            {
                [self.textInputView setContentOffset:CGPointMake(0.0f, (toHeight-self.textInputView.frame.size.height)) animated:YES];
            }
            _previousTextViewContentHeight = toHeight;
        }
        return;
    }
    else{
        CGFloat changeHeight = textViewToHeight - self.textInputView.frame.size.height;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.toolBarView.frame;
        rect.size.height += changeHeight;
        self.toolBarView.frame = rect;
        
        
        
        if (toHeight != _previousTextViewContentHeight)
        {
            if ([IOSDeviceConfig sharedConfig].isIOS6Later)
            {
                [self.textInputView setContentOffset:CGPointMake(0.0f, (toHeight-self.textInputView.frame.size.height)+16) animated:YES];
            }
            _previousTextViewContentHeight = toHeight;
        }

        _previousTextViewContentHeight = toHeight;
        
        if (_delegate && [_delegate respondsToSelector:@selector(didChangeToolBarHight:)]) {
            [_delegate didChangeToolBarHight:self.frame.size.height];
        }
    }
    
}


#pragma mark- UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.emojBtn.selected = NO;
    self.audioBtn.selected = NO;
    self.moreBtn.selected = NO;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if ([self.delegate respondsToSelector:@selector(sendText:)])
        {
            [self.delegate sendText:textView.text];
            self.textInputView.text = @"";
            [self willShowInputTextViewToHeight:[self getTextViewContentH:self.textInputView]];
        }

        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
}

- (BOOL)endEditing:(BOOL)force{
    [super endEditing:force];
    [self.textInputView resignFirstResponder];
    [self updateButtomView:nil];
    self.moreBtn.selected = NO;
    self.emojBtn.selected = NO;
    self.audioBtn.selected = NO;
    self.textInputView.hidden = NO;
    return YES;
}

#pragma mark- MyEmojBoardDelegate

- (void)emojSelect:(EmojInfo *)info
{
    NSString *chatText = self.textInputView.text;
    self.textInputView.text = [NSString stringWithFormat:@"%@%@",chatText, info.emjStr];
    [self textViewDidChange:self.textInputView];
}


- (void)emojDelete
{
    NSString *chatText = self.textInputView.text;
    if (chatText.length >= 2){
        NSString *subStr = [chatText substringFromIndex:chatText.length-2];
        if ([EmojHelper isEmojStr:subStr]) {
            self.textInputView.text = [chatText substringToIndex:chatText.length-2];
            [self textViewDidChange:self.textInputView];
            return;
        }
    }
    
    if (chatText.length > 0) {
        self.textInputView.text = [chatText substringToIndex:chatText.length-1];
    }
}


#pragma mark- MyAudioInputDeletage

- (void)sendAudioRecord:(AudioRecord *)audio{
    if ([self.delegate respondsToSelector:@selector(sendAudioRecord:)]) {
        [self.delegate sendAudioRecord:audio];
    }
}

@end
