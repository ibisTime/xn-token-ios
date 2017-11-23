//
//  TipTextFieldTableViewCell.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TipTextFieldTableViewCell.h"

@implementation TipTextFieldTableViewCell

- (instancetype)initWith:(NSString *)tip reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWith:tip placeHolder:nil reuseIdentifier:reuseIdentifier];
}

- (instancetype)initWith:(NSString *)tip placeHolder:(NSString *)holder reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
        self.editable = YES;
        
        _horMargin = kDefaultMargin;
        
        _tip = [[UILabel alloc] init];
        _tip.text = tip;
        _tip.font = kAppMiddleTextFont;
        [self.contentView addSubview:_tip];
        
        
        _edit = [[UITextField alloc] init];
        _edit.font = kAppMiddleTextFont;
        _edit.delegate = self;
        _edit.returnKeyType = UIReturnKeyDone;
        _edit.placeholder = holder;
        [self.contentView addSubview:_edit];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    CGRect bounds = self.contentView.bounds;

    CGRect rect = CGRectInset(bounds, _horMargin, 0);
    
    if (_tipWidth == 0)
    {
        CGSize size = [_tip textSizeIn:rect.size];
        _tipWidth = size.width;
    }
    [_tip sizeWith:CGSizeMake(_tipWidth, rect.size.height)];
    [_tip alignParentLeftWithMargin:_horMargin];
    
    [_edit sameWith:_tip];
    [_edit layoutToRightOf:_tip margin:_horMargin];
    [_edit scaleToParentRightWithMargin:_horMargin];
    
}

@end
