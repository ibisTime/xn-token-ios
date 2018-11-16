//
//  WhetherBackupVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/16.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "WhetherBackupVC.h"

@interface WhetherBackupVC ()

@end

@implementation WhetherBackupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    [self.view addSubview:backImage];
    
    UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(0, 165 - 64 - 64 + kNavigationBarHeight, SCREEN_WIDTH, 20) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(16) textColor:kWhiteColor];
    nameLabel.text = [LangSwitcher switchLang:@"备份钱包助记词" key:nil];
    [self.view addSubview:nameLabel];
    
    UILabel *contentLabel = [UILabel labelWithFrame:CGRectMake(30, nameLabel.yy + 25, SCREEN_WIDTH - 60, 0) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kWhiteColor];
    contentLabel.text = [LangSwitcher switchLang:@"恭喜您开启THEIA一站数字资产管理之路" key:nil];
    [contentLabel sizeToFit];
    contentLabel.frame = CGRectMake(30, nameLabel.yy + 20, SCREEN_WIDTH - 60, contentLabel.height);
    [self.view addSubview:contentLabel];
    
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"" titleColor:kClearColor backgroundColor:kClearColor titleFont:0];
    confirmBtn.frame = CGRectMake(SCREEN_WIDTH - 85, contentLabel.yy + 155, 50, 50);
    [confirmBtn setBackgroundImage:kImage(@"矩形3拷贝") forState:(UIControlStateNormal)];
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:confirmBtn];
    
    
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
