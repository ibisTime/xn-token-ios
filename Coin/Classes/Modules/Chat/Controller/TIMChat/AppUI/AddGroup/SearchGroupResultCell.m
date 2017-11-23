//
//  SearchGroupResultCell.m
//  TIMChat
//
//  Created by wilderliao on 16/3/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "SearchGroupResultCell.h"

#import "IMAGroup+MemberList.h"

@implementation SearchGroupResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
//        _groupIconView = [[UIImageView alloc] init];
//        [self.contentView addSubview:_groupIconView];
//        
//        int count = 4;
//        while (count--)
//        {
//            UIImageView *icon = [[UIImageView alloc] init];
//            icon.layer.cornerRadius = 11;
//            [icon sizeWith:CGSizeMake(22, 22)];
//            [_groupIconView addSubview:icon];
//            [_groupIcons addObject:icon];
//        }
        _groupIcon = [[UIImageView alloc] init];
        _groupIcon.layer.cornerRadius = 22;
        [_groupIcon sizeWith:CGSizeMake(44, 44)];
        [self.contentView addSubview:_groupIcon];
        
        _groupName = [[UILabel alloc] init];
        _groupName.adjustsFontSizeToFitWidth = YES;
        _groupName.textColor = kBlackColor;
        [self.contentView addSubview:_groupName];
        
        _groupId = [[UILabel alloc] init];
        _groupId.adjustsFontSizeToFitWidth = YES;
        _groupId.textColor = kGrayColor;
        [self.contentView addSubview:_groupId];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onJoinToGroup:)];
//        tap.numberOfTapsRequired = 1;
//        tap.numberOfTouchesRequired = 1;
//        [self.contentView addGestureRecognizer:tap];
    }
    return self;
}

//- (void)onJoinToGroup:(UITapGestureRecognizer *)tap
//{
//    NSLog(@"onJoinToGroup");
//}

- (void)configInfo:(id<IMAGroupShowAble>)groupShowAble
{   
    [_groupIcon sd_setImageWithURL:[groupShowAble showIconUrl] placeholderImage:kDefaultGroupIcon];
    
    _groupName.text = [groupShowAble showTitle];
    
    _groupId.text = [NSString stringWithFormat:@"ID %@",[groupShowAble groupId]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.contentView.bounds;
    [_groupIcon alignParentLeftWithMargin:kDefaultMargin];
    [_groupIcon layoutParentVerticalCenter];
    
    [_groupName sizeWith:CGSizeMake(rect.size.width-44-kDefaultMargin, rect.size.height/2)];
    [_groupName layoutToRightOf:_groupIcon margin:kDefaultMargin];
    
    [_groupId sameWith:_groupName];
    [_groupId layoutBelow:_groupName];
}

@end
