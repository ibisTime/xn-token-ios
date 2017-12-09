//
//  RichMenuTableViewCell.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "RichMenuTableViewCell.h"

#import "IMAGroup+MemberList.h"

@implementation RichMenuTableViewCell


+ (NSInteger)heightOf:(RichCellMenuItem *)item inWidth:(CGFloat)width
{
    switch (item.type)
    {
        case  ERichCell_Text:                 // 普通的显示
        {
            return kDefaultCellHeight;
        }
            break;
        case ERichCell_RichText:            // 有富文内容
        {
            CGSize size = CGSizeMake(width - (item.tipMargin + item.tipWidth + kDefaultMargin + kDefaultMargin), HUGE_VALF);
            size = [item.value textSizeIn:size font:item.valueFont];
            if (size.height < kDefaultCellHeight)
            {
                size.height = kDefaultCellHeight;
            }
            return size.height;
        }
            break;
        case ERichCell_TextNext:             // 普通的显示，有下一步
        {
            return kDefaultCellHeight;
        }
            break;
        case ERichCell_RichTextNext:         // 有富文内容，有下一步
        {
            CGSize size = CGSizeMake(width - (item.tipMargin + item.tipWidth + kDefaultMargin  - kNavigationBarHeight/*》到边界的距*/), HUGE_VALF);
            size = [item.value textSizeIn:size font:item.valueFont];
            if (size.height < kDefaultCellHeight)
            {
                size.height = kDefaultCellHeight;
            }
            return size.height;
        }
            break;
        case ERichCell_Switch:               // 需要编辑:
        {
            return kDefaultCellHeight;
        }
            
            break;
        case ERichCell_Member:               // 需要编辑:
        {
            return kDefaultCellHeight;
        }
            
            break;
        case ERichCell_MemberPanel:               // 需要编辑:
        {
            return 70;
        }
            
            break;
            
        default:
        {
            return kDefaultCellHeight;
        }
            break;
    }
    return kDefaultCellHeight;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _tip = [[UILabel alloc] init];
        _tip.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_tip];
        
        _value = [[UILabel alloc] init];
        _value.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_value];
        
        if ([reuseIdentifier isEqualToString:[RichCellMenuItem reuseIndentifierOf:ERichCell_Switch]])
        {
            _onSwitch = [[UISwitch alloc] init];
            [_onSwitch addTarget:self action:@selector(onSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            self.accessoryView = _onSwitch;
        }
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)onSwitchChanged:(UISwitch *)sw
{
//    sw.on = !sw.on;
    if (_item.action)
    {
        _item.action(_item, self);
    }
}

- (void)configWith:(RichCellMenuItem *)item
{
    _item = item;
    
    _tip.text = item.tip;
    _tip.textColor = item.tipColor;
    _tip.font = item.tipFont;
    
    _value.text = item.value;
    _value.textColor = item.valueColor;
    _value.font = item.valueFont;
    
    BOOL isRichText = item.type == ERichCell_RichText || item.type == ERichCell_RichTextNext;
    BOOL isMem = item.type == ERichCell_Member;
    _value.textAlignment = isMem ? NSTextAlignmentRight : item.valueAlignment;
    _value.numberOfLines = isRichText ? 0 : 1;
    _value.lineBreakMode = isRichText ? NSLineBreakByWordWrapping : NSLineBreakByTruncatingTail;
    
    switch (item.type)
    {
        case ERichCell_Text:                 // 普通的显示
        {
            self.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        case ERichCell_RichText:            // 有富文内容
        {
            self.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        case ERichCell_TextNext:             // 普通的显示，有下一步
        {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case ERichCell_RichTextNext:         // 有富文内容，有下一步
        {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case ERichCell_Member:
        {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case ERichCell_Switch:
        {
            _onSwitch.on = item.switchValue;
            _onSwitch.enabled = item.switchIsEnable;
        }
            break;
            
        default:
            break;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.contentView.bounds;
    [_tip sizeWith:CGSizeMake(_item.tipWidth, rect.size.height)];
    [_tip alignParentLeftWithMargin:_item.tipMargin];
    
    [_value sameWith:_tip];
    [_value layoutToRightOf:_tip margin:kDefaultMargin];
    [_value scaleToParentRightWithMargin:kDefaultMargin];
}

@end


@implementation RichMemerPanelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier hasAdd:(BOOL)has
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _memberIconViews = [NSMutableArray array];

        _hasAdd = has;
        if (has)
        {
            UIImageView *addIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_group"]];
            addIcon.layer.cornerRadius = 22;
            [addIcon sizeWith:CGSizeMake(44, 44)];
            addIcon.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddFriendToGroup:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [addIcon addGestureRecognizer:tap];
            [self.contentView addSubview:addIcon];
            [_memberIconViews addObject:addIcon];
        }
    }
    return self;
}

- (void)onAddFriendToGroup:(UITapGestureRecognizer *)tap
{
    __weak RichMemerPanelTableViewCell * ws = self;
    [_group asyncMembersOf:^(NSArray *members) {
        NSMutableArray *users = [NSMutableArray array];
        for (TIMGroupMemberInfo *info in members)
        {
            IMAUser *user = [[IMAUser alloc] initWith:info.member];
            [users addObject:user];
        }
//        FriendPickerViewController *pvc = [[FriendPickerViewController alloc] initWithCompletion:^(FriendPickerViewController *selfPtr, BOOL isFinished) {
//            if (isFinished)
//            {
//                [ws inviteJoin:selfPtr.selectedFriends];
//            }
//        } existedMembers:users right:@"发送邀请"];
//
//        [[AppDelegate sharedAppDelegate] presentViewController:pvc animated:YES completion:nil];
    } fail:nil];
}

- (void)inviteJoin:(NSArray *)array
{
    [_group asyncInviteMembers:array succ:^(NSArray *members) {
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kGroup_InviteJoinedMemberNotification object:members];
//        [[HUDHelper sharedInstance] tipMessage:@"邀请成功"];
    } fail:nil];
}

- (void)configGroup:(IMAGroup *)group
{
    _group = group;
}

- (void)configWith:(RichCellMenuItem *)item
{
    _item = item;
    const NSInteger width = MainScreenWidth() - kDefaultMargin;

    NSInteger count = width / (44 + kDefaultMargin);
    
    if (_hasAdd)
    {
        count -= 1;//一行最多放count－1个头像(需要放置一个加号)
    }
    
    RichMemersMenuItem *mem = (RichMemersMenuItem *)item;
    
    if (_memberIconViews.count == _hasAdd)
    {
        for (NSInteger i = 0; i < mem.members.count && i < count; i++)
        {
            UIImageView *view = [[UIImageView alloc] init];//[_memberIconViews objectAtIndex:i];
            view.layer.cornerRadius = 22;
            [view sizeWith:CGSizeMake(44, 44)];
            [self.contentView addSubview:view];
            
            id<IMAShowAble> user = mem.members[i];
            view.hidden = NO;
            [view sd_setImageWithURL:[user showIconUrl] placeholderImage:kDefaultUserIcon];
            [_memberIconViews insertObject:view atIndex:0];
        }
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.contentView.bounds;
    
    CGRect realRect = CGRectMake(0, 0, _memberIconViews.count * (44 + kDefaultMargin), rect.size.height);
    realRect = CGRectInset(realRect, kDefaultMargin/2, (rect.size.height - 44)/2);
    [self.contentView alignSubviews:_memberIconViews horizontallyWithPadding:kDefaultMargin margin:0 inRect:realRect];
}

@end
