//
//  TLWalletVC.m
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLWalletVC.h"

#import "CoinHeader.h"

#import "WalletHeaderView.h"
#import "WalletTableView.h"

#import "CurrencyModel.h"

#import "RechargeCoinVC.h"

@interface TLWalletVC ()<RefreshDelegate>

@property (nonatomic, strong) WalletHeaderView *headerView;

@property (nonatomic, strong) WalletTableView *tableView;

@property (nonatomic, strong) NSArray <CurrencyModel *>*currencys;

@end

@implementation TLWalletVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //修改状态栏颜色
    NSString *version = [UIDevice currentDevice].systemVersion;
    
    if ([version compare:@"9.0"] != NSOrderedAscending) {
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
    } else {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"钱包";
    
    //tableView
    [self initTableView];
    
    //列表查询我的币种
    [self getMyCurrencyList];
    
    [self.tableView beginRefreshing];
}

#pragma mark - Init

- (WalletHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[WalletHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150 + kStatusBarHeight + 50)];

        _headerView.rate = @"1";
    }
    return _headerView;
}

- (void)initTableView {
    
    self.tableView = [[WalletTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Data
- (void)getMyCurrencyList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"802503";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.isList = YES;
    helper.showView = self.view;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[CurrencyModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.currencys = objs;
            
            weakSelf.tableView.currencys = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
}

#pragma mark - RefreshDelegate
- (void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index {
    
    NSInteger tag = (sender.tag - 1200)%100;
    
    switch (tag) {
        case 0:
        {
            RechargeCoinVC *coinVC = [RechargeCoinVC new];
            
            [self.navigationController pushViewController:coinVC animated:YES];
            
        }break;
          
        case 1:
        {
            
        }break;
            
        case 2:
        {
            
        }break;
            
        default:
            break;
    }
}

@end
