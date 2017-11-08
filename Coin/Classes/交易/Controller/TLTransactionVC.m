//
//  TLTransactionVC.m
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLTransactionVC.h"
#import "TLTableView.h"
#import "TLUIHeader.h"
#import "CoinChangeView.h"
#import "TLBannerView.h"

@interface TLTransactionVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TLTableView *txTableView;
@end

@implementation TLTransactionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"交易";
    
    [self navBarUI];
    [self setUpUI];
    
    
}

#pragma mark- 交易搜索
- (void)search {
    
}



- (void)navBarUI {
    
    //1.左边切换
    CoinChangeView *coinChangeView = [[CoinChangeView alloc] init];
    coinChangeView.title = @"ETH";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:coinChangeView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        coinChangeView.title = @"ETH+ETC";

    });
    
    //2.右边搜索
    UIImage *searchImg = [UIImage imageNamed:@"交易_搜索"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:searchImg style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    //3.中间切换
    
}

- (void)setUpUI {
    
    self.txTableView = [TLTableView tableViewWithframe:CGRectZero delegate:self dataSource:self];
    [self.view addSubview:self.txTableView];
    self.txTableView.backgroundColor = [UIColor orangeColor];
     
    [self.txTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
   //1.banner
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 160)];
    self.txTableView.tableHeaderView = bannerView;
    
    
   //2.下部
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        
    }
    
    return cell;
}

@end
