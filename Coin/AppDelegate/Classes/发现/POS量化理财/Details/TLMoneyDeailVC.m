//
//  TLMoneyDeailVC.m
//  Coin
//
//  Created by shaojianfei on 2018/8/16.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLMoneyDeailVC.h"
#import "TLTopMoneyView.h"
#import "TLUIHeader.h"
#import "CoinUtil.h"
#import "CurrencyModel.h"
#import "RechargeCoinVC.h"
//#import "TLTextField.h"
#import "AssetPwdView.h"
#import "TLPwdRelatedVC.h"
#import "NSString+Check.h"
#import "PayModel.h"
//#import "NSString+Date.h"
#import "TLMyRecordVC.h"

#import "TLMoneyDetailsTableView.h"
#import "PosBuyVC.h"

#import "TLMoneyDetailsHeadView.h"
@interface TLMoneyDeailVC () <RefreshDelegate,UIScrollViewDelegate>

//@property (nonatomic ,strong) UIScrollView *contentView;
//@property (nonatomic ,strong) UIView *titleView;
//@property (nonatomic ,strong) TLTopMoneyView *tit;

@property (nonatomic , strong)TLMoneyDetailsTableView *tableView;

@property (nonatomic , strong)TLMoneyDetailsHeadView *headView;

@end

@implementation TLMoneyDeailVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;


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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


- (void)initTableView {
    self.tableView = [[TLMoneyDetailsTableView alloc] initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 50) style:(UITableViewStyleGrouped)];
    self.tableView.refreshDelegate = self;
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.moneyModel = self.moneyModel;
    [self.view addSubview:self.tableView];

    TLMoneyDetailsHeadView *headView = [[TLMoneyDetailsHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 235 - 64 + kNavigationBarHeight)];
    headView.backgroundColor = RGB(41, 127, 237);
    self.tableView.tableHeaderView = headView;
    self.headView = headView;
    self.headView.moneyModel = self.moneyModel;
}



-(void)continBtnClick
{
    PosBuyVC *vc= [PosBuyVC new];
    vc.moneyModel = self.moneyModel;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)refreshTableView:(TLTableView *)refreshTableview scrollView:(UIScrollView *)scroll
{
    CGFloat height = (235 - 64 + kNavigationBarHeight);
    // 获取到tableView偏移量
    CGFloat Offset_y = scroll.contentOffset.y;
    // 下拉 纵向偏移量变小 变成负的
    if ( Offset_y < 0) {
        // 拉伸后图片的高度
        CGFloat totalOffset = height - Offset_y;
        // 图片放大比例
        CGFloat scale = totalOffset / height;
        CGFloat width = SCREEN_WIDTH;
        // 拉伸后图片位置
        self.headView.backImage.frame = CGRectMake(-(width * scale - width) / 2, Offset_y, width * scale, totalOffset);
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    [self initTableView];

    UILabel *nameLable = [[UILabel alloc]init];
    nameLable.text = self.moneyModel.name;
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(18);
    nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = nameLable;

    UIButton *continBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"购买" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:18];
    [continBtn setBackgroundImage:kImage(@"Rectangle 3") forState:(UIControlStateNormal)];
    continBtn.frame = CGRectMake(0, SCREEN_HEIGHT - 50 - kNavigationBarHeight, SCREEN_WIDTH, 50);
    [continBtn addTarget:self action:@selector(continBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:continBtn];


    

//    [self initCustomView];
//    [self LoadData];
//    self.tit.model = self.moneyModel;
//
//    self.pronameDetail.text = self.moneyModel.name;
//
//    self.symblename.text = self.moneyModel.symbol;
//    self.backdetailLab.text = [LangSwitcher switchLang:@"期满自动转入个人账户" key:nil];
//    AssetPwdView *pwdView =[[AssetPwdView alloc] init];
//    pwdView.isPay = YES;
//    self.pwdView = pwdView;
//    pwdView.HiddenBlock = ^{
//        self.pwdView.hidden = YES;
//        [self.pwdView endEditing:YES];
//        [self.view endEditing:YES];
//        //        [self.pwdView removeFromSuperview];
//    };
//    CoinWeakSelf;
//    self.pwdView.forgetBlock = ^{
//        weakSelf.pwdView.hidden = YES;
//        weakSelf.view2.hidden = YES;
//        TLPwdRelatedVC *vc  = [[TLPwdRelatedVC alloc] initWithType:TLPwdTypeTradeReset];
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//        vc.success = ^{
//            weakSelf.pwdView.hidden = NO;
//            weakSelf.view2.hidden = NO;
//        };
//
//    };
//    pwdView.hidden = YES;
//    pwdView.frame = self.view.bounds;
//
//    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
//    [keyWindow addSubview:pwdView];
//
    
//
//
    
}


-(void)LoadData
{

}



@end
