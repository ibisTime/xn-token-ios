//
//  RichChatTableViewCell.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/31.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "RichChatTableViewCell.h"

@implementation RichChatTableViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    [_msg prepareChatForReuse];
}

// 只创建，外部统一添加
- (UIView *)addElemContent
{
    _textView = [[ChatTextView alloc] init];
    _textView.backgroundColor = kClearColor;
    return _textView;
}

- (void)configContent
{
    [super configContent];
    
    CGSize showSize = [_msg showContentSizeInChat];
    _textView.bounds = CGRectMake(0, 0, showSize.width, showSize.height);
    [_textView showMessage:_msg];
}
@end
