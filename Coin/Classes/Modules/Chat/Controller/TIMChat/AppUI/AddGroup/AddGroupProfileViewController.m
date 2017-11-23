//
//  AddGroupProfileViewController.m
//  TIMChat
//
//  Created by wilderliao on 16/3/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "AddGroupProfileViewController.h"

#import "IMAGroup+MemberList.h"


@implementation AddGroupProfileViewController

- (void)onJoinGroup
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"备注信息" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0)
    {
        // 点击确定
        IMAGroup *group = (IMAGroup *)_user;
        UITextField *tf=[alertView textFieldAtIndex:0];
        [group asyncJoinGroup:tf.text succ:^{
            [[HUDHelper sharedInstance] tipMessage:@"成功发出申请"];
        } fail:nil];
    }
}

- (NSString *)joinGroupTitle
{
    return @"申请加入群";
}

- (void)addFooterView
{
    __weak AddGroupProfileViewController *ws = self;
    UserActionItem *exitGroup = [[UserActionItem alloc] initWithTitle:[self joinGroupTitle] icon:nil action:^(id<MenuAbleItem> menu) {
        [ws onJoinGroup];
    }];
    exitGroup.normalBack = [UIImage imageWithColor:kRedColor size:CGSizeMake(32, 32)];
    
    UserProfileFooterPanel *footer = [[UserProfileFooterPanel alloc] initWith:@[exitGroup]];
    [footer setFrameAndLayout:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    _tableFooter = footer;
    _tableView.tableFooterView = _tableFooter;
}


- (void)configOwnViews
{
    _dataDictionary = [NSMutableDictionary dictionary];
    
    IMAGroup *group = (IMAGroup *)_user;
    
    RichCellMenuItem *gmc = [[RichCellMenuItem alloc] initWith:@"群成员" value:[NSString stringWithFormat:@"%d人", (int)[group memberCount]] type:ERichCell_Text action:nil];

    RichMemersMenuItem *gmcPanel = [[RichMemersMenuItem alloc] initWith:nil value:nil type:ERichCell_MemberPanel action:nil];
    gmcPanel.members = [NSMutableArray arrayWithObject:group];
    
    [_dataDictionary setObject:@[gmc, gmcPanel] forKey:@(0)];
    
    RichCellMenuItem *chatId = [[RichCellMenuItem alloc] initWith:@"群组ID" value:[group userId] type:ERichCell_Text action:nil];
    
    RichCellMenuItem *gName = [[RichCellMenuItem alloc] initWith:@"群名称" value:[group showTitle] type:ERichCell_Text action:nil];
    
    RichCellMenuItem *gintro = [[RichCellMenuItem alloc] initWith:@"群介绍" value:[group.groupInfo introduction] type:ERichCell_Text action:nil];
    
    //时间格式转换
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[group.groupInfo createTime]];//[NSDate dateWithTimeIntervalSinceNow:[group.groupInfo createTime]];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    RichCellMenuItem *createTime = [[RichCellMenuItem alloc] initWith:@"创建时间" value:dateStr type:ERichCell_Text action:nil];
    
    [_dataDictionary setObject:@[chatId, gName, gintro,createTime] forKey:@(1)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForItem:(RichCellMenuItem *)item
{
    NSString *reuse = [RichCellMenuItem reuseIndentifierOf:item.type];
    if (item.type == ERichCell_MemberPanel)
    {
        RichMemerPanelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell)
        {
            cell = [[RichMemerPanelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse hasAdd:NO];
        }
        [cell configWith:item];
        return cell;
    }
    else
    {
        RichMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell)
        {
            cell = [[RichMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell configWith:item];
        return cell;
    }
}

@end
