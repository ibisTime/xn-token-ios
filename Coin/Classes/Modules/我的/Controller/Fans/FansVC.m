//
//  FansVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "FansVC.h"

#import "FansModel.h"

#import "FansTableView.h"

@interface FansVC ()

//暂无交易
@property (nonatomic, strong) UIView *placeHolderView;
//受信任的
@property (nonatomic, strong) FansTableView *tableView;
//关注列表
@property (nonatomic, strong) NSMutableArray <FansModel *>*fans;

@end

@implementation FansVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"受信任的";
    
    //暂无受信任的人
    [self initPlaceHolderView];
    //tableview
    [self initTableView];
    //获取关注列表
    [self requestFansList];
    
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[FansTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = self.placeHolderView;
    
//    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *fansIV = [[UIImageView alloc] init];
    
    fansIV.image = kImage(@"暂无订单");
    
    fansIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:fansIV];
    [fansIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@90);
        
    }];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = @"暂无信任的人";
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(fansIV.mas_bottom).offset(20);
        make.centerX.equalTo(fansIV.mas_centerX);
        
    }];
    
}

#pragma mark - Data
- (void)requestFansList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805115";
    helper.start = 1;
    helper.limit = 20;
    helper.parameters[@"userId"] = [TLUser user].userId;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[FansModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray <FansModel *>*objs, BOOL stillHave) {
            
            weakSelf.fans = objs;
            
            weakSelf.tableView.fans = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView beginRefreshing];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.fans = objs;
            
            weakSelf.tableView.fans = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
