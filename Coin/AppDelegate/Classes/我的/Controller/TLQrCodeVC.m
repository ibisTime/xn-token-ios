//
//  TLQrCodeVC.m
//  Coin
//
//  Created by shaojianfei on 2018/8/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLQrCodeVC.h"
#import "SGQRCodeGenerateManager.h"
#import "AppConfig.h"
@interface TLQrCodeVC ()
@property (nonatomic ,strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) UIImageView *whiteImage;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *nameLable;

@property (nonatomic, copy) NSString *h5String;

@end

@implementation TLQrCodeVC

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
    [self getShareUrl];
    
    // Do any additional setup after loading the view.
}


- (void)getShareUrl
{
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"660917";
    
    http.parameters[@"ckey"] = @"redPacketShareUrl";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.h5String = responseObject[@"data"][@"cvalue"];
        
        [self initUI];

    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)initUI
{
    
    
    
    UIImageView *bgView = [[UIImageView alloc] init];
    self.bgView = bgView;
    bgView.userInteractionEnabled = YES;
    bgView.contentMode = UIViewContentModeScaleToFill;
    
    bgView.image = kImage(@"邀请有礼1");
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
        self.bgImage.image = kImage(@"THEIA");
    [self.bgView  addSubview:self.bgImage];
    
        [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(kStatusBarHeight+10);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.equalTo(@(kWidth(140)));
            make.height.equalTo(@(kHeight(32)));
        }];
    
    
    self.backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.backButton.frame = CGRectMake(15, kStatusBarHeight+5, 40, 40);
    [self.backButton setImage:kImage(@"返回 白色") forState:(UIControlStateNormal)];
    [self.backButton addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgView addSubview:self.backButton];
    
    
    
    self.whiteImage = [[UIImageView alloc] init];
    self.whiteImage.contentMode = UIViewContentModeScaleToFill;
    self.whiteImage.userInteractionEnabled = YES;
    self.whiteImage.image = kImage(@"Combined Shape");
    [self.bgView  addSubview:self.whiteImage];
    
    [self.whiteImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kHeight(190));
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.equalTo(@440);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = kLineColor;
    [self.whiteImage addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteImage.mas_top).offset(88);
        make.left.equalTo(self.whiteImage.mas_left).offset(30);
        make.right.equalTo(self.whiteImage.mas_right).offset(-30);
        make.height.equalTo(@(kHeight(0.5)));
    }];
    
    UIView *codeView = [UIView new];
    [self.bgView addSubview:codeView];
    codeView.backgroundColor = kBackgroundColor;
    
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteImage.mas_top).offset(kHeight(120));
        make.left.equalTo(self.whiteImage.mas_left).offset(68);
        make.right.equalTo(self.whiteImage.mas_right).offset(-68);

        make.width.height.equalTo(@180);
    }];
    [self.whiteImage addSubview:codeView];
    //二维码
    UIImageView *qrIV = [[UIImageView alloc] init];
    NSString *address ;
     NSString *lang;
    LangType type = [LangSwitcher currentLangType];
    if (type == LangTypeSimple || type == LangTypeTraditional) {
        lang = @"ZH_CN";
    }else if (type == LangTypeKorean)
    {
        lang = @"KO";
        
        
    }else{
        lang = @"EN";
        
    }
    http://m.thadev.hichengdai.com/user/register.html?inviteCode=U201807030441369491006&lang=ZH_CN
     address = [NSString stringWithFormat:@"%@/user/register.html?inviteCode=%@&lang=%@",self.h5String,[TLUser user].userId,lang];
        
    
    qrIV.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:address imageViewWidth:170];
    
    [codeView addSubview:qrIV];
    [qrIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(codeView.mas_top).offset(15);
        make.left.equalTo(codeView.mas_left).offset(15);
        make.width.height.equalTo(@150);
        
    }];
    
    self.nameLable = [[UILabel alloc]init];
    self.nameLable.text = [NSString stringWithFormat:@"%@%@%@",[LangSwitcher switchLang:@"我是" key:nil],[TLUser user].nickname,[LangSwitcher switchLang:@"邀请您使用THA钱包" key:nil]];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = Font(14);
    self.nameLable.textColor = kTextBlack;
    [self.whiteImage addSubview:self.nameLable];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_whiteImage.mas_top).offset(27);
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];
    //    iPhone 8-背景@2x@2x
    
    
//    UIButton *inviteButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"海报邀请" key:nil] titleColor:kWhiteColor backgroundColor:kHexColor(@"#F19001") titleFont:16.0];
//    
//    [inviteButton addTarget:self action:@selector(inviteButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *sendInviteButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"发红包邀请好友" key:nil] titleColor:kWhiteColor backgroundColor:kHexColor(@"#F19001") titleFont:16.0];
//    
//    [sendInviteButton addTarget:self action:@selector(sendinviteButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.bgView addSubview:inviteButton];
//    [self.bgView addSubview:sendInviteButton];
//    inviteButton.layer.cornerRadius = 25;
//    inviteButton.clipsToBounds = YES;
//    
//    sendInviteButton.layer.cornerRadius = 25;
//    sendInviteButton.clipsToBounds = YES;
//    [inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_bottom).offset(-58);
//        make.left.equalTo(self.view.mas_left).offset(34);
//        make.width.equalTo(@(kWidth(145)));
//        make.height.equalTo(@(kHeight(50)));
//        
//        
//    }];
//    
//    [sendInviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_bottom).offset(-58);
//        make.right.equalTo(self.view.mas_right).offset(-34);
//        make.width.equalTo(@(kWidth(145)));
//        make.height.equalTo(@(kHeight(50)));
//    }];
//    
    UILabel *introLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    [self.whiteImage addSubview:introLab];
    [introLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeView.mas_bottom).offset(16);
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];
    introLab.text = [LangSwitcher switchLang:@"扫码二维码领取奖励" key:nil];
    
}


- (void)inviteButtonClick
{
    
    
}

- (void)sendinviteButtonClick
{
    
    
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
