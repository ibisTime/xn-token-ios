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
@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *nameLable;

@property (nonatomic, strong) UIButton *showView;

@end

@implementation JoinMineVc
-(UIButton *)showView
{
    
    if (!_showView) {
        _showView = [[UIButton alloc] init];
        [_showView setBackgroundColor:kBlackColor];
        [_showView setTitleColor:kWhiteColor forState:UIControlStateNormal];
        
    }
    return _showView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self requestInfo];

    self.nameLable = [[UILabel alloc]init];
    self.nameLable.text = [LangSwitcher switchLang:@"加入社群" key:nil];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = Font(16);
    self.nameLable.textColor = kTextBlack;
    self.navigationItem.titleView = self.nameLable;


//    [self initModels];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}


//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kHexColor(@"#0848DF");
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}
- (void)requestInfo
{
    
    TLNetworking *http = [[TLNetworking alloc] init];
    
    http.code = @"660919";
    http.showView = self.view;
    http.parameters[@"type"] = @"followUs";
    
    [http postWithSuccess:^(id responseObject) {
        self.models = [JoinModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
//        NSLog(@"%@",responseObject);
        self.tableView.models = self.models;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
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
//        mode2.name = @"Telegram";
//         mode2.content = @"https://t.me/THAWallet_cn";
//        JoinModel *mode3 = [[JoinModel alloc] init];
//        mode3.name = @"QTelegram 英文社区";
//        mode3.content = @"https://t.me/THAWallet cn";
//        JoinModel *mode4 = [[JoinModel alloc] init];
//        mode4.name = @"新浪微博:";
//        mode4.content = @"http://weibo.com/THAWallet";
        JoinModel *mode5 = [[JoinModel alloc] init];

//        mode5.name = @"Twitter";
//        mode5.content = @"@THAWallet";
//        JoinModel *mode6 = [[JoinModel alloc] init];
//
//        mode6.name = @"Facebook";
//        mode6.content = @"@THAWallet";
//    JoinModel *mode7 = [[JoinModel alloc] init];
//
//    mode7.name = @"Wechat";
//    mode7.content = @"THA-Wallet";
//        self.models = [NSMutableArray array];
//        [self.models addObject:mode6];
//        [self.models addObject:mode5];
//
//        [self.models addObject:mode2];
//
//        [self.models addObject:mode7];

        self.tableView.models = self.models;
        [self.tableView beginRefreshing];
}

- (void)initTableView {
    
//    self.bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    self.bgImage.contentMode = UIViewContentModeScaleToFill;
//    self.bgImage.userInteractionEnabled = YES;
//    self.bgImage.image = kImage(@"我的 背景");
//    [self.view  addSubview:self.bgImage];
    
//    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
    //
//    self.backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    self.backButton.frame = CGRectMake(15, kStatusBarHeight+5, 40, 40);
//    [self.backButton setImage:kImage(@"返回1-1") forState:(UIControlStateNormal)];
//    [self.backButton addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.bgImage addSubview:self.backButton];
//    self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(54, kStatusBarHeight+5, kScreenWidth - 108, 44)];
//    self.nameLable.text = [LangSwitcher switchLang:@"加入社群" key:nil];
//    self.nameLable.textAlignment = NSTextAlignmentCenter;
//    self.nameLable.font = Font(16);
//    self.nameLable.textColor = kTextBlack;
//    [self.bgImage addSubview:self.nameLable];

    self.tableView = [[JoinMineTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SCREEN_HEIGHT - kNavigationBarHeight) style:UITableViewStylePlain];
    
    //    self.tableView.tableHeaderView = self.headerView;
    self.tableView.refreshDelegate = self;
    self.tableView.backgroundColor = kWhiteColor;
    //    [self.tableView adjustsContentInsets];
    [self.view addSubview:self.tableView];
    //    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.headerView.mas_bottom);
    //    }];
//    CoinWeakSelf;
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

- (void)buttonClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        
        
        
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        NSString *address ;
        address = self.tableView.models[indexPath.row].cvalue;
        pasteBoard.string = address;
        
        if (pasteBoard == nil) {
            
            [self.view addSubview:self.showView];
            [self.showView setTitle:[LangSwitcher switchLang:@"复制失败, 请重新复制" key:nil] forState:UIControlStateNormal];
            self.showView.hidden = NO;

            [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
             
                make.centerX.equalTo(self.tableView.mas_centerX);
                make.centerY.equalTo(self.tableView.mas_centerY);
                make.width.equalTo(@114);
                make.height.equalTo(@53);

            }];
//            [TLAlert alertWithError:@"复制失败, 请重新复制"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.showView.hidden = YES;
                [self.showView removeFromSuperview];
            });
        } else {
            
            
            
            [self.view addSubview:self.showView];
            self.showView.hidden = NO;

            [self.showView setTitle:[LangSwitcher switchLang:@"复制成功" key:nil] forState:UIControlStateNormal];
            [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.equalTo(self.tableView.mas_centerX);
                make.centerY.equalTo(self.tableView.mas_centerY);
                make.width.equalTo(@114);
                make.height.equalTo(@53);
                
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.showView.hidden = YES;
                [self.showView removeFromSuperview];
            });
            
//            [TLAlert alertWithSucces:[LangSwitcher switchLang:@"复制成功" key:nil]];
            
        }
        
        

    
    
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
