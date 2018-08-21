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
//暂无历史汇率
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation SystemNoticeVC

static NSString *identifier = @"NoticeCellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"系统公告";

    //暂无公告
    [self initPlaceHolderView];
    
    [self initTableView];
    //获取消息列表
    [self requrstNoticeList];

}

#pragma mark - Init

- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *noticeIV = [[UIImageView alloc] init];
    
    noticeIV.image = kImage(@"暂无订单");
    
    [self.placeHolderView addSubview:noticeIV];
    [noticeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@90);
        
    }];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = @"暂无公告";
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(noticeIV.mas_bottom).offset(20);
        make.centerX.equalTo(noticeIV.mas_centerX);
        
    }];
}

- (void)initTableView {
    
    self.tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)
                                            delegate:self
                                          dataSource:self];
    
    self.tableView.placeHolderView = self.placeHolderView;
    
    [self.tableView registerClass:[NoticeCell class] forCellReuseIdentifier:identifier];
    
    [self.view addSubview:self.tableView];
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
    helper.parameters[@"toKind"] = @"C";
    //    1 立即发 2 定时发
    //    pageDataHelper.parameters[@"smsType"] = @"1";
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"20";
    helper.parameters[@"status"] = @"1";
    helper.parameters[@"fromSystemCode"] = [AppConfig config].systemCode;
    
    
    //0 未读 1 已读 2未读被删 3 已读被删
    //    pageDataHelper.parameters[@"status"] = @"0";
    //    pageDataHelper.parameters[@"dateStart"] = @""; //开始时间
    [helper modelClass:[NoticeModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray <NoticeModel *>*objs, BOOL stillHave) {
            
            weakSelf.notices = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView beginRefreshing];

    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray <NoticeModel *>*objs, BOOL stillHave) {
            
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.notices[indexPath.row].cellHeight;
    
}

@end
