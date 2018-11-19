//
//  BackupWalletMnemonicVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/19.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "BackupWalletMnemonicVC.h"

@interface BackupWalletMnemonicVC ()
{
    NSInteger selectNum;
}
@end

@implementation BackupWalletMnemonicVC


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
    
    
    
    UILabel *nameLable = [[UILabel alloc]init];
    nameLable.text = [LangSwitcher switchLang:@"备份钱包助记词" key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(16);
    nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = nameLable;
    selectNum = 0;
    [self initView];
}

-(void)initView
{
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    [self.view addSubview:backImage];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(25, 60, SCREEN_WIDTH - 50, 160)];
    topView.backgroundColor = RGB(133, 202, 207);
    topView.layer.cornerRadius=5;
    topView.layer.shadowOpacity = 0.22;// 阴影透明度
    topView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    topView.layer.shadowRadius=3;// 阴影扩散的范围控制
    topView.layer.shadowOffset = CGSizeMake(1, 1);// 阴
    [self.view addSubview:topView];
    
    
    
    
    for (int i = 0; i < 12; i ++) {
        
        
        UIView *backupView = [[UIView alloc]initWithFrame:CGRectMake(30 + i%3*((SCREEN_WIDTH - 70)/3 + 5),  60 + 5 + i/3*(135/4 + 5), (SCREEN_WIDTH - 70)/3, 135/4)];
//        backupView.backgroundColor = kWhiteColor;
        backupView.tag = i + 10;
        [self.view addSubview:backupView];
        
        UIButton *backupBtn = [UIButton buttonWithTitle:@"buy" titleColor:kWhiteColor backgroundColor:kClearColor titleFont:14];
        backupBtn.frame = CGRectMake(25 + i%3*((SCREEN_WIDTH - 70)/3 + 10), topView.yy + 27 + i/3*50, (SCREEN_WIDTH - 70)/3, 40);
        
        [backupBtn setBackgroundImage:kImage(@"圆角矩形2拷贝2") forState:(UIControlStateNormal)];
        [backupBtn setBackgroundImage:kImage(@"") forState:(UIControlStateSelected)];
        
        
        [backupBtn addTarget:self action:@selector(backupBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        backupBtn.tag = 100 + i;
        [self.view addSubview:backupBtn];
    }
}

-(void)backupBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;

    if (sender.selected == YES) {
        UIView *selectView = [self.view viewWithTag:selectNum + 10];
        [UIView animateWithDuration:0.5 animations:^{
            sender.frame = selectView.frame;
            kViewBorderRadius(sender, 5, 1, kWhiteColor);
            [sender setBackgroundImage:kImage(@"") forState:(UIControlStateNormal)];
        }];
        selectNum ++;
    }else
    {
        
    }
    
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
