//
//  FriendProfileViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/4.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "FriendProfileViewController.h"




@interface FriendProfileViewController ()

@end

@implementation FriendProfileViewController

- (void)addFooterView
{
    __weak IMAUser *wi = _user;
    
    UserActionItem *delFriend = [[UserActionItem alloc] initWithTitle:@"删除好友" icon:nil action:^(id<MenuAbleItem> menu) {
        
        UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"确定删除好友？" message:@"删除该好友后，将从您的联系人中消失，同时相关的消息记录也将一起被删除" cancelButtonTitle:@"取消" otherButtonTitles:@[@"删除"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1)
            {
                [[IMAPlatform sharedInstance] asyncDeleteFriend:wi succ:^(NSArray *arry) {
                    [[HUDHelper sharedInstance] tipMessage:@"删除成功" delay:2 completion:^{
                        [[AppDelegate sharedAppDelegate] popToRootViewController];
                    }];
                } fail:^(int code, NSString *err) {
                    DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
                }];

            }
        }];
        [alert show];
    }];
    delFriend.normalBack = [UIImage imageWithColor:kRedColor size:CGSizeMake(32, 32)];
    
    
    
    UserActionItem *sendMsg = [[UserActionItem alloc] initWithTitle:@"发送消息" icon:nil action:^(id<MenuAbleItem> menu) {
        [[AppDelegate sharedAppDelegate] pushToChatViewControllerWith:wi];
    }];
    sendMsg.normalBack = [UIImage imageWithColor:kGreenColor size:CGSizeMake(32, 32)];
    
    UserProfileFooterPanel *footer = [[UserProfileFooterPanel alloc] initWith:@[delFriend, sendMsg]];
    [footer setFrameAndLayout:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    _tableFooter = footer;
    
    _tableView.tableFooterView = _tableFooter;
}

- (void)configOwnViews
{
    _dataDictionary = [NSMutableDictionary dictionary];
    
    __weak FriendProfileViewController *ws = self;
    
    
    RichCellMenuItem *uid = [[RichCellMenuItem alloc] initWith:@"帐号ID" value:[_user userId] type:ERichCell_Text action:nil];
    
    RichCellMenuItem *remark = [[RichCellMenuItem alloc] initWith:@"备注名" value:[_user showTitle] type:ERichCell_TextNext action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onEditRemark:menu cell:cell];
    }];
    
    IMASubGroup *sbg = [[IMAPlatform sharedInstance].contactMgr subGroupOf:_user];
    RichCellMenuItem *sg = [[RichCellMenuItem alloc] initWith:@"所在分组" value:[sbg showTitle] type:ERichCell_TextNext action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onEditSubGroup:menu cell:cell];
    }];
    
    RichCellMenuItem *bl = [[RichCellMenuItem alloc] initWith:@"加入黑名单" value:nil type:ERichCell_Switch action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        // TODO: 加入黑名单
        [ws onEditBlackList:menu cell:cell];
    }];
    
    [_dataDictionary setObject:@[uid, remark, sg, bl] forKey:@(0)];
}

- (void)onEditBlackList:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    [[IMAPlatform sharedInstance].contactMgr asyncMoveToBlackList:_user succ:^(NSArray *friends) {
        [[AppDelegate sharedAppDelegate] popToRootViewController];
    } fail:^(int code, NSString *msg) {
        DebugLog(@"Fail:--> code=%d,msg=%@,fun=%s", code, msg,__func__);
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
    }];
}

- (void)onEditRemark:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak IMAUser *wu = _user;
    __weak FriendProfileViewController *ws = self;
    EditInfoViewController *vc = [[EditInfoViewController alloc] initWith:@"修改备注名" text:menu.value completion:^(EditInfoViewController *selfPtr, BOOL isFinished) {
        if (isFinished)
        {
            NSString *editText = selfPtr.editText;
            [[IMAPlatform sharedInstance].contactMgr asyncModify:wu remark:editText succ:^{
                [[HUDHelper sharedInstance] tipMessage:@"修改成功"];
                [wu setRemark:editText];
                menu.value = editText;
                [(RichMenuTableViewCell *)cell configWith:menu];
                ws.title = [NSString stringWithFormat:@"%@的资料",  [wu showTitle]];
            } fail:nil];
            
        }
    }];
    [[AppDelegate sharedAppDelegate] presentViewController:vc animated:YES completion:nil];
}

- (void)onEditSubGroup:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak IMAUser *wu = _user;
    SubGroupPickerViewController *vc = [[SubGroupPickerViewController alloc] initWithCompletion:^(SubGroupPickerViewController *selfPtr, BOOL isFinished) {
        [[IMAPlatform sharedInstance].contactMgr asyncModify:wu subgroup:selfPtr.selectedSubGroup succ:^(NSArray *friends) {
            NSString *group = [selfPtr.selectedSubGroup showTitle];
            menu.value = group;
            [(RichMenuTableViewCell *)cell configWith:menu];
        } fail:nil];
    }];
    vc.selectedSubGroup = [[IMAPlatform sharedInstance].contactMgr subGroupOf:_user];
    [[AppDelegate sharedAppDelegate] presentViewController:vc animated:YES completion:nil];
}




@end
