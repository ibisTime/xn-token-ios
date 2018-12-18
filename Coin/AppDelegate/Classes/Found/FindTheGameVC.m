//
//  FindTheGameVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/12/4.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "FindTheGameVC.h"
#import "FindTheGameTableView.h"
#import "StrategyModel.h"
#import "HTMLStrVC.h"
#import "GeneralWebView.h"
#import "StrategyVC.h"
@interface FindTheGameVC ()<RefreshDelegate>

@property (nonatomic , strong)FindTheGameTableView *tableView;
@property (nonatomic , strong)NSMutableArray <StrategyModel *>*model;
@end

@implementation FindTheGameVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = item;
    //    self.navigationController.navigationBar.shadowImage = [UIImage new];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = kWhiteColor;
    [self.view addSubview:backView];
    
    [self initTableView];
    [self loadData];
    self.view.backgroundColor = kWhiteColor;
    
    
}

-(void)initTableView
{
    self.tableView = [[FindTheGameTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight ) style:UITableViewStyleGrouped];
    self.tableView.refreshDelegate = self;
    if ([TLUser isBlankString:self.url] == YES) {
        self.tableView.GameModel = self.GameModel;
    }
    
    [self.view addSubview:self.tableView];
}

-(void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index
{
    GeneralWebView *vc = [GeneralWebView new];
    vc.URL = _GameModel.url;
    [self showViewController:vc sender:self];
}

-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        
        StrategyVC *vc = [StrategyVC new];
        vc.strategyID = self.model[indexPath.row].ID;
//        vc.URL = ;
        [self showViewController:vc sender:self];
    }
}

-(void)loadData
{
    __weak typeof(self) weakSelf = self;
    
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.tableView = self.tableView;
    
    helper.code = @"625466";
    if ([TLUser isBlankString:self.url] == NO) {
        helper.parameters[@"dappId"] = self.url;
    }else
    {
        helper.parameters[@"dappId"] = _GameModel.ID;
    }
    
//    helper.parameters[@"address"] = self.currency.address;
    [helper modelClass:[StrategyModel class]];
    
    [self.tableView addRefreshAction:^{
        [weakSelf details];
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            if (objs.count == 0) {
                [weakSelf addPlaceholderView];
                
            }
            
            weakSelf.model = objs;
            
            weakSelf.tableView.model = weakSelf.model;
            
//            weakSelf.tableView.ustds = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];
            
        }];
    }];
    
    [self.tableView beginRefreshing];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            if (weakSelf.tl_placeholderView.superview != nil) {
                
                [weakSelf removePlaceholderView];
            }
            
            weakSelf.model = objs;
            
            weakSelf.tableView.model = weakSelf.model;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];
            
        }];
        
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
    
}

-(void)details
{
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625457";
    http.parameters[@"id"] = self.GameModel.ID;
//    http.parameters[@"start"] = [NSString stringWithFormat:@"%ld",start];
//    http.parameters[@"limit"] = @"10"  ;
    http.showView = self.view;
    [http postWithSuccess:^(id responseObject) {
        
        self.GameModel = [FindTheGameModel mj_objectWithKeyValues:responseObject[@"data"]];
        self.tableView.GameModel = self.GameModel;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

@end
