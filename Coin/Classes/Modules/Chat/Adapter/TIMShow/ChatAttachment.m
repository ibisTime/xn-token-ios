//
//  ChatAttachment.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/31.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatAttachment.h"

@implementation ChatImageAttachment

- (instancetype)initWith:(TIMElem *)elem
{
    if (self = [super init])
    {
        _elemRef = elem;
    }
    return self;
}

@end
