//
//  WhetherBackupVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/16.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "WhetherBackupVC.h"
#import "CreateWalletVC.h"
@interface WhetherBackupVC ()

@end

@implementation WhetherBackupVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navigationTransparentClearColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    
    [self.view addSubview:backImage];
    
    UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(0, 165 - 64 - 64 + kNavigationBarHeight, SCREEN_WIDTH, 20) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(16) textColor:kWhiteColor];
    nameLabel.text = [LangSwitcher switchLang:@"备份钱包助记词" key:nil];
    [self.view addSubview:nameLabel];
    
    UILabel *contentLabel = [UILabel labelWithFrame:CGRectMake(22.5, nameLabel.yy + 25, SCREEN_WIDTH - 45, 0) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kWhiteColor];
    contentLabel.attributedText= [UserModel ReturnsTheDistanceBetween:[LangSwitcher switchLang:@"已为您创建BTC,ETH,WAN等N个主链币种钱包地址\nTheia钱包支持一套助记词管理多个主链币种钱包地址" key:nil]];
    contentLabel.numberOfLines = 0;
    [contentLabel sizeToFit];
    contentLabel.frame = CGRectMake(22.5, nameLabel.yy + 20, SCREEN_WIDTH - 45, contentLabel.height);
    [self.view addSubview:contentLabel];
    
    
    UIButton *JustMomentBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"稍候备份" key:nil] titleColor:kHexColor(@"d6d5d5") backgroundColor:kClearColor titleFont:16];
    JustMomentBtn.frame = CGRectMake(40, contentLabel.yy + 81, SCREEN_WIDTH/2 - 50, 50);
    [JustMomentBtn addTarget:self action:@selector(JustMoment) forControlEvents:(UIControlEventTouchUpInside)];
    JustMomentBtn.titleLabel.font = HGboldfont(16);
    kViewBorderRadius(JustMomentBtn, 10, 1, kHexColor(@"d6d5d5"));
    [self.view addSubview:JustMomentBtn];
    
    UIButton *startBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"开始备份" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:16];
    startBtn.frame = CGRectMake(SCREEN_WIDTH/2 + 10, contentLabel.yy + 81, SCREEN_WIDTH/2 - 50, 50);
    [startBtn setBackgroundImage:kImage(@"圆角矩形2拷贝2") forState:(UIControlStateNormal)];
    [startBtn addTarget:self action:@selector(start) forControlEvents:(UIControlEventTouchUpInside)];
    kViewRadius(startBtn, 10);
    startBtn.titleLabel.font = HGboldfont(16);
    [self.view addSubview:startBtn];
}

-(void)JustMoment
{
    
}

-(void)start
{
    CreateWalletVC *vc = [CreateWalletVC new];
    [self.navigationController pushViewController:vc animated:YES];
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
