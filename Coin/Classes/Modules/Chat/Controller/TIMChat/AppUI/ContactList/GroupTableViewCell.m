//
//  GroupTableViewCell.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "GroupTableViewCell.h"

@implementation GroupTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _icon = [[UIImageView alloc] init];
        _icon.layer.cornerRadius = 16;
        [self.contentView addSubview:_icon];
        
        _title = [[UILabel alloc] init];
        _title.font = kCommonMiddleTextFont;
        [self.contentView addSubview:_title];
        
        _memberCount = [[UILabel alloc] init];
        _memberCount.font = kAppSmallTextFont;
        _memberCount.textAlignment = NSTextAlignmentRight;
        _memberCount.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_memberCount];
    }
    return self;
}

- (void)configWith:(id<IMAGroupShowAble>)g
{
    _group = g;
    
    [_icon sd_setImageWithURL:[g showIconUrl] placeholderImage:kDefaultGroupIcon];
    _title.text = [g showTitle];
    _memberCount.text = [NSString stringWithFormat:@"%d人", (int)[g memberCount]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}

- (void)relayoutFrameOfSubViews
{
    [_icon sizeWith:CGSizeMake(32, 32)];
    [_icon layoutParentVerticalCenter];
    [_icon alignParentLeftWithMargin:kDefaultMargin];
    
    
    [_memberCount sizeWith:CGSizeMake(80, 32)];
    [_memberCount alignVerticalCenterOf:_icon];
    [_memberCount alignParentRightWithMargin:kDefaultMargin];
    
    
    [_title sameWith:_icon];
    [_title layoutToRightOf:_icon margin:kDefaultMargin];
    [_title scaleToLeftOf:_memberCount margin:kDefaultMargin];
    
}

@end
