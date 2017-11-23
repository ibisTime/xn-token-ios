//
//  GroupMemberInfoCell.m
//  TIMChat
//
//  Created by wilderliao on 16/3/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "GroupMemberInfoCell.h"

@implementation GroupMemberInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _memberIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:_memberIcon];
        
        _memberName = [[UILabel alloc] init];
        [self.contentView addSubview:_memberName];
    }
    return self;
}

- (void)configWith:(IMAGroupMember *)user;
{
    _user = user;
    
    [_memberIcon sd_setImageWithURL:[NSURL URLWithString:user.icon] placeholderImage:kDefaultUserIcon];
    
    NSString *name;
    if ([user isKindOfClass:[IMAGroupMember class]])
    {
        if (user.memberInfo)
        {
            name = user.memberInfo.nameCard.length == 0 ? user.nickName : user.memberInfo.nameCard;
            _memberName.text = name.length == 0 ? user.memberInfo.member : name;
        }
    }
    else
    {
        name = user.nickName.length == 0 ? user.userId : user.nickName;
        _memberName.text = name;
    }
    
    _memberName.textColor = kBlackColor;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}

- (void)relayoutFrameOfSubViews
{
    [_memberIcon sizeWith:CGSizeMake(50, 50)];
    [_memberIcon alignParentLeftWithMargin:kDefaultMargin];
    [_memberIcon layoutParentVerticalCenter];
    
    [_memberName sameWith:_memberIcon];
    [_memberName layoutToRightOf:_memberIcon margin:kDefaultMargin];
    [_memberName scaleToParentRightWithMargin:kDefaultMargin];
}

@end
