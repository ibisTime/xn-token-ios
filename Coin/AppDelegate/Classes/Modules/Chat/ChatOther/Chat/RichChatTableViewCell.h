//
//  RichChatTableViewCell.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/31.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TIMElemBaseTableViewCell.h"
#import "ChatBaseTableViewCell.h"
#import "ChatTextView.h"

@interface RichChatTableViewCell : ChatBaseTableViewCell
{
@protected
    ChatTextView        *_textView;
}

@end
