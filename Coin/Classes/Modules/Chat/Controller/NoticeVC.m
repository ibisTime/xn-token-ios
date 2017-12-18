//
//  NoticeVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/10.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "NoticeVC.h"
#import "NoticeTableView.h"

@interface NoticeVC ()
{
@protected
    
    __weak CLSafeMutableArray   *_conversationList;
}

@property (nonatomic, strong) NoticeTableView *tableView;


@end

@implementation NoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    //获取消息列表
    [self getNoticeList];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[NoticeTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Events
//- (void)
#pragma mark - Data
- (void)getNoticeList {
    
    IMAConversationManager *mgr = [IMAPlatform sharedInstance].conversationMgr;
    _conversationList = [mgr conversationList];
    self.tableView.conversationList = _conversationList;
    [self.tableView reloadData];
    
}

@end
