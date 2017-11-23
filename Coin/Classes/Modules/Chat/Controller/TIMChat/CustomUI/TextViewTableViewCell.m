//
//  TextViewTableViewCell.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TextViewTableViewCell.h"

@interface TextViewTableViewCell ()
{
    BOOL     _hasScroll;
}

@end

@implementation TextViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _edit = [[UILimitTextView alloc] init];
        _edit.layer.cornerRadius = kDefaultMargin/2;
        _edit.layer.borderColor = kLightGrayColor.CGColor;
        _edit.layer.borderWidth = 1;
        _edit.delegate = self;
        _edit.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:_edit];
        
        __weak TextViewTableViewCell *cell = self;
        _edit.inputAccessoryView = [[CommonInputToolBar alloc] initWith:^(id<MenuAbleItem> menu) {
            [cell onEditDone];
        }];
        
        _marginInset = UIEdgeInsetsMake(kDefaultMargin, kDefaultMargin, kDefaultMargin, kDefaultMargin);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}

- (void)relayoutFrameOfSubViews
{
    CGRect bounds = self.contentView.bounds;
    bounds.origin.x += _marginInset.left;
    bounds.origin.y += _marginInset.bottom;
    bounds.size.width -= _marginInset.left + _marginInset.right;
    bounds.size.height -= _marginInset.top + _marginInset.bottom;

    _edit.frame = bounds;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textField
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textField
{
    [self scrollToVisible];
}


- (void)onEditDone
{
    [_edit resignFirstResponder];
    if (_hasScroll)
    {
        
        [self scrollViewToOrginal];
    }
}

#define kDefaultKeyBordHeight 260

- (void)scrollViewToOrginal
{
    UIView *t = self;
    while (![t isKindOfClass:[UITableView class]]) {
        t = t.superview;
    };
    if (t)
    {
        UITableView *tableView = (UITableView *)t;
        NSIndexPath *index = [tableView indexPathForCell:self];
        tableView.scrollEnabled = YES;
        [tableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)scrollToVisible
{
    UIView *t = self;
    while (![t isKindOfClass:[UITableView class]]) {
        t = t.superview;
    };
    if (t)
    {
        UITableView *tableView = (UITableView *)t;
        NSIndexPath *index = [tableView indexPathForCell:self];
        
        [tableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        CGRect rect = [self relativePositionTo:keyWindow];
        
        if (rect.origin.y > keyWindow.bounds.origin.y + keyWindow.bounds.size.height - kDefaultKeyBordHeight)
        {
            _hasScroll = YES;
            // 说明还要加偏移
            tableView.contentOffset = CGPointMake(0, kDefaultKeyBordHeight);
            tableView.scrollEnabled = NO;
        }
    }
    
}


@end
