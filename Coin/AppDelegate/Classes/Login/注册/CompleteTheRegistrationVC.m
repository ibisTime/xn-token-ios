//
//  CompleteTheRegistrationVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/15.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "CompleteTheRegistrationVC.h"

@interface CompleteTheRegistrationVC ()

@end

@implementation CompleteTheRegistrationVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self navigationTransparentClearColor];
//    self.navigationController.navigationBar.hidden = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:animated];、
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.hidesBackButton = NO;
//    self.navigationController.navigationBar.hidden = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    [self.view addSubview:backImage];
    
    UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(0, 209 - 64, SCREEN_WIDTH, 20) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(20) textColor:kWhiteColor];
    nameLabel.text = [LangSwitcher switchLang:@"账号创建成功" key:nil];
    [self.view addSubview:nameLabel];
    
    UILabel *contentLabel = [UILabel labelWithFrame:CGRectMake(30, nameLabel.yy + 20, SCREEN_WIDTH - 60, 0) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kWhiteColor];
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

-(void)confirm
{
    NSInteger index = (NSInteger)[[self.navigationController viewControllers] indexOfObject:self];
    if (index > 2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}

//}


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
