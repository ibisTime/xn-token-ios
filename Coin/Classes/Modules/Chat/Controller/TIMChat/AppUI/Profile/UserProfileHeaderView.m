//
//  UserProfileHeaderView.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "UserProfileHeaderView.h"

@implementation UserProfileHeaderView

- (instancetype)initWith:(id<IMAUserShowAble>)item
{
    if (self = [super init])
    {
        [self configWith:item];
    }
    return self;
}

- (void)addOwnViews
{
    _icon = [[UIImageView alloc] init];
    [self addSubview:_icon];
    
    _title = [[UILabel alloc] init];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.textColor = kLightGrayColor;
    _title.font = kAppMiddleTextFont;
    [self addSubview:_title];
    
}

- (void)configWith:(id<IMAUserShowAble>)item
{
    [_icon sd_setImageWithURL:[item showIconUrl] placeholderImage:kDefaultUserIcon];
    _title.text = [item showTitle];
}

- (void)configOwnViews
{
    self.backgroundColor = kWhiteColor;
    _icon.layer.cornerRadius = 50;
}

- (void)relayoutFrameOfSubViews
{
    [_icon sizeWith:CGSizeMake(100, 100)];
    [_icon layoutParentHorizontalCenter];
    [_icon alignParentTopWithMargin:16];
    
    [_title sizeWith:CGSizeMake(self.bounds.size.width, self.bounds.size.height - 100 - 16)];
    [_title layoutBelow:_icon];
    [_title shrink:CGSizeMake(kDefaultMargin, kDefaultMargin)];
}

@end
