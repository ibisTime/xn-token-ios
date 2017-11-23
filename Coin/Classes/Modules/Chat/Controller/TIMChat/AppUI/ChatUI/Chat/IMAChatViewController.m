//
//  IMAChatViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/17.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAChatViewController.h"

@implementation IMAChatViewController

- (void)dealloc
{
    [self.KVOController unobserveAll];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRevokeMsg:) name:kIMAMSG_RevokeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeleteMsg:) name:kIMAMSG_DeleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResendMsg:) name:kIMAMSG_ResendNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangedMsg:) name:kIMAMSG_ChangedNotification object:nil];
    
}

- (void)onRevokeMsg:(NSNotification *)notify
{
    if ([notify.object isKindOfClass:[IMAMsg class]])//本地撤销
    {
        IMAMsg *msg = (IMAMsg *)notify.object;
        __weak typeof(self) ws = self;
        [_conversation revokeMsg:msg isRemote:NO completion:^(NSArray *imamsgList, BOOL succ, CommonVoidBlock removeingAction) {
            if (succ)
            {
                [ws onWillRefresh:imamsgList withAction:removeingAction];
            }
        }];
    }
    else if ([notify.object isKindOfClass:[TIMMessageLocator class]])//接收到撤销消息
    {
        IMAMsg *msg = [self findMsg:(TIMMessageLocator *)notify.object];
        if (!msg) {
            return;
        }
        __weak typeof(self) ws = self;
        [_conversation revokeMsg:msg isRemote:YES completion:^(NSArray *imamsgList, BOOL succ, CommonVoidBlock removeingAction) {
            if (succ)
            {
                [ws onWillRefresh:imamsgList withAction:removeingAction];
            }
        }];
    }
}

- (IMAMsg *)findMsg:(TIMMessageLocator *)locator
{
    for (IMAMsg *imaMsg in _messageList.safeArray)
    {
        if ([imaMsg.msg respondsToLocator:locator])
        {
            return imaMsg;
        }
    }
    return nil;
}

- (void)onDeleteMsg:(NSNotification *)notify
{
    IMAMsg *msg = (IMAMsg *)notify.object;
    __weak IMAChatViewController *ws = self;
    [_conversation removeMsg:msg completion:^(NSArray *imamsgList, BOOL succ, CommonVoidBlock removingAction) {
        if (succ)
        {
            [ws onWillRemove:imamsgList withAction:removingAction];
        }
    }];
}

- (void)onResendMsg:(NSNotification *)notify
{
    IMAMsg *msg = (IMAMsg *)notify.object;
    __weak IMAChatViewController *ws = self;
    [_conversation removeMsg:msg completion:^(NSArray *imamsgList, BOOL succ, CommonVoidBlock removingAction) {
        if (succ)
        {
            [ws onWillRemove:imamsgList withAction:removingAction];
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sendMsg:msg];
    });

}

- (void)onChangedMsg:(NSNotification *)notify
{
    IMAMsg *msg = (IMAMsg *)notify.object;
    
    NSInteger idx = [_conversation.msgList indexOfObject:msg];
    if (idx >= 0 && idx < _conversation.msgList.count)
    {
        [_tableView beginUpdates];
        NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
        [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
    }
}

- (void)addInputPanel
{
    _inputView = [[ChatInputPanel alloc] init];
    _inputView.chatDelegate = self;
    [self.view addSubview:_inputView];
}

- (void)addChatToolBar
{
    [self addInputPanel];
    
    self.KVOController = [FBKVOController controllerWithObserver:self];
    __weak IMAChatViewController *ws = self;
    [self.KVOController observe:_inputView keyPath:@"contentHeight" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
        [ws onInputViewContentHeightChanged:change];
    }];
}

- (void)onInputViewContentHeightChanged:(NSDictionary *)change
{
    NSInteger nv = [change[NSKeyValueChangeNewKey] integerValue];
    NSInteger ov = [change[NSKeyValueChangeOldKey] integerValue];
    if (nv != ov)
    {
        // nv > ov 说明是展开，否则是缩回
        // TODO：界面消息较少时，下面的做法将顶部消息顶出去，可根据内容显示再作显示优化
        NSInteger off = nv - ov;
        if (_tableView.contentSize.height + off <= _tableView.bounds.size.height)
        {
            CGRect rect = _tableView.frame;
            rect.size.height -= off;
            _tableView.frame = rect;
        }
        else
        {
            CGRect rect = _tableView.frame;
            if (rect.origin.y == 0)
            {
                rect.size.height -= off;
                _tableView.frame = rect;
            }
            else
            {
                rect.origin.y -= off;
                _tableView.frame = rect;
            }
            if (off > 0)
            {
                NSInteger toff = _tableView.contentSize.height - _tableView.frame.size.height;
                if (toff < off )
                {
                    if (toff > 0)
                    {
                        _tableView.contentOffset = CGPointMake(_tableView.contentOffset.x, _tableView.contentOffset.y + toff);
                    }
                }
                else
                {
                    _tableView.contentOffset = CGPointMake(_tableView.contentOffset.x, _tableView.contentOffset.y + off);
                }
            }
        }
    }
}


- (void)layoutRefreshScrollView
{
    CGSize size = self.view.bounds.size;
    
    CGFloat tableViewHeight = size.height - _inputView.contentHeight - kBottomInsetHeight;
    _tableView.frame = CGRectMake(0, 0, size.width, tableViewHeight);
    
    [_inputView setFrameAndLayout:CGRectMake(0, tableViewHeight, size.width, _inputView.contentHeight)];
}


-(void)hiddenKeyBoard
{
//    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [_inputView resignFirstResponder];
}

- (void)onChatInput:(UIView<ChatInputAbleView> *)chatInput sendMsg:(IMAMsg *)text
{
    [self sendMsg:text];
    NSMutableArray *elems = [NSMutableArray array];
    for (int index =0 ; index<text.msg.elemCount; index++ )
    {
        [elems addObject:[text.msg getElem:index]];
    }
    NSLog(@"%d",text.msg.elemCount);
}

- (void)onChatInput:(UIView<ChatInputAbleView> *)chatInput willSendMsg:(IMAMsg *)msg
{
    if (msg)
    {
        [_tableView beginUpdates];
        NSArray *newaddMsgs = [_conversation appendWillSendMsg:msg completion:nil];
        
        NSMutableArray *array = [NSMutableArray array];
        for (IMAMsg *newmsg in newaddMsgs)
        {
            NSInteger idx = [_messageList indexOfObject:newmsg];
            NSLog(@"---->idx = %ld",(long)idx);
            NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
            [array addObject:index];
        }
        [_tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *index = [NSIndexPath indexPathForRow:_messageList.count - 1 inSection:0];
            [_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    }
}

- (void)onReplaceDelete:(NSArray *)replaceMsgs
{
    if (replaceMsgs.count)
    {
        [_tableView beginUpdates];
        NSMutableArray *addIndexs = [NSMutableArray array];
        for (IMAMsg *msg in replaceMsgs)
        {
            NSInteger index = [_messageList indexOfObject:msg];
            [addIndexs addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
        // 说明只是替换最后一个
        [_tableView reloadRowsAtIndexPaths:addIndexs withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *index = [NSIndexPath indexPathForRow:_messageList.count - 1 inSection:0];
            [_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    }
}

- (void)onChatInput:(UIView<ChatInputAbleView> *)chatInput replaceWith:(IMAMsg *)newMsg oldMsg:(IMAMsg *)msg
{
    if (msg)
    {
        __weak IMAChatViewController *ws = self;
        [_conversation replaceWillSendMsg:msg with:newMsg completion:^(NSArray *imamsgList, BOOL succ) {
            if (succ)
            {
                [ws onReplaceDelete:imamsgList];
            }
        }];
    }
}

- (void)onWillRefresh:(NSArray *)imamsgList withAction:(CommonVoidBlock)action
{
    [_tableView beginUpdates];
    
    NSMutableArray *indexArray = [NSMutableArray array];
    
    for (IMAMsg *removemsg in imamsgList)
    {
        NSInteger idx = [_messageList indexOfObject:removemsg];
        NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
        [indexArray addObject:index];
    }
    
//    if (action)
//    {
//        action();
//    }
    
    [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    
//    [_tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    
    [_tableView endUpdates];
}

- (void)onWillRemove:(NSArray *)imamsgList withAction:(CommonVoidBlock)action
{
    [_tableView beginUpdates];
    
    NSMutableArray *indexArray = [NSMutableArray array];
    
    for (IMAMsg *removemsg in imamsgList)
    {
        NSInteger idx = [_messageList indexOfObject:removemsg];
        NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
        [indexArray addObject:index];
    }
    
    if (action)
    {
        action();
    }
    
    [_tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    
    [_tableView endUpdates];
}

- (void)onChatInput:(UIView<ChatInputAbleView> *)chatInput cancelSendMsg:(IMAMsg *)msg
{
    if (msg)
    {
        __weak IMAChatViewController *ws = self;
        [_conversation removeMsg:msg completion:^(NSArray *imamsgList, BOOL succ, CommonVoidBlock removingAction) {
            if (succ)
            {
                [ws onWillRemove:imamsgList withAction:removingAction];
            }
        }];
        
    }
}


- (void)onChatInputSendImage:(UIView<ChatInputAbleView> *)chatInput
{
    [self moreViewPhotoAction];
}
- (void)onChatInputTakePhoto:(UIView<ChatInputAbleView> *)chatInput
{
    [self moreViewCameraAction];
}
- (void)onChatInputSendFile:(UIView<ChatInputAbleView> *)chatInput
{
    [self moreViewFileAction];
}
- (void)onChatInputRecordVideo:(UIView<ChatInputAbleView> *)chatInput
{
    [self moreVideVideoAction];
}

@end
