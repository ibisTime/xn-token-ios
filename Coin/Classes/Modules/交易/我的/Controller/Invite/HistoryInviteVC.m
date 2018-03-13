//
//  HistoryInviteVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "HistoryInviteVC.h"

#import "HistoryFriendCell.h"
#import "TLTableView.h"
#import "TLPlaceholderView.h"
#import "InviteModel.h"
#import "HomePageVC.h"
#import "TLProgressHUD.h"

@interface HistoryInviteVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TLTableView *tableView;

@property (nonatomic, strong) NSArray <InviteModel *>*friends;
//暂无推荐历史
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation HistoryInviteVC

static NSString *identifierCell = @"HistoryFriendCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LangSwitcher switchLang:@"推荐历史" key:nil];
    
    [self initPlaceHolderView];
    
    [self initTableView];
    
    [self requestFriendList];
}

#pragma mark - Init
- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *inviteIV = [[UIImageView alloc] init];
    
    inviteIV.image = kImage(@"暂无订单");
    
    [self.placeHolderView addSubview:inviteIV];
    [inviteIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@90);
        
    }];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = [LangSwitcher switchLang:@"暂无推荐历史" key:nil];
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(inviteIV.mas_bottom).offset(20);
        make.centerX.equalTo(inviteIV.mas_centerX);
        
    }];
}

- (void)initTableView {

    self.tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) delegate:self dataSource:self];
    
    self.tableView.placeHolderView = self.placeHolderView;
    
    [self.tableView registerClass:[HistoryFriendCell class] forCellReuseIdentifier:identifierCell];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Data
- (void)requestFriendList {

    CoinWeakSelf;
    
    [TLProgressHUD showWithStatus:nil];
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"805120";
    helper.parameters[@"userReferee"] = [TLUser user].userId;
    helper.tableView = self.tableView;
    [helper modelClass:[InviteModel class]];
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        [TLProgressHUD dismiss];

        weakSelf.friends = objs;
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.friends = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //
    HomePageVC *vc = [[HomePageVC alloc] init];
    
    //传入userId
    vc.userId = self.friends[indexPath.row].userId;
    
    //
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoryFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.inviteModel = self.friends[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
