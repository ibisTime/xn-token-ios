//
//  FriendNotifyTableViewCell.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/23.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "FriendNotifyTableViewCell.h"


@implementation FriendNotifyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _icon = [[UIImageView alloc] init];
        _icon.layer.cornerRadius = 16;
        [self.contentView addSubview:_icon];
        
        _title = [[UILabel alloc] init];
        _title.font = kAppMiddleTextFont;
        [self.contentView addSubview:_title];
        
        _detail = [[UILabel alloc] init];
        _detail.font = kAppSmallTextFont;
        _detail.textColor = kGrayColor;
        [self.contentView addSubview:_detail];
        
        _action = [[UIButton alloc] init];
        _action.titleLabel.font = kAppMiddleTextFont;
        [_action setTitle:@"同意" forState:UIControlStateNormal];
        [_action addTarget:self action:@selector(onClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_action];
    }
    return self;
}

- (void)onClickAction:(UIButton *)btn
{
    
}

//- (void)configWith:(TIMFriendPendencyItem *)item
//{
//
//
//    _action.hidden = [_item isSendByMe];
//
//    [_icon sd_setImageWithURL:[item showIconUrl] placeholderImage:kDefaultUserIcon];
//
//    _title.text = [item showTitle];
//    _detail.text = [item applyInfo];
//}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.contentView.bounds;
    
    [_icon sizeWith:CGSizeMake(32, 32)];
    [_icon layoutParentVerticalCenter];
    [_icon alignParentLeftWithMargin:kDefaultMargin];
    
    [_action sizeWith:CGSizeMake(60, 30)];
    [_action layoutParentVerticalCenter];
    [_action alignParentRightWithMargin:kDefaultMargin];
    
    [_title sizeWith:CGSizeMake(rect.size.width, rect.size.height/2 - kDefaultMargin)];
    [_title alignParentTopWithMargin:kDefaultMargin];
    [_title layoutToRightOf:_icon margin:kDefaultMargin];
    [_title scaleToLeftOf:_action margin:kDefaultMargin];
    
    [_detail sameWith:_title];
    [_detail layoutBelow:_title];
}

@end
