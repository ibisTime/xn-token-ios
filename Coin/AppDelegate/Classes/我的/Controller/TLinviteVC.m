//
//  TLinviteVC.m
//  Coin
//
//  Created by shaojianfei on 2018/8/8.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLinviteVC.h"
#import "TLQrCodeVC.h"
#import "RedEnvelopeVC.h"
#import "TLPwdRelatedVC.h"
#import "UIButton+SGImagePosition.h"
#import "PoliteInstructionsVC.h"
@interface TLinviteVC ()

@property (nonatomic ,strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *nameLable;
@end

@implementation TLinviteVC
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

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = [LangSwitcher switchLang:@"邀请有礼" key:nil];
    self.nameLable = [[UILabel alloc]init];
    self.nameLable.text = [LangSwitcher switchLang:@"邀请有礼" key:nil];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = Font(18);
    self.nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.nameLable;

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    UIButton *RightButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:RightButton]];
    [RightButton setImage:kImage(@"more 白色") forState:(UIControlStateNormal)];
    [RightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:(UIControlEventTouchUpInside)];

    [self initUI];

    
    
    // Do any additional setup after loading the view.
}

-(void)rightButtonClick
{
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *showAllInfoAction = [UIAlertAction actionWithTitle:@"邀请有礼说明" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PoliteInstructionsVC *vc = [PoliteInstructionsVC new];
        [self.navigationController pushViewController:vc animated:YES];

    }];
    [showAllInfoAction setValue:kHexColor(@"#333333") forKey:@"_titleTextColor"];
    [actionSheetController addAction:showAllInfoAction];

    [self presentViewController:actionSheetController animated:YES completion:nil];

}

- (void)initUI
{
    UIImageView *bgView = [[UIImageView alloc] init];
    self.bgView = bgView;
    bgView.userInteractionEnabled = YES;
    bgView.contentMode = UIViewContentModeScaleToFill;
    
    bgView.image = kImage(@"邀请bg");
    [self.view addSubview:bgView];
    bgView.frame = CGRectMake(0, -kNavigationBarHeight, kScreenWidth, kScreenHeight);
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - kWidth(38), kHeight(kNavigationBarHeight + 16), kWidth(76), kHeight(103))];
    iconImage.image = kImage(@"logoo");
    [bgView addSubview:iconImage];

    UIImageView *titleBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(70), kHeight(197 - 64 + kNavigationBarHeight),SCREEN_WIDTH - kWidth(105), kHeight(52))];
    titleBackImage.image = kImage(@"文字背景");
    [bgView addSubview:titleBackImage];


    UILabel *introduceLabel = [UILabel labelWithFrame:CGRectMake(kWidth(23), kHeight(2), SCREEN_WIDTH - kWidth(186), kHeight(36)) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kHexColor(@"#FFFFFF")];

    introduceLabel.text = [LangSwitcher switchLang:@"全球首款跨链生态钱包" key:nil];
    [titleBackImage addSubview:introduceLabel];


    UIImageView *textBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(40), kHeight(211 + kNavigationBarHeight), SCREEN_WIDTH - kWidth(80), kHeight(201))];
    textBackImage.image = kImage(@"长框");
    [bgView addSubview:textBackImage];

    UILabel *numberUsersLabel = [UILabel labelWithFrame:CGRectMake(kWidth(15), kHeight(44), SCREEN_WIDTH - kWidth(110), kHeight(22)) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kHexColor(@"#FFFFFF")];
    numberUsersLabel.text = [LangSwitcher switchLang:@"您已成功邀请10名用户" key:nil];
    [textBackImage addSubview:numberUsersLabel];

    UILabel *ThankYouLabel = [UILabel labelWithFrame:CGRectMake(kWidth(15), kHeight(110), SCREEN_WIDTH - kWidth(110), kHeight(22)) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kHexColor(@"#FFFFFF")];
    ThankYouLabel.text = [LangSwitcher switchLang:@"感谢您的付出！" key:nil];
    [textBackImage addSubview:ThankYouLabel];

    UIButton *integralBtn = [UIButton buttonWithTitle:@"" titleColor:kHexColor(@"#A2A5C4") backgroundColor:kClearColor titleFont:13];
    NSString *str = @"您拥有积分5点    马上提币";
    NSString *str1 = @"您拥有积分";
    NSString *str2 = @"5";
    NSString *str3 = @"点";
    NSString *str4 = @"马上提币";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:kHexColor(@"#A2A5C4")
                    range:NSMakeRange(0, str1.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:kHexColor(@"#00F7FE")
                    range:NSMakeRange(str1.length, str2.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:kHexColor(@"#A2A5C4")
                    range:NSMakeRange(str1.length + str2.length, str3.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:kHexColor(@"#00F7FE")
                    range:NSMakeRange(str.length - str4.length, str4.length)];
    [integralBtn setAttributedTitle:attrStr forState:(UIControlStateNormal)];
    integralBtn.frame = CGRectMake(kWidth(15), kHeight(143), SCREEN_WIDTH - kWidth(110), kHeight(18));

    [integralBtn SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:4 imagePositionBlock:^(UIButton *button) {
        [button setImage:[UIImage imageNamed:@"more 亮色"] forState:(UIControlStateNormal)];
    }];
    [textBackImage addSubview:integralBtn];


    UIButton *inviteButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"海报邀请" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:16.0];
    [inviteButton addTarget:self action:@selector(inviteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    inviteButton.frame = CGRectMake(SCREEN_WIDTH/4 - kWidth(60), SCREEN_HEIGHT - kHeight(95), kWidth(120), kHeight(40));
    [inviteButton setBackgroundImage:kImage(@"按钮背景") forState:(UIControlStateNormal)];
    [self.bgView addSubview:inviteButton];

     UIButton *sendInviteButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"红包邀请" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:16.0];
    [sendInviteButton addTarget:self action:@selector(sendinviteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [sendInviteButton setBackgroundImage:kImage(@"按钮背景") forState:(UIControlStateNormal)];
    sendInviteButton.frame = CGRectMake(SCREEN_WIDTH/4*3 - kWidth(60), SCREEN_HEIGHT - kHeight(95), kWidth(120), kHeight(40));
    [self.bgView addSubview:sendInviteButton];

    

}


- (void)inviteButtonClick
{
    TLQrCodeVC *vc = [TLQrCodeVC new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)sendinviteButtonClick
{
    
    RedEnvelopeVC *redEnvelopeVC = [RedEnvelopeVC new];

    [self.navigationController pushViewController:redEnvelopeVC animated:YES];
        
  

}
- (void)buttonClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
