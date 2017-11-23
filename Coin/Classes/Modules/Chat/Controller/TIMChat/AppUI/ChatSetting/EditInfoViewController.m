//
//  EditInfoViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/3.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "EditInfoViewController.h"

#import "AppColorMacro.h"
#import "BaseAppDelegate.h"

@interface EditInfoViewController ()

@end

@implementation EditInfoViewController

- (instancetype)initWith:(NSString *)title completion:(CommonCompletionBlock)com
{
    if (self = [super init])
    {
        self.title = title;
        self.completion = com;
    }
    return self;
}

- (instancetype)initWith:(NSString *)title text:(NSString *)text completion:(CommonCompletionBlock)com
{
    if (self = [self initWith:title completion:com]) {
        _rawText = text;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addTapBlankToHideKeyboardGesture];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onSave)];
    
    if (self.navigationController != [AppDelegate sharedAppDelegate].navigationViewController)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    }
}


- (void)onSave
{
    if (_completion)
    {
        _completion(self, YES);
    }
    
    [self onCancel];
}

- (void)onCancel
{
    [[AppDelegate sharedAppDelegate] dismissViewController:self animated:YES completion:nil];
}

- (void)addOwnViews
{
    _editBack = [[UIView alloc] init];
    _editBack.backgroundColor = kWhiteColor;
    [self.view addSubview:_editBack];
    
    [self  addEdit];
}

- (void)addEdit
{
    UITextField *txt = [[UITextField alloc] init];
    txt.font = kAppMiddleTextFont;
    txt.rightViewMode = UITextFieldViewModeAlways;
    txt.text = _rawText;
    [txt becomeFirstResponder];
    [_editBack addSubview:txt];
    
    _edit = txt;
}

- (void)layoutOnIPhone
{
    [_editBack sizeWith:CGSizeMake(self.view.bounds.size.width, 44)];
    [_editBack alignParentTopWithMargin:kDefaultMargin];
    
    [_edit sizeWith:_editBack.bounds.size];
    [_edit shrink:CGSizeMake(kDefaultMargin, kDefaultMargin/2)];
}

- (void)setEditText:(NSString *)text
{
    [((UITextField *)_edit) setText:text];
}

- (void)setEditPlaceHolder:(NSString *)text
{
    [((UITextField *)_edit) setPlaceholder:text];
}

- (NSString *)editText
{
    return [((UITextField *)_edit) text];
}

@end


@implementation EditTextViewController

- (void)addEdit
{
    UILimitTextView *txt = [[UILimitTextView alloc] init];
    txt.font = kAppMiddleTextFont;
    txt.text = _rawText;
    [txt becomeFirstResponder];
    [_editBack addSubview:txt];
    
    _edit = txt;
}

- (void)setEditPlaceHolder:(NSString *)text
{
    [((UILimitTextView *)_edit) setPlaceHolder:text];
}

- (NSString *)editText
{
    return [((UILimitTextView *)_edit) text];
}

- (void)setLimitLength:(NSInteger)length
{
    [((UILimitTextView *)_edit) setLimitLength:length];
}


- (void)setEditText:(NSString *)text
{
     [((UILimitTextView *)_edit) setText:text];
}

- (void)layoutOnIPhone
{
    [_editBack sizeWith:CGSizeMake(self.view.bounds.size.width, 120)];
    [_editBack alignParentTopWithMargin:kDefaultMargin];
    
    [_edit sizeWith:_editBack.bounds.size];
    [_edit shrink:CGSizeMake(kDefaultMargin, kDefaultMargin/2)];
}



@end
