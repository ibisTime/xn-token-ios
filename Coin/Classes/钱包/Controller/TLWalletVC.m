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

@interface TLWalletVC ()

@property (nonatomic, strong) WalletHeaderView *headerView;

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
}

#pragma mark - Init

- (WalletHeaderView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[WalletHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150 + kStatusBarHeight)];

    }
    return _headerView;
}

- (void)initTableView {
    
    
}

@end
