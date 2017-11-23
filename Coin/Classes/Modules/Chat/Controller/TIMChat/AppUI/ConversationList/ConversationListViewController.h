//
//  ConversationListViewController.h
//  TIMChat
//
//  Created by wilderliao on 16/2/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TableSearchViewController.h"

@interface ConversationListViewController : TableSearchViewController
{
@protected
    __weak CLSafeMutableArray   *_conversationList;
}

@end
