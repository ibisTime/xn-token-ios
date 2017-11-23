//
//  ConnectStatusTableViewCell.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/28.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectStatusTableViewCell : UITableViewCell
{
@protected
__weak id<IMAConversationShowAble> _showItem;
}

- (void)configCellWith:(id<IMAConversationShowAble>)item;

- (void)refreshCell;

@end
