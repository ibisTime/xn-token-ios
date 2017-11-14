//
//  SystemNoticeVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "SystemNoticeVC.h"

#import "CoinHeader.h"
#import "AppConfig.h"
#import "TLPlaceholderView.h"

#import "NoticeCell.h"

#import "NoticeModel.h"

@interface SystemNoticeVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray <NoticeModel *> *notices;

@property (nonatomic,strong) TLTableView *tableView;

@end

@implementation SystemNoticeVC

static NSString *identifier = @"NoticeCellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView];
    //获取消息列表
    [self requrstNoticeList];

}

#pragma mark - Init

- (void)initTableView {
    
    self.title = @"系统公告";
    
    self.tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)
                                                       delegate:self
                                                     dataSource:self];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无消息"];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tableView beginRefreshing];
}

#pragma mark - Data

- (void)requrstNoticeList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"804040";
    helper.tableView = self.tableView;
    helper.parameters[@"token"] = [TLUser user].token;
    helper.parameters[@"channelType"] = @"4";
    
    helper.parameters[@"pushType"] = @"41";
    helper.parameters[@"toKind"] = @"4";
    //    1 立即发 2 定时发
    //    pageDataHelper.parameters[@"smsType"] = @"1";
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"10";
    helper.parameters[@"status"] = @"1";
    helper.parameters[@"fromSystemCode"] = [AppConfig config].systemCode;
    
    
    //0 未读 1 已读 2未读被删 3 已读被删
    //    pageDataHelper.parameters[@"status"] = @"0";
    //    pageDataHelper.parameters[@"dateStart"] = @""; //开始时间
    [helper modelClass:[NoticeModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.notices = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.notices = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.notices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.notice = self.notices[indexPath.row];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.notices[indexPath.row].cellHeight;
    
}

@end
