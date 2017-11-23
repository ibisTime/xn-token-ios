//
//  ContactItemTableViewCell.m
//  TIMChat
//
//  Created by AlexiChen on 16/2/18.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ContactItemTableViewCell.h"

@implementation ContactItemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.imageView.layer.cornerRadius = 16;
        self.imageView.layer.masksToBounds = YES;
        [self configOwnViews];
        
    }
    return self;
}

- (void)configOwnViews
{
    self.imageView.image = [UIImage imageWithColor:kRandomFlatColor size:CGSizeMake(32, 32)];
    self.textLabel.text = @"AlexiChen";
}

- (void)configWithItem:(id<IMAContactItemShowAble>)item
{
    _item = item;
    [self.imageView sd_setImageWithURL:[item showIconUrl] placeholderImage:kDefaultUserIcon];
    self.textLabel.text = [item showTitle];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView sizeWith:CGSizeMake(32, 32)];
    [self.imageView alignParentLeftWithMargin:kDefaultMargin];
    [self.imageView layoutParentVerticalCenter];
    
    [self.textLabel sameWith:self.imageView];
    [self.textLabel layoutToRightOf:self.imageView margin:kDefaultMargin];
    [self.textLabel scaleToParentRightWithMargin:kDefaultMargin];
}

@end


@implementation ContactPickItemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _pick = [[UIButton alloc] init];
        [_pick setImage:[UIImage imageNamed:@"friend_unselected"] forState:UIControlStateNormal];
        [_pick setImage:[UIImage imageNamed:@"friend_selected"] forState:UIControlStateSelected];
        [_pick addTarget:self action:@selector(onPicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_pick];
        
        _iconView = [[UIImageView alloc] init];
        _iconView.layer.cornerRadius = 16;
        _iconView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconView];
        
        _nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLabel];

        [self configOwnViews];
        
        self.backgroundColor = kClearColor;
    }
    return self;
}

- (void)configOwnViews
{
    _iconView.image = [UIImage imageWithColor:kRandomFlatColor size:CGSizeMake(32, 32)];
    _nameLabel.text = @"AlexiChen";
}
- (void)onPick
{
    [self onPicked:_pick];
    
}

- (void)onPicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [_item setIsSelected:btn.selected];
    
    if ([_delegate respondsToSelector:@selector(onPickAction:)])
    {
        [_delegate onPickAction:_item];
    }
}

- (void)setDelegate:(id<ContactPickItemTableViewCellDelegate>)delegate
{
    _delegate = delegate;
}

- (void)configWithItem:(id<IMAContactItemShowAble>)item
{
    _item = item;
    
    _pick.selected = [item isSelected];
    
    
    [_iconView sd_setImageWithURL:[item showIconUrl] placeholderImage:kDefaultUserIcon];
    _nameLabel.text = [item showTitle];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}

- (void)relayoutFrameOfSubViews
{
    [_pick sizeWith:CGSizeMake(16, 16)];
    [_pick layoutParentVerticalCenter];
    [_pick alignParentLeftWithMargin:kDefaultMargin];
    
    [_iconView sizeWith:CGSizeMake(32, 32)];
    [_iconView layoutParentVerticalCenter];
    [_iconView layoutToRightOf:_pick margin:kDefaultMargin];
    
    [_nameLabel sameWith:_iconView];
    [_nameLabel layoutToRightOf:_iconView margin:kDefaultMargin];
    [_nameLabel scaleToParentRightWithMargin:kDefaultMargin];
}

@end
