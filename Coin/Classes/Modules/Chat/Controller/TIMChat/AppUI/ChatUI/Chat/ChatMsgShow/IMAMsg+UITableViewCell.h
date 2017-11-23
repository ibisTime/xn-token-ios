//
//  IMAMsg+UITableViewCell.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/8.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAMsg.h"
#import "TIMElemAbleCell.h"

@interface IMAMsg (UITableViewCell)

@property (nonatomic, assign) CGFloat showHeightInChat;
@property (nonatomic, assign) CGSize showContentSizeInChat;
@property (nonatomic, strong) NSAttributedString *showChatAttributedText;
@property (nonatomic, strong) NSAttributedString *showLastMsgAttributedText;
@property (nonatomic, strong) NSAttributedString *showDraftMsgAttributedText;


- (UITableViewCell<TIMElemAbleCell> *)tableView:(UITableView *)tableView style:(TIMElemCellStype)style;

- (Class)showCellClass;

- (UIFont *)inputTextFont;

- (UIColor *)inputTextColor;

- (UIFont *)textFont;

- (UIColor *)textColor;

- (UIFont *)tipFont;

- (UIColor *)tipTextColor;

- (NSInteger)contentMaxWidth;

// IMAMsg 显示的高度
- (NSInteger)heightInWidth:(CGFloat)width inStyle:(BOOL)isGroup;

// 各控件间的水平间距
- (NSInteger)horMargin;

// 根据具体情况content在气泡背景里的inset
- (UIEdgeInsets)contentBackInset;

// 选择控件宽度
- (NSInteger)pickedViewWidth;

// 用户头像大小
- (CGSize)userIconSize;

// 发送消息的宽度
- (NSInteger)sendingTipWidth;

// 群消息时，显示对方名称的高度
- (NSInteger)groupMsgTipHeight;

// 只算内容的size
- (CGSize)contentSizeInWidth:(CGFloat)width;

// 带背景图的Size
- (CGSize)contentBackSizeInWidth:(CGFloat)width;

- (void)updateElem:(TIMElem *)elem attachmentChanged:(NSTextAttachment *)att;

- (NSAttributedString *)loadShowLastMsgAttributedText;

- (void)prepareChatForReuse;

@end
