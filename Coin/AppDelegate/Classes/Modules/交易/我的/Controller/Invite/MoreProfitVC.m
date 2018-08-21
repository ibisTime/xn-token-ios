//
//  MoreProfitVC.m
//  Coin
//
//  Created by haiqingzheng on 2018/3/24.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "MoreProfitVC.h"

#import "MoreProfitCell.h"
#import "TLTableView.h"
#import "TLPlaceholderView.h"
#import "ProfitModel.h"
#import "HomePageVC.h"
#import "TLProgressHUD.h"

@interface MoreProfitVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TLTableView *tableView;

@property (nonatomic, strong) NSArray <ProfitModel *>*profits;
//暂无收益
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation MoreProfitVC

static NSString *identifierCell = @"MoreProfitCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LangSwitcher switchLang:@"提成收益" key:nil];
    
    [self initPlaceHolderView];
    
    [self initTableView];
    
    [self requestProfitList];
}

#pragma mark - Init
- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *inviteIV = [[UIImageView alloc] init];
    
    inviteIV.image = kImage(@"暂无收益");
    
    [self.placeHolderView addSubview:inviteIV];
    [inviteIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@90);
        
    }];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = [LangSwitcher switchLang:@"暂无收益" key:nil];
    
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
    
    self.tableView.allowsSelection = NO;
    
    [self.tableView registerClass:[MoreProfitCell class] forCellReuseIdentifier:identifierCell];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Data
- (void)requestProfitList {
    
    CoinWeakSelf;
    
    [TLProgressHUD showWithStatus:nil];
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"805124";
    helper.isList = YES;
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.tableView = self.tableView;
    [helper modelClass:[ProfitModel class]];
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        [TLProgressHUD dismiss];
        
        weakSelf.profits = objs;
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
    }];
        
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.profits.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MoreProfitCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.profitModel = self.profits[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
