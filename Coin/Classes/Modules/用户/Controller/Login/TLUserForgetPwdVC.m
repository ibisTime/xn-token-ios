//
//  TLUserForgetPwdVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLUserForgetPwdVC.h"
#import "CaptchaView.h"
#import "NSString+Check.h"
#import "APICodeMacro.h"
#import "UIBarButtonItem+convience.h"
#import "ChooseCountryVc.h"
@interface TLUserForgetPwdVC ()

@property (nonatomic,strong) TLTextField *phoneTf;

@property (nonatomic,strong) TLTextField *pwdTf;

@property (nonatomic,strong) TLTextField *rePwdTf;

@property (nonatomic, strong) CaptchaView *captchaView;
@property (nonatomic ,strong) UILabel *titlePhpne;
@property (nonatomic ,strong) UILabel *PhoneCode;
@property (nonatomic ,strong) UIButton *accessoryImageView;
@end

@implementation TLUserForgetPwdVC
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [LangSwitcher switchLang:@"找回密码" key:nil];
    
    self.view.backgroundColor = kWhiteColor;
    
    [self initSubviews];
    
}

- (void)initSubviews {

    self.view.backgroundColor = kWhiteColor;
    
    CGFloat margin = ACCOUNT_MARGIN;
    CGFloat w = kScreenWidth - 2*margin;
    CGFloat h = ACCOUNT_HEIGHT;
    
    CGFloat btnMargin = 15;
    UILabel *lab = [UILabel labelWithBackgroundColor:kWhiteColor textColor:kBlackColor font:30];
    lab.text = @"找回密码!";
    [self.view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@40);
        make.left.equalTo(@30);
        
        
    }];
    //账号
    UILabel *titlePhone = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    [self.view addSubview:titlePhone];
    titlePhone.text = [LangSwitcher switchLang:@"中国" key:nil];
    self.titlePhpne = titlePhone;
    [titlePhone mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lab.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
    }];
    //账号
    UILabel *sureLab = [UILabel labelWithTitle:@"手机号" frame:CGRectMake(20, kHeight(122), w, 22)];
    sureLab.font = [UIFont systemFontOfSize:14];
    sureLab.textAlignment = NSTextAlignmentLeft;
    sureLab.textColor = kTextColor;
    [self.view addSubview:sureLab];
    
    UILabel *PhoneCode = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    [self.view addSubview:PhoneCode];
    PhoneCode.text = [LangSwitcher switchLang:@"+86" key:nil];
    self.PhoneCode = PhoneCode;
    [PhoneCode mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(sureLab.yy+15));
        make.left.mas_equalTo(20);
    }];
    
   
    TLTextField *phoneTf = [[TLTextField alloc] initWithFrame:CGRectMake(60, sureLab.yy, w, h) leftTitle:[LangSwitcher switchLang:@"" key:nil] titleWidth:20 placeholder:[LangSwitcher switchLang:@"请输入手机号" key:nil]];
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneTf];
    self.phoneTf = phoneTf;
    UIView *phone = [[UIView alloc] init];
    [self.view addSubview:phone];
    phone.backgroundColor = kLineColor;
    phone.frame = CGRectMake(btnMargin, phoneTf.yy, w-30, 1);
    //验证码
    
    UILabel *codeLab = [UILabel labelWithTitle:@"验证码" frame:CGRectMake(20, phoneTf.yy, w, 22)];
    codeLab.font = [UIFont systemFontOfSize:14];
    codeLab.textAlignment = NSTextAlignmentLeft;
    codeLab.textColor = kTextColor;
    [self.view addSubview:codeLab];
    CaptchaView *captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(margin, codeLab.yy + 1, w, h)];
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:captchaView];
    
    self.captchaView = captchaView;
    UIView *phone2 = [[UIView alloc] init];
    [self.view addSubview:phone2];
    phone2.backgroundColor = kLineColor;
    phone2.frame = CGRectMake(btnMargin, captchaView.yy, w-30, 1);
    //密码
    UILabel *pwdLab = [UILabel labelWithTitle:@"密码" frame:CGRectMake(20, captchaView.yy, w, 22)];
    pwdLab.font = [UIFont systemFontOfSize:14];
    pwdLab.textAlignment = NSTextAlignmentLeft;
    pwdLab.textColor = kTextColor;
    [self.view addSubview:pwdLab];
    
    TLTextField *pwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, pwdLab.yy + 10, w, h) leftTitle:[LangSwitcher switchLang:@"" key:nil] titleWidth:20 placeholder:[LangSwitcher switchLang:@"请输入密码" key:nil]];
    pwdTf.secureTextEntry = YES;
    
    [self.view addSubview:pwdTf];
    self.pwdTf = pwdTf;
    UIView *phone3 = [[UIView alloc] init];
    [self.view addSubview:phone3];
    phone3.backgroundColor = kLineColor;
    phone3.frame = CGRectMake(btnMargin, pwdTf.yy, w-30, 1);
    //re密码
    UILabel *pLab = [UILabel labelWithTitle:@"密码" frame:CGRectMake(20, pwdTf.yy, w, 22)];
    pLab.font = [UIFont systemFontOfSize:14];
    pLab.textAlignment = NSTextAlignmentLeft;
    pLab.textColor = kTextColor;
    [self.view addSubview:pLab];
    TLTextField *rePwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, pLab.yy + 1, w, h) leftTitle:[LangSwitcher switchLang:@"" key:nil] titleWidth:20 placeholder:[LangSwitcher switchLang:@"确认密码" key:nil]];
    rePwdTf.secureTextEntry = YES;
    [self.view addSubview:rePwdTf];
    self.rePwdTf = rePwdTf;
    UIView *phone4 = [[UIView alloc] init];
    [self.view addSubview:phone4];
    phone4.backgroundColor = kLineColor;
    phone4.frame = CGRectMake(btnMargin, rePwdTf.yy, w-30, 1);
//    for (int i = 0; i < 2; i++) {
//
//        UIView *line = [[UIView alloc] init];
//
//        line.backgroundColor = [UIColor lineColor];
//
//        [self.view addSubview:line];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.mas_equalTo(margin);
//            make.right.mas_equalTo(0);
//            make.height.mas_equalTo(0.5);
//            make.top.mas_equalTo(10 + h + i*(2*h + 10 + 1));
//
//        }];
//    }
    
    //
    self.accessoryImageView = [[UIButton alloc] init];
//    self.accessoryImageView.frame = CGRectMake(kScreenWidth - 40-40, 90, 40, 40);
    [self.view addSubview:self.accessoryImageView];
    [self.accessoryImageView setImage:kImage(@"更多-灰色") forState:UIControlStateNormal];
    [self.accessoryImageView addTarget:self action:@selector(chooseCountry) forControlEvents:UIControlEventTouchUpInside];
        [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.centerY.equalTo(titlePhone.mas_centerY).offset(0);
            make.right.mas_equalTo(-20);
            make.width.height.equalTo(@40);
        }];
    UIButton *confirmBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"确认" key:nil] titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    
    [confirmBtn addTarget:self action:@selector(changePwd) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(btnMargin);
        make.width.mas_equalTo(kScreenWidth - 2*btnMargin);
        make.height.mas_equalTo(h - 5);
        make.top.mas_equalTo(rePwdTf.mas_bottom).mas_equalTo(40);
        
    }];
}
- (void)chooseCountry
{
    
    //选择国家 设置区号
    CoinWeakSelf;
    ChooseCountryVc *countryVc = [ChooseCountryVc new];
    countryVc.selectCountry = ^(CountryModel *model) {
        //更新国家 区号
        weakSelf.titlePhpne.text = model.chineseName;
        weakSelf.PhoneCode.text = [NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]];
    } ;
    [self presentViewController:countryVc animated:YES completion:nil];
}

#pragma mark - Events
- (void)sendCaptcha {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的手机号" key:nil]];
        
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = CAPTCHA_CODE;
    http.parameters[@"bizType"] = USER_FIND_PWD_CODE;
    http.parameters[@"mobile"] = self.phoneTf.text;
    http.parameters[@"interCode"] = [NSString stringWithFormat:@"00%@",[self.PhoneCode.text substringFromIndex:1]];

    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"验证码已发送,请注意查收" key:nil]];
        
        [self.captchaView.captchaBtn begin];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)changePwd {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的手机号" key:nil]];
        
        return;
    }
    
    if (!(self.captchaView.captchaTf.text && self.captchaView.captchaTf.text.length > 3)) {
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的验证码" key:nil]];
        
        return;
    }
    
    if (!(self.pwdTf.text &&self.pwdTf.text.length > 5)) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入6位以上密码" key:nil]];
        return;
    }
    
    if (![self.pwdTf.text isEqualToString:self.rePwdTf.text]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"输入的密码不一致" key:nil]];
        return;
        
    }
    
    [self.view endEditing:YES];

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_FIND_PWD_CODE;
    http.parameters[@"mobile"] = self.phoneTf.text;
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
    http.parameters[@"newLoginPwd"] = self.pwdTf.text;
    http.parameters[@"kind"] = APP_KIND;
    http.parameters[@"interCode"] = [NSString stringWithFormat:@"00%@",[self.PhoneCode.text substringFromIndex:1]];

    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"找回成功" key:nil]];
        
        //保存用户账号和密码
//        [[TLUser user] saveUserName:self.phoneTf.text pwd:self.pwdTf.text];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
