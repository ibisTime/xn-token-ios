//
//  NewGroupViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/1.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "NewGroupViewController.h"

@implementation NewChatGroupViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self  addTapBlankToHideKeyboardGesture];
}

- (void)addOwnViews
{
    InsetLabel *lbl = [[InsetLabel alloc] init];
    lbl.contentInset = UIEdgeInsetsMake(0, kDefaultMargin, 0, kDefaultMargin);
    lbl.textColor = kDarkGrayColor;
    lbl.font = kAppSmallTextFont;
    [self.view addSubview:lbl];
    _nameTip = lbl;
    
    _nameBack = [[UIView alloc] init];
    _nameBack.backgroundColor = kWhiteColor;
    [self.view addSubview:_nameBack];
    
    _textField = [[UITextField alloc] init];
    _textField.borderStyle = UITextBorderStyleNone;
    //    _textField.clearsOnBeginEditing = YES;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.font = kAppMiddleTextFont;
    [_textField addTarget:self action:@selector(onTextChanged) forControlEvents:UIControlEventEditingChanged];
    
    [_nameBack addSubview:_textField];
    
    _createButton = [[UIButton alloc] init];
    _createButton.layer.cornerRadius = kDefaultMargin;
    _createButton.backgroundColor = RGB(20, 90, 190);
    [_createButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [_createButton addTarget:self action:@selector(onCreate) forControlEvents:UIControlEventTouchUpInside];
    _createButton.enabled = NO;
    [self.view addSubview:_createButton];
}

- (void)onTextChanged
{
    _createButton.enabled = _textField.text.length != 0;
}

- (void)configOwnViews
{
    self.title = @"创建讨论组";
    _nameTip.text = @"讨论组名称";
    [_createButton setTitle:@"添加讨论组成员" forState:UIControlStateNormal];
}


- (void)onCreate
{
    __weak NewChatGroupViewController *ws = self;
    FriendPickerViewController *pvc = [[FriendPickerViewController alloc] initWithCompletion:^(FriendPickerViewController *selfPtr, BOOL isFinished) {
        if (isFinished)
        {
            [ws onCreateGroup:selfPtr.selectedFriends];
        }
    }];
    [[AppDelegate sharedAppDelegate] presentViewController:pvc animated:YES completion:nil];
}

- (void)onCreateGroup:(NSArray *)array
{
    NSString *groupName = _textField.text;
    __weak NewChatGroupViewController *ws = self;
    [[IMAPlatform sharedInstance].contactMgr asyncCreateChatGroupWith:groupName members:array succ:^(IMAGroup *group){
        [[HUDHelper sharedInstance] tipMessage:@"创建讨论组成功"];
        [ws onCreateGroupSucc:group];
    } fail:nil];
}

- (void)onCreateGroupSucc:(IMAGroup *)group
{
    [[AppDelegate sharedAppDelegate] pushToChatViewControllerWith:group];
}

- (void)layoutOnIPhone
{
    [_nameTip sizeWith:CGSizeMake(self.view.bounds.size.width, 30)];
    [_nameTip alignParentTopWithMargin:kDefaultMargin];
    
    
    [_nameBack sizeWith:CGSizeMake(self.view.bounds.size.width, 44)];
    [_nameBack layoutBelow:_nameTip margin:kDefaultMargin];
    
    [_textField sizeWith:_nameBack.bounds.size];
    [_textField shrink:CGSizeMake(kDefaultMargin, 0)];
    
    [_createButton sizeWith:CGSizeMake(self.view.bounds.size.width, 44)];
    [_createButton shrinkHorizontal:20];
    [_createButton layoutBelow:_nameBack margin:20];
}

@end

@implementation NewPublicGroupViewController

- (void)configOwnViews
{
    self.title = @"创建公开群";
    _nameTip.text = @"群名称";
    [_createButton setTitle:@"添加群组成员" forState:UIControlStateNormal];
}

- (void)onCreateGroup:(NSArray *)array
{
    NSString *groupName = _textField.text;
    __weak NewChatGroupViewController *ws = self;
    [[IMAPlatform sharedInstance].contactMgr asyncCreatePublicGroupWith:groupName members:array succ:^(IMAGroup *group){
        [[HUDHelper sharedInstance] tipMessage:@"创建公开群成功"];
        [ws onCreateGroupSucc:group];
    } fail:nil];
}


@end


@implementation NewChatRoomViewController

- (void)configOwnViews
{
    self.title = @"创建聊天室";
    _nameTip.text = @"聊天室名称";
    [_createButton setTitle:@"添加聊天室成员" forState:UIControlStateNormal];
}

- (void)onCreateGroup:(NSArray *)array
{
    NSString *groupName = _textField.text;
    __weak NewChatGroupViewController *ws = self;
    [[IMAPlatform sharedInstance].contactMgr asyncCreateChatRoomWith:groupName members:array succ:^(IMAGroup *group){
        [[HUDHelper sharedInstance] tipMessage:@"创建聊天室成功"];
        [ws onCreateGroupSucc:group];
    } fail:nil];
}



@end