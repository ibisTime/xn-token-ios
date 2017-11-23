//
//  RichCellMenuItem.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "RichCellMenuItem.h"

@implementation RichCellMenuItem

- (instancetype)init
{
    if (self = [super init])
    {
        _tipMargin = kDefaultMargin;
        _tipWidth = 80;
        
        _tipColor = kLightGrayColor;
        _tipFont = kAppMiddleTextFont;
        
        _valueColor = kBlackColor;
        _valueFont = kAppMiddleTextFont;
        
        _switchIsEnable = YES;
    }
    return self;
}

- (instancetype)initWith:(NSString *)key value:(NSString *)value type:(RichCellMenuItemType)type action:(RichCellAction)action
{
    if (self = [self init])
    {
        _tip = key;
        _value = value;
        _type = type;
        _action = action;
    }
    return self;
}


+ (NSString *)reuseIndentifierOf:(RichCellMenuItemType)type
{
    switch (type)
    {
        case ERichCell_Switch:               // 需要编辑:
        {
            return @"RichCellMenuItemSwitch";
        }
            break;
        case ERichCell_Member:
        {
            return @"RichCellMenuItemMember";
        }
            break;
        case ERichCell_MemberPanel:
        {
            return @"RichCellMenuItemMemberPanel";
        }
            break;

            
        default:
        {
            return @"RichCellMenuItem";
        }
            break;
    }
    return @"RichCellMenuItem";
}

- (BOOL)isEqual:(id)object
{

    BOOL equal = [super isEqual:object];
    if (!equal)
    {
        if ([object isKindOfClass:[RichCellMenuItem class]])
        {
            RichCellMenuItem *conv = (RichCellMenuItem *)object;
            equal = [_tip isEqualToString:conv.tip];
        }
    }
    return equal;
}

@end


@implementation RichMemersMenuItem


@end
