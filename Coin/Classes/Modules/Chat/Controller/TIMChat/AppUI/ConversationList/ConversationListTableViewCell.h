//
//  ConversationListTableViewCell.h
//  TIMChat
//
//  Created by AlexiChen on 16/2/18.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationListTableViewCell : UITableViewCell
{
@protected
    UIButton    *_conversationIcon;
    UILabel     *_conversationName;
    UILabel     *_lastMsgTime;
    UILabel     *_lastMsg;
    UIButton    *_unReadBadge;
    
@protected
    __weak id<IMAConversationShowAble> _showItem;
}

@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, copy) NSString *nickName;

- (void)configCellWith:(id<IMAConversationShowAble>)item;

- (void)refreshCell;

@end
