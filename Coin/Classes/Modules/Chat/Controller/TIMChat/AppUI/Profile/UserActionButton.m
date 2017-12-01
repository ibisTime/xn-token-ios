//
//  UserActionButton.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "UserActionButton.h"


@implementation UserActionItem


@end

@implementation UserActionButton

- (instancetype)initWithAction:(UserActionItem *)item
{
    if (self = [self initWithMenu:item])
    {
        [self setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self setBackgroundImage:item.normalBack forState:UIControlStateNormal];
        [self setBackgroundImage:item.highlightBack forState:UIControlStateHighlighted];
        
        self.layer.cornerRadius = kDefaultMargin/2;
        self.layer.masksToBounds = YES;
    }
    return self;
}

@end
