//
//  JoinMineVc.m
//  Coin
//
//  Created by shaojianfei on 2018/6/7.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "JoinMineVc.h"
#import "JoinMineTableView.h"
#import "JoinModel.h"
@interface JoinMineVc ()<RefreshDelegate>
@property (nonatomic , strong) JoinMineTableView *tableView;
@property (nonatomic , strong) NSMutableArray <JoinModel *>*models;

@end

@implementation JoinMineVc

- (void)viewDidLoad {
    self.title = @"加入社群";
    [super viewDidLoad];
    [self initTableView];
    [self initModels];
    // Do any additional setup after loading the view.
}
- (void)initModels
{
        JoinModel *model = [[JoinModel alloc] init];
        model.name = @"Facebook";
        model.content = @"@thahoffchaj";
        JoinModel *model1 = [[JoinModel alloc] init];
        model1.name = @"Twitter";
        model1.content = @"@thahoffchaj";
        JoinModel *mode2 = [[JoinModel alloc] init];
        mode2.name = @"Telegram";
        mode2.content = @"@thahoffchaj";
        JoinModel *mode3 = [[JoinModel alloc] init];
        mode3.name = @"QQ Group";
        mode3.content = @"@88329343";
        JoinModel *mode4 = [[JoinModel alloc] init];
        mode4.name = @"Wechat";
        mode4.content = @"@88493384";
    
        self.models = [NSMutableArray array];
        [self.models addObject:model];
        [self.models addObject:model1];
        [self.models addObject:mode2];
        [self.models addObject:mode3];
        [self.models addObject:mode4];

        self.tableView.models = self.models;
        [self.tableView beginRefreshing];
}
- (void)initTableView {
    
    
    
    self.tableView = [[JoinMineTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStylePlain];
    
    //    self.tableView.tableHeaderView = self.headerView;
    self.tableView.refreshDelegate = self;
    //    [self.tableView adjustsContentInsets];
    [self.view addSubview:self.tableView];
    //    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.headerView.mas_bottom);
    //    }];
    CoinWeakSelf;
    //    self.tableView.selectBlock = ^(NSInteger inter) {
    //        NSLog(@"%ld",inter);
    //        WallAccountVC *accountVC= [[WallAccountVC alloc] init];
    //        accountVC.currency = weakSelf.currencys[inter];
    //        accountVC.billType = CurrentTypeAll;
    //        [weakSelf.navigationController pushViewController:accountVC animated:YES];
    //
    //
    //    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
