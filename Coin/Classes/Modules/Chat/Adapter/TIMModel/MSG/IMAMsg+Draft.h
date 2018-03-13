//
//  IMAMsg+Draft.h
//  TIMChat
//
//  Created by wilderliao on 16/7/28.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAMsg.h"

@interface IMAMsg (Draft)

@property (nonatomic, strong) TIMMessageDraft *msgDraft;

+ (instancetype)msgWithDraft:(TIMMessageDraft *)draft;

- (BOOL)isMsgDraft;
@end
