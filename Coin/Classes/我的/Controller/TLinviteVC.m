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
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}
//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"邀请有礼" key:nil];
    
    [self initUI];
    
    // Do any additional setup after loading the view.
}

- (void)initUI
{
    
    
    
    UIImageView *bgView = [[UIImageView alloc] init];
    self.bgView = bgView;
    bgView.userInteractionEnabled = YES;
    bgView.contentMode = UIViewContentModeScaleToFill;
    
    bgView.image = kImage(@"iPhone 8-背景");
    [self.view addSubview:bgView];
    bgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);

//    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//
//    }];
//
    
    self.bgImage = [[UIImageView alloc] init];
    self.bgImage.contentMode = UIViewContentModeScaleToFill;
    self.bgImage.userInteractionEnabled = YES;
//    self.bgImage.image = kImage(@"我的 背景");
    [self.bgView  addSubview:self.bgImage];
    self.bgImage.frame = CGRectMake(0, 0, kScreenWidth, 90);
//    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
    //
    self.backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.backButton.frame = CGRectMake(15, kStatusBarHeight+5, 40, 40);
    [self.backButton setImage:kImage(@"返回 白色") forState:(UIControlStateNormal)];
    [self.backButton addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgImage addSubview:self.backButton];
    self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(54, kStatusBarHeight+5, kScreenWidth - 108, 44)];
    self.nameLable.text = [LangSwitcher switchLang:@"邀请有礼" key:nil];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = Font(18);
    self.nameLable.textColor = kWhiteColor;
    [self.bgImage addSubview:self.nameLable];
//    iPhone 8-背景@2x@2x
    
    
    UIButton *inviteButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"海报邀请" key:nil] titleColor:kWhiteColor backgroundColor:kHexColor(@"#F19001") titleFont:16.0];
    
    [inviteButton addTarget:self action:@selector(inviteButtonClick) forControlEvents:UIControlEventTouchUpInside];

     UIButton *sendInviteButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"发红包邀请好友" key:nil] titleColor:kWhiteColor backgroundColor:kHexColor(@"#F19001") titleFont:16.0];
    
    [sendInviteButton addTarget:self action:@selector(sendinviteButtonClick) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *left = [[UIImageView alloc] init];
    left.contentMode = UIViewContentModeScaleToFill;
    left.image = kImage(@"箭头左");
    [self.bgView addSubview:left];
    
    UIImageView *right = [[UIImageView alloc] init];
    right.contentMode = UIViewContentModeScaleToFill;
    [self.bgView addSubview:right];
    right.image = kImage(@"尖头右");
    
    [self.bgView addSubview:inviteButton];
    [self.bgView addSubview:sendInviteButton];
    inviteButton.layer.cornerRadius = 25;
    inviteButton.clipsToBounds = YES;
    
    sendInviteButton.layer.cornerRadius = 25;
    sendInviteButton.clipsToBounds = YES;
    [inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-58);
        make.left.equalTo(self.view.mas_left).offset(34);
        make.width.equalTo(@(kWidth(145)));
        make.height.equalTo(@(kHeight(50)));


    }];
    
    [sendInviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-58);
        make.right.equalTo(self.view.mas_right).offset(-34);
        make.width.equalTo(@(kWidth(145)));
        make.height.equalTo(@(kHeight(50)));
    }];
    
    UILabel *introLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:11];
    [self.bgView addSubview:introLab];
    [introLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sendInviteButton.mas_bottom).offset(14);
        make.centerX.equalTo(self.view.mas_centerX);
    
    }];
    introLab.text = [LangSwitcher switchLang:@"点击生成邀请海报并截图给好友" key:nil];
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(introLab.mas_centerY);
        make.right.equalTo(introLab.mas_left).offset(-8);
        make.width.equalTo(@(kWidth(22)));
        make.height.equalTo(@(kHeight(1)));
        
        
    }];
    
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(introLab.mas_centerY);
        make.left.equalTo(introLab.mas_right).offset(8);
        make.width.equalTo(@(kWidth(22)));
        make.height.equalTo(@(kHeight(1)));
        
        
    }];
}


- (void)inviteButtonClick
{
    TLQrCodeVC *vc = [TLQrCodeVC new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)sendinviteButtonClick
{
    
    RedEnvelopeVC *redEnvelopeVC = [RedEnvelopeVC new];
    
    if ([[TLUser user].tradepwdFlag isEqualToString:@"0"]) {
        TLPwdType pwdType = TLPwdTypeSetTrade;
        TLPwdRelatedVC *pwdRelatedVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
        
        pwdRelatedVC.isWallet = YES;
        pwdRelatedVC.success = ^{
            
            
            //                    [self presentViewController:redEnvelopeVC animated:YES completion:nil];
            [self.navigationController pushViewController:redEnvelopeVC animated:YES];
            
        };
        [self.navigationController pushViewController:pwdRelatedVC animated:YES];
        
        
    }else{
        
        [self.navigationController pushViewController:redEnvelopeVC animated:YES];
        
        
    }

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
