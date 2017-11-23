//
//  TextTableViewHeaderFooterView.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/15.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TextTableViewHeaderFooterView.h"

@implementation TextTableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        _tipLabel = [[InsetLabel alloc] init];
        _tipLabel.font = kAppSmallTextFont;
        _tipLabel.textColor = kGrayColor;
        _tipLabel.backgroundColor = kClearColor;
        _tipLabel.contentInset = UIEdgeInsetsMake(0, kDefaultMargin, 0, kDefaultMargin);
        [self.contentView addSubview:_tipLabel];
        self.contentView.backgroundColor = kAppBakgroundColor;
        self.backgroundColor = kAppBakgroundColor;
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}


- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.contentView.bounds;
    
    _tipLabel.frame = rect;
}


@end
