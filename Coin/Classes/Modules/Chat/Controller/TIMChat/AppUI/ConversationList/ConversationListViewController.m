//
//  ConversationListViewController.m
//  TIMChat
//
//  Created by wilderliao on 16/2/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "ConversationListViewController.h"

#import "ConversationListTableViewCell.h"

#import <UIScrollView+TLAdd.h>
#import "TLUser.h"

@interface ConversationListViewController ()

@property (nonatomic, strong) NSArray *users;

@end

@implementation ConversationListViewController

- (void)dealloc
{
    [self.KVOController unobserveAll];
}

- (void)addHeaderView
{
    
}
- (void)addFooterView
{
    
}

- (BOOL)hasData
{
    BOOL has = _conversationList.count != 0;
    return has;
}

- (void)addRefreshScrollView
{
    _tableView = [[SwipeDeleteTableView alloc] init];
    
    _tableView.frame = CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight - kBottomInsetHeight);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = kClearColor;
    _tableView.scrollsToTop = YES;
    
    [_tableView adjustsContentInsets];
    
    [self.view addSubview:_tableView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setTableFooterView:v];
    
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.refreshScrollView = _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pinHeaderView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    //判断腾讯云是否已登录
//    if (![IMAPlatform sharedInstance].isConnected) {
//
//        [[ChatManager sharedManager] getTencentSign];
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IMAPlatform sharedInstance].conversationMgr releaseChattingConversation];
    
    //判断是否有消息
    [self allLoadingCompleted];
}

- (void)addSearchController
{
}

- (void)configOwnViews
{
    
    IMAConversationManager *mgr = [IMAPlatform sharedInstance].conversationMgr;
    _conversationList = [mgr conversationList];
    
    __weak ConversationListViewController *ws = self;
    mgr.conversationChangedCompletion = ^(IMAConversationChangedNotifyItem *item) {
        [ws onConversationChanged:item];
    };
    
    //    [[IMAPlatform sharedInstance].conversationMgr addConversationChangedObserver:self handler:@selector(onConversationChanged:) forEvent:EIMAConversation_AllEvents];

    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:[IMAPlatform sharedInstance].conversationMgr keyPath:@"unReadMessageCount" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [ws onUnReadMessag];
    }];
    [ws onUnReadMessag];
    
}

- (void)onUnReadMessag
{
    NSInteger unRead = [IMAPlatform sharedInstance].conversationMgr.unReadMessageCount;
    
    NSString *badge = nil;
    if (unRead > 0 && unRead <= 99)
    {
        badge = [NSString stringWithFormat:@"%d", (int)unRead];
    }
    else if (unRead > 99)
    {
        badge = @"99+";
    }
    
    self.navigationController.tabBarItem.badgeValue = badge;
}


- (void)onConversationChanged:(IMAConversationChangedNotifyItem *)item
{
    switch (item.type)
    {
        case EIMAConversation_SyncLocalConversation:
        {
            [self reloadData];
        }
            
            break;
        case EIMAConversation_BecomeActiveTop:
        {
            [self.tableView beginUpdates];
            [self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:item.index inSection:0] toIndexPath:[NSIndexPath indexPathForRow:item.toIndex inSection:0]];
            [self.tableView endUpdates];
        }
            break;
        case EIMAConversation_NewConversation:
        {
            [self.tableView beginUpdates];
            NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView endUpdates];
        }
            break;
        case EIMAConversation_DeleteConversation:
        {
            [self.tableView beginUpdates];
            NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            [self allLoadingCompleted];

        }
            break;
        case EIMAConversation_Connected:
        {
            [self.tableView beginUpdates];
            NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
            break;
        case EIMAConversation_DisConnected:
        {
            [self.tableView beginUpdates];
            NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
            break;
        case EIMAConversation_ConversationChanged:
        {
            [self.tableView beginUpdates];
            NSIndexPath *index = [NSIndexPath indexPathForRow:item.index inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView endUpdates];
        }
            break;
        default:
            
            break;
    }
    
}
- (void)onRefresh
{
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self reloadData];
    //    });
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    id<IMAConversationShowAble> conv = [_conversationList objectAtIndex:indexPath.row];
//    return [conv showHeight];
    return 68;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_conversationList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<IMAConversationShowAble> conv = [_conversationList objectAtIndex:indexPath.row];
    
    NSString *reuseidentifier = [conv showReuseIndentifier];
    [conv attributedDraft];
    id<IMAConversationShowAble> tempCon = [[[IMAPlatform sharedInstance].conversationMgr conversationList] objectAtIndex:indexPath.row];
    [tempCon attributedDraft];
    
    ConversationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseidentifier];
    if (!cell)
    {
        cell = [[[conv showCellClass] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseidentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell configCellWith:conv];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMAConversation *conv = [_conversationList objectAtIndex:indexPath.row];
    [[IMAPlatform sharedInstance].conversationMgr deleteConversation:conv needUIRefresh:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<IMAConversationShowAble> convable = [_conversationList objectAtIndex:indexPath.row];
    ConversationListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    IMAConversation *conv = (IMAConversation *)convable;
    switch ([convable conversationType])
    {
        case IMA_C2C:
        case IMA_Group:
        {
            IMAUser *user = [[IMAPlatform sharedInstance] getReceiverOf:conv];
            
            if (user)
            {   
//                [[AppDelegate sharedAppDelegate] pushToChatViewControllerWith:user];
                
                [conv setReadAllMsg];
                
                [cell refreshCell];
            }
            else
            {
                if ([conv type] == TIM_C2C)
                {
                    // 与陌生人聊天
                    [[IMAPlatform sharedInstance] asyncGetStrangerInfo:[conv receiver] succ:^(IMAUser *auser) {
                        
                        [ChatUserProfile sharedUser].minePhoto = [TLUser user].photo;
                        [ChatUserProfile sharedUser].friendPhoto = cell.iconUrl;
                        [ChatUserProfile sharedUser].friendNickName = cell.nickName;
                        
//                            [[AppDelegate sharedAppDelegate] pushToChatViewControllerWith:auser];
                        
                            [conv setReadAllMsg];
                            ConversationListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                            [cell refreshCell];
                        
                    } fail:^(int code, NSString *msg) {
                            DebugLog(@"Fail:--> code=%d,msg=%@,fun=%s", code, msg,__func__);
                            [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
                            [[IMAPlatform sharedInstance].conversationMgr deleteConversation:conv needUIRefresh:YES];
                    }];
                }
                else if ([conv type] == TIM_GROUP)
                {
                    // 有可能是因为退群本地信息信息未同步
                    [[IMAPlatform sharedInstance].conversationMgr deleteConversation:conv needUIRefresh:YES];
                }
                
            }
        }
            break;
            
//        case IMA_Sys_NewFriend:
//        {
//            [conv setReadAllMsg];
//            [cell refreshCell];
//            [IMAPlatform sharedInstance].contactMgr.hasNewDependency = NO;
//
//            FutureFriendsViewController *vc = [[FutureFriendsViewController alloc] init:YES];
//            [[AppDelegate sharedAppDelegate] pushViewController:vc];
//        }
//            break;
            
//        case IMA_Sys_GroupTip:
//        {
//            [conv setReadAllMsg];
//            [cell refreshCell];
//            [IMAPlatform sharedInstance].contactMgr.hasNewDependency = NO;
//            GroupSystemMsgViewController *vc = [[GroupSystemMsgViewController alloc] init];
//            [[AppDelegate sharedAppDelegate] pushViewController:vc];
//        }
//            break;
            
        case IMA_Connect:
        default:
            break;
    }
    
}


@end
