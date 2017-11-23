//
//  ChatInputTextView.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/31.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatInputTextView.h"

@implementation ChatInputTextView

- (instancetype)init
{
    if (self = [super init])
    {
        // 只用于显示
        self.editable = YES;
        // 只用于显示
        self.scrollEnabled = YES;
        
        self.selectable = YES;

    }
    return self;
}

- (BOOL)enableLongPressed
{
    return YES;
}

- (void)appendSystemFace:(TIMElem *)elem ofMsg:(IMAMsg *)msg
{
    if (elem )
    {
        NSArray *array = [elem inputAttachmentOf:msg];
        
        for (NSAttributedString *str in array)
        {
            NSLog(@"selectedRange.location = %lu",(unsigned long)self.selectedRange.location);
            NSLog(@"self.selectedRange.length = %lu", self.selectedRange.length);
            [self.textStorage insertAttributedString:str atIndex:self.selectedRange.location];
            self.selectedRange = NSMakeRange(self.selectedRange.location + 1, self.selectedRange.length);
        }
    }
}

- (IMAMsg *)getMultiMsg
{
    NSMutableArray  *msgelem = [self getElems];
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    
    for (TIMElem *elem in msgelem)
    {
        [msg addElem:elem];
    }
    
    return [IMAMsg msgWith:msg];
}

- (IMAMsg *)getDraftMsg
{
    NSMutableArray *msgelem = [self getElems];
    
    if (msgelem.count == 0)
    {
        return nil;
    }
    
    TIMMessageDraft *msgDraft = [[TIMMessageDraft alloc] init];
    
    for (TIMElem *elem in msgelem)
    {
        [msgDraft addElem:elem];
    }
    
    return [IMAMsg msgWithDraft:msgDraft];
}

- (void)setDraftMsg:(IMAMsg *)draft
{
    if (draft)
    {
        for (int index = 0; index < draft.msgDraft.elemCount; index++)
        {
            TIMElem *elem = [draft.msgDraft getElem:index];
            if ([elem isKindOfClass:[TIMTextElem class]])
            {
                NSAttributedString *att = [[NSAttributedString alloc] initWithString:((TIMTextElem *)elem).text];
                [self.textStorage insertAttributedString:att atIndex:self.selectedRange.location];
                self.selectedRange = NSMakeRange(self.selectedRange.location + ((TIMTextElem *)elem).text.length, self.selectedRange.length);
            }
            else if ([elem isKindOfClass:[TIMFaceElem class]])
            {
                [self appendSystemFace:elem ofMsg:draft];
            }
        }
        self.font = kAppMiddleTextFont;
    }
}

- (NSMutableArray *)getElems
{
    // 将输入的容，转成多个elem的复杂msg
    NSMutableArray  *msgelem = [NSMutableArray array];
    
    __weak ChatInputTextView *ws = self;
    [self.textStorage enumerateAttributesInRange:NSMakeRange(0, self.textStorage.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        // 遍历富文本，将期转换成TIMElem数组
        ChatImageAttachment *imgatt = attrs[NSAttachmentAttributeName];
        if (imgatt)
        {
            [msgelem insertObject:imgatt.elemRef atIndex:0];
        }
        else
        {
            NSString *text = [ws.textStorage attributedSubstringFromRange:range].string;
            TIMTextElem *elem = [[TIMTextElem alloc] init];
            elem.text = text;
            [msgelem insertObject:elem atIndex:0];
        }
    }];
    return msgelem;
}

- (BOOL)shouldPerformAction:(SEL)action withSender:(id)sender
{
    return YES;
}

- (void)delete:(id)sender
{
    [self cut:sender];
}

@end
