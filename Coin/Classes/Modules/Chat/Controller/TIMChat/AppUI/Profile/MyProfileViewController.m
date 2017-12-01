//
//  MyProfileViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/24.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "MyProfileViewController.h"

@implementation MyProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的资料";
    
    //注：设置头像的功能，demo暂不支持，后期也还没有计划支持。SDK中设置头像功能接口 SetFaceURL 是可以用的
}

- (void)configOwnViews
{
    _dataDictionary = [NSMutableDictionary dictionary];
    
    __weak MyProfileViewController *ws = self;
    RichCellMenuItem *uid = [[RichCellMenuItem alloc] initWith:@"帐号ID" value:[_user userId] type:ERichCell_Text action:nil];
    
    RichCellMenuItem *remark = [[RichCellMenuItem alloc] initWith:@"昵称" value:[_user showTitle] type:ERichCell_TextNext action:^(RichCellMenuItem *menu, UITableViewCell *cell) {
        [ws onEditRemark:menu cell:cell];
    }];

    [_dataDictionary setObject:@[uid, remark] forKey:@(0)];
}

- (void)onEditRemark:(RichCellMenuItem *)menu cell:(UITableViewCell *)cell
{
    __weak IMAUser *wu = _user;
    __weak MyProfileViewController *ws = self;
    EditInfoViewController *vc = [[EditInfoViewController alloc] initWith:@"修改昵称" text:menu.value completion:^(EditInfoViewController *selfPtr, BOOL isFinished) {
        if (isFinished)
        {
            NSString *editText = selfPtr.editText;
            NSInteger length = [editText utf8Length];
            NSLog(@"%ld",length);
            [[IMAPlatform sharedInstance].host asyncSetNickname:editText succ:^{
                [[HUDHelper sharedInstance] tipMessage:@"修改成功"];
                [wu setRemark:editText];
                menu.value = editText;
                
                UserProfileHeaderView *info = (UserProfileHeaderView *) ws.tableView.tableHeaderView;
                [info configWith:wu];
                
                [(RichMenuTableViewCell *)cell configWith:menu];
            } fail:nil];
            
        }
    }];
    [[AppDelegate sharedAppDelegate] presentViewController:vc animated:YES completion:nil];
}


@end
