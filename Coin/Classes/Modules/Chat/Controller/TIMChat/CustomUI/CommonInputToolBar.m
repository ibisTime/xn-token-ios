//
//  CommonInputToolBar.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "CommonInputToolBar.h"

@implementation CommonInputToolBar

- (instancetype)initWith:(MenuAction)action;
{
    if (self = [super initWithFrame:CGRectMake(0, 0, MainScreenWidth(), 44)])
    {
        _complete = [[MenuButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        _complete.layer.cornerRadius = 4;
        [_complete setBackgroundColor:RGB(240, 240, 240)];
        _complete.titleLabel.font = kAppMiddleTextFont;
        [_complete setTitle:@"完成" forState:UIControlStateNormal];
        [_complete setClickAction:action];
        self.backgroundColor = kLightGrayColor;
        [self addSubview:_complete];
    }
    return self;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_complete layoutParentVerticalCenter];
    [_complete alignParentRightWithMargin:kDefaultMargin];
}

@end
