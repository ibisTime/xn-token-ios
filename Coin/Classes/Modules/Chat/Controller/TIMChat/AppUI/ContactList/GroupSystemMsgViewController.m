//
//  GroupSystemMsgViewController.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/1.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "GroupSystemMsgViewController.h"

@implementation GroupSystemMsgTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _applyInfo = [[UILabel alloc] init];
        _applyInfo.font = kAppSmallTextFont;
        _applyInfo.textColor = kGrayColor;
        [self.contentView addSubview:_applyInfo];
    }
    return self;
}
- (void)configWith:(TIMGroupPendencyItem *)item
{
    _item = item;
    
    [_icon sd_setImageWithURL:[item showIconUrl] placeholderImage:kDefaultUserIcon];
    
    _title.text = [item showTitle];
    _detail.text = [item detailInfo];
    _applyInfo.text = [item applyInfo];
    

    [_action setTitle:[item actionTitle] forState:UIControlStateNormal];
    [_action setTitleColor:kBlueColor forState:UIControlStateNormal];
    _action.enabled = [item actionEnable];
    _action.layer.borderWidth = 1;
    _action.layer.borderColor = kBlackColor.CGColor;
    _action.layer.cornerRadius = 3;
    _action.layer.masksToBounds = YES;
    
}

- (void)onClickAction:(UIButton *)btn
{
    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:nil message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"同意",@"拒绝"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            [[IMAPlatform sharedInstance].contactMgr asyncAcceptAddGroup:@"同意" pendencyItem:_item succ:^{
                [_action setTitle:@"已同意" forState:UIControlStateNormal];
                _action.enabled = NO;
            } fail:nil];
        }
        else if (buttonIndex == 2)
        {
            [[IMAPlatform sharedInstance].contactMgr asyncRefuseAddGroup:@"拒绝" pendencyItem:_item succ:^{
                [_action setTitle:@"已拒绝" forState:UIControlStateNormal];
                _action.enabled = NO;
            } fail:nil];
        }
    }];
    [alert show];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.contentView.bounds;
    
    [_icon sizeWith:CGSizeMake(32, 32)];
    [_icon layoutParentVerticalCenter];
    [_icon alignParentLeftWithMargin:kDefaultMargin];
    
    [_action sizeWith:CGSizeMake(60, 30)];
    [_action layoutParentVerticalCenter];
    [_action alignParentRightWithMargin:kDefaultMargin];
    
    [_title sizeWith:CGSizeMake(rect.size.width, rect.size.height/3 - 6)];
    [_title alignParentTopWithMargin:kDefaultMargin];
    [_title layoutToRightOf:_icon margin:kDefaultMargin];
    [_title scaleToLeftOf:_action margin:kDefaultMargin];
    
    [_detail sameWith:_title];
    [_detail layoutBelow:_title margin:kDefaultMargin/2];
    
    [_applyInfo sameWith:_detail];
    [_applyInfo layoutBelow:_detail margin:kDefaultMargin/2];
}
@end


@implementation GroupSystemMsgViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"群系统消息";
    
}

- (void)addRefreshScrollView
{
    _tableView = [[SwipeDeleteTableView alloc] init];
    _tableView.frame = self.view.bounds;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = kClearColor;
    _tableView.scrollsToTop = YES;
    [self.view addSubview:_tableView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setTableFooterView:v];
    
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.refreshScrollView = _tableView;
}

- (void)configOwnViews
{
    _datas = [NSMutableArray array];
    [self pinHeaderAndRefresh];
}

- (void)onRefresh
{
    __weak GroupSystemMsgViewController *ws = self;
    [[IMAPlatform sharedInstance].contactMgr asyncGetGroupPendencyList:^(TIMGroupPendencyMeta *meta, NSArray *pendencies) {
        [ws  onLoadMorePendency:meta result:pendencies];

        uint64_t time = [[NSDate date] timeIntervalSince1970];
        [[IMAPlatform sharedInstance].contactMgr asyncGroupPendencyReport:time succ:nil fail:nil];
    } fail:^(int code, NSString *msg) {
        [ws allLoadingCompleted];
    }];
}

- (void)onLoadMore
{
    __weak GroupSystemMsgViewController *ws = self;
    [[IMAPlatform sharedInstance].contactMgr asyncGetGroupPendencyList:^(TIMGroupPendencyMeta *meta, NSArray *pendencies) {
        [ws  onLoadMorePendency:meta result:pendencies];
    } fail:^(int code, NSString *msg) {
        [ws allLoadingCompleted];
    }];
}

- (void)onLoadPendency:(TIMGroupPendencyMeta *)meta result:(NSArray *)array
{
    [_datas removeAllObjects];
    [self onLoadMorePendency:meta result:array];
}

- (void)onLoadMorePendency:(TIMGroupPendencyMeta *)meta result:(NSArray *)array
{
    if (array.count)
    {
        [_datas addObjectsFromArray:array];
        self.navigationItem.rightBarButtonItem.enabled = [_datas count] > 0;
    }
    else
    {
        if (_datas.count == 0)
        {
            [HUDHelper alert:@"没有未决的消息" action:^{
                [[AppDelegate sharedAppDelegate] popViewController];
            }];
        }
    }
    self.canLoadMore = array.count > 0;
    [self reloadData];
}

- (void)onReloadPendency:(TIMGroupPendencyItem *)item
{
    [_tableView beginUpdates];
    NSInteger idx = [_datas indexOfObject:item];
    NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    [_tableView endUpdates];
}

- (void)onExecuteApply:(TIMGroupPendencyItem *)item
{
    __weak GroupSystemMsgViewController *ws = self;
    
    [item accept:@"acc" succ:^{
        [ws onReloadPendency:item];
    } fail:^(int code, NSString *msg) {
        DebugLog(@"...%d%@",code ,msg);
        
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg) delay:.05];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupSystemMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewFriends"];
    if (!cell)
    {
        cell = [[GroupSystemMsgTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NewFriends"];
    }
    TIMGroupPendencyItem *item = _datas[indexPath.row];
    [cell configWith:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    TIMGroupPendencyItem *item = _datas[indexPath.row];
//    __weak NSMutableArray *wd = _datas;
//    [[IMAPlatform sharedInstance] asyncDeleteFriendPendency:item succ:^(NSArray *friends) {
//        
//        [tableView beginUpdates];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [wd removeObject:item];
//        [tableView endUpdates];
//        
//    } fail:nil];
}

@end



