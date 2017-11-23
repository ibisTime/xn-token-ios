//
//  ContactDrawerView.m
//  TIMChat
//
//  Created by AlexiChen on 16/2/18.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ContactDrawerView.h"

@implementation ContactDrawerView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        [self addOwnViews];
        [self configOwnViews];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDrawer:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        
        self.contentView.backgroundColor = kWhiteColor;
    }
    return self;
}

- (instancetype)initWithPickReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [self initWithReuseIdentifier:reuseIdentifier])
    {
        _isPicker = YES;
    }
    return self;
}

- (void)onTapDrawer:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        if (_isPicker)
        {
            [_drawer setIsPicked:!_drawer.isPicked];
        }
        else
        {
            [_drawer setIsFold:!_drawer.isFold];
        }
        
        if (_tapDrawerCompletion)
        {
            _tapDrawerCompletion(self);
        }
        [self configWithDrawer:_drawer];
    }
}
- (void)addOwnViews
{
    _drawerIcon = [[UIImageView alloc] init];
    _drawerIcon.userInteractionEnabled = YES;
    _drawerIcon.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:_drawerIcon];
    
    _drawerName = [[UILabel alloc] init];
    _drawerName.userInteractionEnabled = YES;
    _drawerName.font = kAppMiddleTextFont;
    [self.contentView addSubview:_drawerName];
    
    _itemsCount = [[UILabel alloc] init];
    _itemsCount.userInteractionEnabled = YES;
    _itemsCount.textAlignment = NSTextAlignmentRight;
    _itemsCount.font = kAppMiddleTextFont;
    _itemsCount.textColor = kGrayColor;
    [self.contentView addSubview:_itemsCount];
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = RGB(225, 225, 225);
    [self.contentView addSubview:_line];
}

- (void)configOwnViews
{
    _drawerName.text = @"测试分给";
    
    _drawerIcon.image = YES ? [UIImage imageWithColor:kRedColor size:CGSizeMake(16, 16)] : [UIImage imageWithColor:kYellowColor size:CGSizeMake(16, 16)];
    
    _itemsCount.text = @"10人";
}

- (void)updateDrawer
{
    [self configWithDrawer:_drawer];
}

- (void)configWithDrawer:(id<IMAContactDrawerShowAble>)drawer
{
    _drawer = drawer;
    _drawerName.text = [drawer showTitle];
    
    
    BOOL fold = _isPicker ? [drawer isPicked] : [drawer isFold];
    _drawerIcon.image = fold ? [UIImage imageNamed:@"subgroup_fold"] : [UIImage imageNamed:@"subgroup_unfold"];
    
    _itemsCount.text = [NSString stringWithFormat:@"%ld人", (long)[drawer itemsCount]];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}


- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.contentView.bounds;
    
    [_drawerIcon sizeWith:CGSizeMake(20, 20)];
    [_drawerIcon layoutParentVerticalCenter];
    [_drawerIcon alignParentLeftWithMargin:20];
    
    [_itemsCount sizeWith:CGSizeMake(60, rect.size.height)];
    [_itemsCount alignParentRightWithMargin:20];
    
    [_drawerName sameWith:_itemsCount];
    [_drawerName layoutToRightOf:_drawerIcon margin:15];
    [_drawerName scaleToLeftOf:_itemsCount margin:15];
    
    [_line sizeWith:CGSizeMake(rect.size.width, 1)];
    [_line alignParentBottom];
}

@end
