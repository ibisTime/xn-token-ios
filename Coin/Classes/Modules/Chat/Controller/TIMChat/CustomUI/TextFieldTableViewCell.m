//
//  TextFieldTableViewCell.m
//  CommonLibrary
//
//  Created by James on 15-1-7.
//  Copyright (c) 2015年 James Chen. All rights reserved.
//

#import "TextFieldTableViewCell.h"

@implementation TextFieldTableViewCell

- (instancetype)initWith:(NSString *)tip reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWith:tip placeHolder:nil reuseIdentifier:reuseIdentifier];
}

- (instancetype)initWith:(NSString *)tip placeHolder:(NSString *)holder reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
        self.editable = YES;
        
        _edit = [[UITextField alloc] initLeftWith:tip];
        _edit.delegate = self;
        _edit.returnKeyType = UIReturnKeyDone;
        _edit.placeholder = holder;
        [self.contentView addSubview:_edit];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (instancetype)initWith:(NSString *)tip placeHolder:(NSString *)holder editAction:(TextFieldBeginEditAction)act reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [self initWith:tip placeHolder:holder reuseIdentifier:reuseIdentifier])
    {
        self.editAction = act;
    }
    return self;
}

//- (instancetype)initWith:(NSString *)tip placeHolder:(NSString *)holder locateIcon:(UIImage *)icon reuseIdentifier:(NSString *)reuseIdentifier
//{
//    return [self initWith:tip placeHolder:holder locateIcon:icon action:nil reuseIdentifier:reuseIdentifier];
//}
//- (instancetype)initWith:(NSString *)tip placeHolder:(NSString *)holder locateIcon:(UIImage *)icon action:(CommonBlock)act reuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
//    {
//        self.editable = YES;
//        
//        _edit = [[UITextField alloc] initLeftWith:tip rightImageWith:icon action:act];
//        _edit.placeholder = holder;
//        _edit.delegate = self;
//        _edit.returnKeyType = UIReturnKeyDone;
//        [self.contentView addSubview:_edit];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    return self;
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}

- (void)relayoutFrameOfSubViews
{
    CGRect bounds = self.contentView.bounds;
    _edit.frame = CGRectInset(bounds, 6, 3);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.editable)
    {
        if (self.editAction)
        {
            return self.editAction(self);
        }
    }
    return self.editable;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self scrollToVisible];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    }
    
}

@end

