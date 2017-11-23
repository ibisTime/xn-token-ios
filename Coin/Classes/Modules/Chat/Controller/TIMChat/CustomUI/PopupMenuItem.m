
//
//  PopupMenuItem.m
//  TIMChat
//
//  Created by AlexiChen on 16/2/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "PopupMenuItem.h"

@implementation PopupMenuItem

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon action:(MenuAction)action
{
    if (self = [super initWithTitle:title icon:icon action:action]) {
        _enabled = YES;
        _alignment = NSTextAlignmentCenter;
        _foreColor = kBlackColor;
    }
    return self;
}

@end
