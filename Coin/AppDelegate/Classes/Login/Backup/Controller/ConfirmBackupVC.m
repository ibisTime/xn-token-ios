//
//  ConfirmBackupVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/20.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "ConfirmBackupVC.h"

@interface ConfirmBackupVC ()

@end

@implementation ConfirmBackupVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self navigationTransparentClearColor];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.hidesBackButton = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

-(void)initView
{
    UILabel *nameLable = [[UILabel alloc]init];
    nameLable.text = [LangSwitcher switchLang:@"备份钱包助记词" key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(16);
    nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = nameLable;
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    [self.view addSubview:backImage];
    
    UILabel *promptLabel = [UILabel labelWithFrame:CGRectMake(0,  150, SCREEN_WIDTH, 20) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(18) textColor:kWhiteColor];
    promptLabel.text = [LangSwitcher switchLang:@"钱包助记词备份成功！" key:nil];
    [self.view addSubview:promptLabel];
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"完成" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:16];
    confirmBtn.frame = CGRectMake(SCREEN_WIDTH/2 - 65, promptLabel.yy + 56, 130, 50);
    kViewRadius(confirmBtn, 10);
    [confirmBtn setBackgroundImage:kImage(@"矩形5-1") forState:(UIControlStateNormal)];
    [confirmBtn addTarget:self action:@selector(confirmBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:confirmBtn];
    
    
    UILabel *cententLabel = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, SCREEN_HEIGHT - 62 - 14 - kNavigationBarHeight, 80, 14) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kWhiteColor];
    cententLabel.text = [LangSwitcher switchLang:@"以防被盗" key:nil];
    [cententLabel sizeToFit];
    cententLabel.frame = CGRectMake(SCREEN_WIDTH/2 - cententLabel.width/2 , SCREEN_HEIGHT - 62 - 14 - kNavigationBarHeight, cententLabel.width, 14);
    [self.view addSubview:cententLabel];
    
    UILabel *leftLabel = [UILabel labelWithFrame:CGRectMake(0, SCREEN_HEIGHT - 62 - 14- kNavigationBarHeight, SCREEN_WIDTH/2 - cententLabel.width/2 - 13, 14) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(14) textColor:kWhiteColor];
    leftLabel.text = [LangSwitcher switchLang:@"妥善保管" key:nil];
    [self.view addSubview:leftLabel];
    
    UILabel *rightLabel = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2 + cententLabel.width/2 + 13, SCREEN_HEIGHT - 62 - 14 - kNavigationBarHeight, SCREEN_WIDTH/2 - cententLabel.width/2 - 13, 14) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kWhiteColor];
    rightLabel.text = [LangSwitcher switchLang:@"切勿丢失" key:nil];
    [self.view addSubview:rightLabel];
    
}

-(void)confirmBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
