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
    self.title = [LangSwitcher switchLang:@"加入社群" key:nil];
    [super viewDidLoad];
    [self initTableView];
    [self initModels];
    // Do any additional setup after loading the view.
}
- (void)initModels
{
//        JoinModel *model = [[JoinModel alloc] init];
//        model.name = @"官网";
//        model.content = @"@thachain.org";
//        JoinModel *model1 = [[JoinModel alloc] init];
//        model1.name = @"邮箱地址";
//        model1.content = @"@official@thachain.org";
        JoinModel *mode2 = [[JoinModel alloc] init];
        mode2.name = @"Telegram";
         mode2.content = @"https://t.me/THAWallet.cn";
//        JoinModel *mode3 = [[JoinModel alloc] init];
//        mode3.name = @"QTelegram 英文社区";
//        mode3.content = @"https://t.me/THAWallet cn";
//        JoinModel *mode4 = [[JoinModel alloc] init];
//        mode4.name = @"新浪微博:";
//        mode4.content = @"http://weibo.com/THAWallet";
        JoinModel *mode5 = [[JoinModel alloc] init];

        mode5.name = @"Twitter";
        mode5.content = @"@ThAWallet";
        JoinModel *mode6 = [[JoinModel alloc] init];

        mode6.name = @"Facebook";
        mode6.content = @"@ThAWallet";
    JoinModel *mode7 = [[JoinModel alloc] init];
    
    mode7.name = @"Wechat";
    mode7.content = @"@THA-Wallet";
        self.models = [NSMutableArray array];
    
        [self.models addObject:mode2];
    
        [self.models addObject:mode5];
        [self.models addObject:mode6];
        [self.models addObject:mode7];

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

-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
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
