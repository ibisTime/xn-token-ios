//
//  ChatBaseTableViewCell.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/1.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ChatBaseTableViewCell.h"
//#import "HomePageVC.h"
#import "UIView+Responder.h"

@interface MenuButton (TIMElemPickedAbleView)

@end

@implementation MenuButton (TIMElemPickedAbleView)

@end

@implementation ChatBaseTableViewCell

// 只创建，外部统一添加
- (UIView<TIMElemSendingAbleView> *)addSendingTips
{
    MsgSendingTip *tip = [[MsgSendingTip alloc] init];
    return tip;
}

// 只创建，外部统一添加
- (UIView<TIMElemPickedAbleView> *)addPickedView
{
    MenuButton *btn = [[MenuButton alloc] init];
    [btn addTarget:self action:@selector(onPicked:) forControlEvents:UIControlEventTouchUpInside];
    return (UIView<TIMElemPickedAbleView> *)btn;
}

- (void)onPicked:(MenuButton *)btn
{
    btn.selected = !btn.selected;
    _msg.isPicked = btn.selected;
}



- (void)configContent
{
    UIEdgeInsets inset = [_msg contentBackInset];
    if ([_msg isMineMsg])
    {
        _contentBack.image = [[UIImage imageNamed:@"bubble_blue"] resizableImageWithCapInsets:inset];
    }
    else
    {
        _contentBack.image = [[UIImage imageNamed:@"bubble_gray"] resizableImageWithCapInsets:inset];
    }
}


- (void)configSendingTips
{
    [super configSendingTips];
    IMAMsgStatus state = [_msg status];
    [_sendingTipRef setMsgStatus:state];
}

- (void)addC2CCellViews
{
    [super addC2CCellViews];
    [_icon addTarget:self action:@selector(onClickUserIcon) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickUserIcon
{
    IMAUser *sender = [[IMAUser alloc] initWith:[_msg.msg sender]];
    [[IMAPlatform sharedInstance].contactMgr isContainUser:sender];
    
    if (sender)
    {
        
        //跳到个人主页
//        HomePageVC *pageVC = [HomePageVC new];
//
//        pageVC.userId = sender.userId;
//
//        [self.viewController.navigationController pushViewController:pageVC animated:YES];
//        // 不为空说明是好友
//        FriendProfileViewController *vc = [[FriendProfileViewController alloc] initWith:sender];
//        [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
    }
    else
    {
        // 说明是陌生人
        [[IMAPlatform sharedInstance] asyncGetStrangerInfo:[_msg.msg sender] succ:^(IMAUser *auser) {
            StrangerProfileViewController *vc = [[StrangerProfileViewController alloc] initWith:auser];
            [[AppDelegate sharedAppDelegate] pushViewController:vc withBackTitle:@"返回"];
        } fail:^(int code, NSString *msg) {
            DebugLog(@"Fail:--> code=%d,msg=%@,fun=%s", code, msg,__func__);
            [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        }];
    }
}
@end
