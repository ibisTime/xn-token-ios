//
//  IMAChatViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/17.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatInputAbleView.h"
#import "ChatInputHeaders.h"

@interface IMAChatViewController : ChatViewController <ChatInputAbleViewDelegate>
{
@protected
    ChatInputPanel *_inputView;
}

@end
