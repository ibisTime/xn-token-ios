//
//  ChatTimeTipTableViewCell.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatTimeTipTableViewCell.h"

@implementation ChatTimeTipTableViewCell

- (BOOL)canShowMenu
{
    return NO;
}

- (instancetype)initWithC2CReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = kClearColor;
        self.backgroundColor = kClearColor;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        
    }
    return self;
}
- (instancetype)initWithGroupReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super init])
    {
        self.contentView.backgroundColor = kClearColor;
        self.backgroundColor = kClearColor;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // do nothing
}

- (void)relayoutFrameOfSubViews
{
    // do nothing
}


- (void)addC2CCellViews
{
    // do nothing
    
}

- (void)addGroupCellViews
{
    // do nothing
}

- (void)relayoutC2CCellViews
{
    // do nothing
}
- (void)relayoutGroupCellViews
{
    // do nothing
}

- (void)configKVO
{
    // do nothing
}

- (void)configWith:(IMAMsg *)msg
{
    _msg = msg;
    TIMCustomElem *elem = (TIMCustomElem *)[msg.msg getElem:0];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [_msg tipFont];
    self.textLabel.textColor = kLightGrayColor;
    self.textLabel.text = [elem timeTip];
}

- (void)configContent
{
    
}

- (void)configElemContent
{
    
}
- (void)configSendingTips
{
    // do nothing
}



- (void)showMenu
{
    // do nothing
}

- (NSArray *)showMenuItems
{
    // do nothing
    return nil;
    
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}


@end


@implementation ChatGroupTipTableViewCell

- (void)configWith:(IMAMsg *)msg
{
    _msg = msg;
    TIMGroupTipsElem *elem = (TIMGroupTipsElem *)[msg.msg getElem:0];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [_msg tipFont];
    self.textLabel.textColor = kLightGrayColor;
    self.textLabel.text = [elem tipText];
}
@end

@implementation ChatSaftyTipTableViewCell

- (void)configWith:(IMAMsg *)msg
{
    _msg = msg;
    TIMElem* elem = [msg.msg getElem:0];
    if ([elem isKindOfClass:[TIMCustomElem class]])
    {
        CustomElemCmd *elemCmd = [CustomElemCmd parseCustom:(TIMCustomElem *)elem];
        if (elemCmd)
        {
            self.textLabel.textAlignment = NSTextAlignmentCenter;
            self.textLabel.font = [_msg tipFont];
            self.textLabel.textColor = kLightGrayColor;
            self.textLabel.text = elemCmd.actionParam;
        }
    }
}

@end

@implementation RevokedTipTableViewCell

- (void)configWith:(IMAMsg *)msg
{
    _msg = msg;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [_msg tipFont];
    self.textLabel.textColor = kLightGrayColor;
    NSString *selfId = [IMAPlatform sharedInstance].host.loginParm.identifier;
    TIMCustomElem *elem = (TIMCustomElem *)[_msg.msg getElem:0];
    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:elem.data options:NSJSONReadingMutableLeaves error:nil];
    NSString *msgSender = [info objectForKey:@"sender"];
    if ([selfId isEqualToString:msgSender]) {
        self.textLabel.text = [NSString stringWithFormat:@"你撤回了一条消息"];
    }
    else
    {
        self.textLabel.text = [NSString stringWithFormat:@"\"%@\" 撤回了一条消息",msgSender];
    }
}

@end
