//
//  TLFastvc.m
//  Coin
//
//  Created by shaojianfei on 2018/7/5.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLFastvc.h"

@interface TLFastvc ()
@property (nonatomic ,strong) TLPlaceholderView *placeholderView;

@end

@implementation TLFastvc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;

    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = kWhiteColor;
    [self.view addSubview:backView];
    
    UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(0, 12, SCREEN_WIDTH, 28) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(24) textColor:kHexColor(@"#0054ff")];
    nameLabel.text = [LangSwitcher switchLang:@"闪兑" key:nil];
    [self.view addSubview:nameLabel];
    
    UILabel *promptLabel = [UILabel labelWithFrame:CGRectMake(0, nameLabel.yy + 22, SCREEN_WIDTH, 28) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(24) textColor:kHexColor(@"#0054ff")];
    promptLabel.text = [LangSwitcher switchLang:@"敬请期待!" key:nil];
    [self.view addSubview:promptLabel];
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, promptLabel.yy + 35, SCREEN_WIDTH - 70, SCREEN_WIDTH - 70)];
    iconImage.image = kImage(@"闪兑icon");
    [self.view addSubview:iconImage];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navigationwhiteColor];
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

@end
