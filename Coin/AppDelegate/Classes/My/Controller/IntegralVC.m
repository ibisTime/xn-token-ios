//
//  IntegralVC.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/17.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "IntegralVC.h"

@interface IntegralVC ()

@end

@implementation IntegralVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LangSwitcher switchLang:@"信用积分" key:nil];
    [self initUI];
}

-(void)IncreaseBtnClick
{
    NSNotification *notification =[NSNotification notificationWithName:@"LOADDATAPAGE" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)initUI
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeight(96))];
    backView.backgroundColor = kHexColor(@"#0848DF");
    [self.view addSubview:backView];

    UIImageView *bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(15), kHeight(11), SCREEN_WIDTH - kWidth(30), kHeight(180))];
    bgImg.image = kImage(@"积分背景");
    bgImg.layer.cornerRadius=5;
    bgImg.layer.shadowOpacity = 0.22;// 阴影透明度
    bgImg.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    bgImg.layer.shadowRadius=3;// 阴影扩散的范围控制
    bgImg.layer.shadowOffset=CGSizeMake(1, 1);// 阴影的范围
    [self.view addSubview:bgImg];

    UILabel *titleLbl = [UILabel labelWithFrame:CGRectMake(kWidth(15), kHeight(30), SCREEN_WIDTH - kWidth(60), kHeight(15)) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(15) textColor:kHexColor(@"#666666")];
    titleLbl.text = [LangSwitcher switchLang:@"-  让信用变为财富  -" key:nil];
    [bgImg addSubview:titleLbl];

    UILabel *integralLabel = [UILabel labelWithFrame:CGRectMake(kWidth(15), kHeight(72), SCREEN_WIDTH - kWidth(60), kHeight(14)) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(13) textColor:kHexColor(@"#999999")];
    integralLabel.text = [LangSwitcher switchLang:@"信用积分" key:nil];
    [bgImg addSubview:integralLabel];

    UILabel *numberLabel = [UILabel labelWithFrame:CGRectMake(kWidth(15), kHeight(101), SCREEN_WIDTH - kWidth(60), kHeight(24)) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(28) textColor:kHexColor(@"#333333")];
    numberLabel.text = [NSString stringWithFormat:@"0%@",[LangSwitcher switchLang:@"分" key:nil]];
    [bgImg addSubview:numberLabel];


    UIButton *IncreaseBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"我要增加信用积分" key:nil] titleColor:kHexColor(@"#FFFFFF") backgroundColor:kHexColor(@"#0848DF") titleFont:16];
    IncreaseBtn.frame = CGRectMake(kWidth(30), kHeight(231), SCREEN_WIDTH - kWidth(60), kHeight(52));
    IncreaseBtn.layer.cornerRadius=5;
    IncreaseBtn.layer.shadowOpacity = 0.22;// 阴影透明度
    IncreaseBtn.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    IncreaseBtn.layer.shadowRadius=3;// 阴影扩散的范围控制
    IncreaseBtn.layer.shadowOffset=CGSizeMake(1, 1);// 阴影的范围
    kViewRadius(IncreaseBtn, 4);
    [IncreaseBtn addTarget:self action:@selector(IncreaseBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:IncreaseBtn];

    UILabel *introduceLabel = [UILabel labelWithFrame:CGRectMake(kWidth(37), kHeight(313), SCREEN_WIDTH - kWidth(74), 0) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(13) textColor:kHexColor(@"#999999")];
    introduceLabel.text =  [LangSwitcher switchLang:@"个人账户中存入数字货币是增加信用积分最快的方式" key:nil];
    [self.view addSubview:introduceLabel];
    introduceLabel.numberOfLines = 0;
    [introduceLabel sizeToFit];

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
