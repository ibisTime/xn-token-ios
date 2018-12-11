//
//  AddressBookVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/12/10.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "AddressBookVC.h"

@interface AddressBookVC ()

@end

@implementation AddressBookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    
    UILabel *titleText = [[UILabel alloc] init];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textColor=kTextColor;
    [titleText setFont:[UIFont systemFontOfSize:17.0]];
    [titleText setText:[LangSwitcher switchLang:@"通讯录" key:nil]];
    self.navigationItem.titleView=titleText;
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 106 - 64, SCREEN_WIDTH - 70, (SCREEN_WIDTH - 70)/640*430)];
    iconImage.image = kImage(@"通讯录icon");
    [self.view addSubview:iconImage];
    
    UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(0, iconImage.yy + 43, SCREEN_WIDTH, 18) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:[UIColor blackColor]];
    nameLabel.text = [LangSwitcher switchLang:@"正在紧张开发中..." key:nil];
    [self.view addSubview:nameLabel];
    
    UILabel *promptLabel = [UILabel labelWithFrame:CGRectMake(0, nameLabel.yy + 10, SCREEN_WIDTH, 28) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(24) textColor:kHexColor(@"#0054ff")];
    promptLabel.text = [LangSwitcher switchLang:@"敬请期待!" key:nil];
    [self.view addSubview:promptLabel];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = item;
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

@end
