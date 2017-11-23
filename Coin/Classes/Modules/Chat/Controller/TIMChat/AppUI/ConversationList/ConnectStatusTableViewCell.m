//
//  ConnectStatusTableViewCell.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/28.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ConnectStatusTableViewCell.h"

@implementation ConnectStatusTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.textLabel.font = kAppSmallTextFont;
        self.backgroundColor = [[UIColor flatYellowColor] colorWithAlphaComponent:0.5];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.imageView.image = [UIImage imageNamed:@"sending_failed"];
    }
    return self;
}

- (void)configCellWith:(id<IMAConversationShowAble>)item
{
    _showItem = item;
    self.textLabel.text = [_showItem showTitle];
}

- (void)refreshCell
{
    // do nothing
}

@end
