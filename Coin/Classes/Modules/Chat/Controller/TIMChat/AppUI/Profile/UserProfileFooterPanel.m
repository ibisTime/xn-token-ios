//
//  UserProfileFooterPanel.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "UserProfileFooterPanel.h"

@implementation UserProfileFooterPanel

- (instancetype)initWith:(NSArray *)actionItems
{
    if (self = [super initWithFrame:CGRectZero])
    {
        _horMarin = 10;
        
        [self replaceWith:actionItems];
    }
    return self;
}

- (void)replaceWith:(NSArray *)actionItems
{
    for (UserActionItem *item in actionItems)
    {
        UserActionButton *btn = [[UserActionButton alloc] initWithAction:item];
        [self addSubview:btn];
    }
    
    [self setFrameAndLayout:self.frame];
}


- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.bounds;
    rect = CGRectInset(rect, 0, (rect.size.height - 44)/2);
    
    [self alignViews:self.subviews isSubView:YES padding:_horMarin margin:_horMarin horizontal:YES inRect:rect];
}

@end
