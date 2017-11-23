//
//  ChatHeadRefreshView.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/15.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatHeadRefreshView.h"

@implementation ChatHeadRefreshView



- (void)addOwnViews
{
    [super addOwnViews];
    self.backgroundColor = kAppBakgroundColor;

}


- (void)willLoading
{
    if (_state == EWillLoading)
    {
        return;
    }
    
    _loading.hidden = NO;
    _indicator.hidden = YES;
    _loading.text = @"下拉加载历史聊天信息";
    _state = EWillLoading;
}

- (void)releaseLoading
{
    if (_state == EReleaseLoading)
    {
        return;
    }
    _loading.hidden = NO;
    _indicator.hidden = YES;
    _loading.text = @"松开即可加载历史聊天信息";
    
    _state = EReleaseLoading;
}

@end
