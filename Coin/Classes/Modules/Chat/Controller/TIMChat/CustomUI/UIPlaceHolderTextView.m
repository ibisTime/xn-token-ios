//
//  UITextView+PlaceHolder.m
//  CommonLibrary
//
//  Created by AlexiChen on 15-1-11.
//  Copyright (c) 2015年 AlexiChen Chen. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

#import "NSString+Common.h"

#import "HUDHelper.h"

#import "UIView+CustomAutoLayout.h"

#import "UILabel+Common.h"

#import "UIView+Layout.h"

@implementation UIPlaceHolderTextView

- (void)dealloc
{
    [self removeobserver];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self addObserver];
        _placeHolderColor = kLightGrayColor;
        _mainTextColor = kBlackColor;
    }
    return self;
}

-(void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginOfEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endOfEditing:) name:UITextViewTextDidEndEditingNotification object:self];
}

-(void)removeobserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark Setter/Getters
- (void)setPlaceHolder:(NSString *)placeHolder
{
    NSString *text = self.text;
    if ([NSString isEmpty:text] || [text isEqualToString:_placeHolder])
    {
        super.text = placeHolder;
        //注释颜色
        [super setTextColor:_placeHolderColor];
    }
    _placeHolder = placeHolder;
}

- (NSString *)text
{
    NSString *text = [super text];
    if ([text isEqualToString:_placeHolder])
    {
        return nil;
    }
    return text;
}

- (void)beginOfEditing:(NSNotification *)notification
{
    if ([super.text isEqualToString:_placeHolder])
    {
        super.text = nil;
        //字体颜色
        [super setTextColor:_mainTextColor];
    }
//    else
//    {
//        [super setTextColor:kBlackColor];
//    }
    
}

- (void)endOfEditing:(NSNotification *)notification
{
    if ([NSString isEmpty:self.text])
    {
        super.text = _placeHolder;
        //注释颜色
        [super setTextColor:_placeHolderColor];
    }
}






@end



@implementation UILimitTextView 


- (void)setLimitLength:(NSInteger)limitLength
{
    if (!_limitText)
    {
        _limitText = [[UILabel alloc] init];
        _limitText.backgroundColor = kClearColor;
        _limitText.font = kCommonSmallTextFont;
        _limitText.textColor = kDarkGrayColor;
        _limitText.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_limitText];
    }
    
    if (limitLength > 0)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextViewEditChanged:) name:@"UITextViewTextDidChangeNotification" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextViewTextDidChangeNotification" object:nil];
    }
    _limitLength = limitLength;
    
    [self updateLimitText];
    
    
}


// 监听字符变化，并处理
- (void)onTextViewEditChanged:(NSNotification *)obj
{
    if (_limitLength > 0)
    {
        UITextView *textField = self;
        NSString *toBeString = textField.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > _limitLength)
            {
                [textField shake];
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:_limitLength];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:_limitLength];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _limitLength)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
}




- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.length == 0)
    {
        // 表求增加
        if (self.text.length + text.length > _limitLength)
        {
            [_limitText shake];
            return NO;
        }
    }
    
    return YES;
}

- (void)updateLimitText
{
    NSInteger curLength = self.text.length;
    
    if (curLength > _limitLength)
    {
        [[HUDHelper sharedInstance] tipMessage:@"已达到最大限制字数"];
        
        _limitText.text = [NSString stringWithFormat:@"%ld/%ld", (long)_limitLength, (long)_limitLength];
    }
    else
    {
        _limitText.text = [NSString stringWithFormat:@"%ld/%ld", (long)curLength, (long)_limitLength];
    }
    
    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_limitText)
    {
        CGSize contentSize = self.contentSize;
        
        if (contentSize.height < self.bounds.size.height)
        {
            contentSize = self.bounds.size;
        }
        else
        {
            // 处理contentoffset的问题
        }
        
        CGSize textSize = [_limitText textSizeIn:contentSize];
        CGRect rect = CGRectMake(0, 0, textSize.width + kDefaultMargin, textSize.height + kDefaultMargin);
        rect.origin.x += contentSize.width - rect.size.width - kDefaultMargin;
        rect.origin.y += contentSize.height - rect.size.height - kDefaultMargin;
        _limitText.frame = rect;
        
    }
}




@end
