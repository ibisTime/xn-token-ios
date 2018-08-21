//
//  IMAMsg+Draft.m
//  TIMChat
//
//  Created by wilderliao on 16/7/28.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAMsg+Draft.h"

static NSString *const KTIMMessageDraft = @"KTIMMessageDraft";

@implementation IMAMsg (Draft)

- (TIMMessageDraft *)msgDraft
{
    return objc_getAssociatedObject(self, (__bridge const void *)KTIMMessageDraft);
}

- (void)setMsgDraft:(TIMMessageDraft *)msgDraft
{
    objc_setAssociatedObject(self, (__bridge const void *)KTIMMessageDraft, msgDraft, OBJC_ASSOCIATION_RETAIN);
}


- (instancetype)initWithDraft:(TIMMessageDraft *)msgDraft type:(IMAMSGType)type
{
    if (self = [super init])
    {
        self.msgDraft = msgDraft;
        
        _msg = [msgDraft transformToMessage];
        _type = type;
        _status = EIMAMsg_Init;
    }
    return self;
}


+ (instancetype)msgWithDraft:(TIMMessageDraft *)draft
{
    return [[IMAMsg alloc] initWithDraft:draft type:EIMAMSG_Text];
}

- (BOOL)isMsgDraft
{
    return YES;
}

@end
