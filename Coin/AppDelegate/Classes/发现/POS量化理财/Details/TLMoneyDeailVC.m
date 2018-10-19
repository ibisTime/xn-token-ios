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


@property (nonatomic , strong)TLMoneyDetailsTableView *tableView;

@property (nonatomic , strong)TLMoneyDetailsHeadView *headView;

@end

@implementation TLMoneyDeailVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;


}
//
//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


- (void)initTableView {
    self.tableView = [[TLMoneyDetailsTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50 ) style:(UITableViewStyleGrouped)];
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


-(void)LoadData
{
    TLNetworking *http = [[TLNetworking alloc] init];
    http.showView = self.view;
    http.code = @"625514";
    http.parameters[@"code"] = self.moneyModel.code;
    http.parameters[@"userId"] = [TLUser user].userId;
    [http postWithSuccess:^(id responseObject) {

        self.tableView.moneyModel = [TLtakeMoneyModel mj_objectWithKeyValues:responseObject[@"data"]];
        self.moneyModel = [TLtakeMoneyModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self.tableView reloadData];

    } failure:^(NSError *error) {

    }];
}


//购买
-(void)continBtnClick
{

    PosBuyVC *vc= [PosBuyVC new];
    vc.moneyModel = self.moneyModel;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)refreshTableView:(TLTableView *)refreshTableview scrollView:(UIScrollView *)scroll
{
    CGFloat height = (235 - 64 + kNavigationBarHeight);
////    导航栏
//    if (self.tableView.contentOffset.y <= (235 - 64)) {
//        [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:9/255.0 green:90/255.0 blue:221/255.0 alpha:self.tableView.contentOffset.y / (235 - 64)]] forBarMetrics:UIBarMetricsDefault];
//    }else
//    {
//        [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:9/255.0 green:90/255.0 blue:221/255.0 alpha:1]] forBarMetrics:UIBarMetricsDefault];
//    }
//
//    // 获取到tableView偏移量
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


//-(UIImage *)imageWithBgColor:(UIColor *)color {
//
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}


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
    continBtn.hidden = YES;
    [self.view addSubview:continBtn];


    NSString *avilAmount = [CoinUtil convertToRealCoin:self.moneyModel.avilAmount coin:self.moneyModel.symbol];
    NSString *increAmount = [CoinUtil convertToRealCoin:self.moneyModel.increAmount coin:self.moneyModel.symbol];
    if ([avilAmount floatValue] / [increAmount floatValue] < 1 || [avilAmount floatValue] == 0 || [increAmount floatValue] == 0) {
        continBtn.hidden = YES;
        self.tableView.frame = CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if(![self.moneyModel.status isEqualToString:@"5"])
    {
        continBtn.hidden = YES;
        self.tableView.frame = CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT );
    }else
    {
        continBtn.hidden = NO;
        self.tableView.frame = CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 50);
    }

    [self LoadData];
}





@end
