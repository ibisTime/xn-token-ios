//
//  TLPwdRelatedVC.m
//  ZHBusiness
//
//  Created by  蔡卓越 on 2016/12/12.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLPwdRelatedVC.h"
#import "CaptchaView.h"
#import "APICodeMacro.h"
#import "ChooseCountryVc.h"
#import "NSString+Check.h"
#import "CountryModel.h"
@interface TLPwdRelatedVC ()

@property (nonatomic,assign) TLPwdType type;
@property (nonatomic,strong) TLTextField *phoneTf;
//谷歌验证码
@property (nonatomic, strong) TLTextField *googleAuthTF;

@property (nonatomic,strong) CaptchaView *captchaView;
@property (nonatomic,strong) TLTextField *pwdTf;
@property (nonatomic,strong) TLTextField *rePwdTf;
@property (nonatomic ,strong) UILabel *titlePhpne;
@property (nonatomic ,strong) UILabel *PhoneCode;
@property (nonatomic ,strong) UIButton *accessoryImageView;

@property (nonatomic,strong) NSMutableArray <CountryModel *>*countrys;


@end

@implementation TLPwdRelatedVC

- (instancetype)initWithType:(TLPwdType)type {
    
    if (self = [super init]) {
        
        self.type = type;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    [self setUpUI];
    [self loadData];
    if ([TLUser user].mobile) {
        
        self.phoneTf.enabled = NO;
        self.phoneTf.text = [TLUser user].mobile;
        self.PhoneCode.text =[NSString stringWithFormat:@"+%@",[[TLUser user].interCode substringFromIndex:2]];
        
       
    }
    
    
    if(self.type == TLPwdTypeForget) {
        
        self.title = [LangSwitcher switchLang:@"忘记密码" key:nil];
        
    } else if (self.type == TLPwdTypeReset) {
        
        self.title = [LangSwitcher switchLang:@"修改登录密码" key:nil];
        
    } else if (self.type == TLPwdTypeTradeReset) {
        
        self.title = [LangSwitcher switchLang:@"修改资金密码" key:nil];
    
    } else if (self.type == TLPwdTypeSetTrade) {
    
        self.title = [LangSwitcher switchLang:@"设置资金密码" key:nil];

    }
    
}

#pragma mark - Init

- (void)setUpUI {
    
    CGFloat leftW = 100;
    
    //账号
    
    UIView *view = [[UIView alloc] init];
    
    [self.view addSubview:view];
    view.backgroundColor = kWhiteColor;
    view.frame = CGRectMake(0, 0, kScreenWidth, 60);
    
    UILabel *titlePhone = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    [view addSubview:titlePhone];
    titlePhone.text = [LangSwitcher switchLang:@"中国" key:nil];
    self.titlePhpne = titlePhone;
    titlePhone.backgroundColor = kWhiteColor;
    [titlePhone mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@20);
        make.left.mas_equalTo(20);
    }];
    UILabel *PhoneCode = [UILabel labelWithBackgroundColor:kWhiteColor textColor:kTextColor font:16];
    [view addSubview:PhoneCode];
    PhoneCode.text = [LangSwitcher switchLang:@"+86" key:nil];
    self.PhoneCode = PhoneCode;
    PhoneCode.backgroundColor = kWhiteColor;

    [PhoneCode mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@20);
        make.left.equalTo(titlePhone.mas_right).offset(15);
    }];
    
//    self.accessoryImageView = [[UIButton alloc] init];
//    //    self.accessoryImageView.frame = CGRectMake(kScreenWidth - 40-40, 90, 40, 40);
//    [view addSubview:self.accessoryImageView];
//    [self.accessoryImageView setImage:kImage(@"更多-灰色") forState:UIControlStateNormal];
//    [self.accessoryImageView addTarget:self action:@selector(chooseCountry) forControlEvents:UIControlEventTouchUpInside];
//    [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerY.equalTo(titlePhone.mas_centerY).offset(0);
//        make.right.mas_equalTo(-20);
//        make.width.height.equalTo(@40);
//    }];
//
    //手机号
    TLTextField *phoneTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, view.yy, kScreenWidth, 45)
                                                    leftTitle:[LangSwitcher switchLang:@"手机号" key:nil]
                                                   titleWidth:leftW
                                                  placeholder:[LangSwitcher switchLang:@"请输入手机号" key:nil]];
    [self.bgSV addSubview:phoneTf];
    self.phoneTf = phoneTf;
    
    
    //谷歌验证码
    self.googleAuthTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, phoneTf.yy + 1, phoneTf.width, phoneTf.height)
                                                 leftTitle:[LangSwitcher switchLang:@"谷歌验证码" key:nil]
                                                titleWidth:leftW
                                               placeholder:[LangSwitcher switchLang:@"请输入谷歌验证码" key:nil]];
    
    self.googleAuthTF.keyboardType = UIKeyboardTypeNumberPad;

    [self.view addSubview:self.googleAuthTF];
    
    self.googleAuthTF.hidden = ![TLUser user].isGoogleAuthOpen;

    //复制
    UIView *authView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 95, self.googleAuthTF.height)];
    
    UIButton *pasteBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"粘贴" key:nil] titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:13.0 cornerRadius:5];
    
    pasteBtn.frame = CGRectMake(0, 0, 85, self.googleAuthTF.height - 15);
    
    pasteBtn.centerY = authView.height/2.0;
    
    [pasteBtn addTarget:self action:@selector(clickPaste) forControlEvents:UIControlEventTouchUpInside];
    
    [authView addSubview:pasteBtn];
    
    self.googleAuthTF.rightView = authView;
    
    CGFloat captchaViewY = [TLUser user].isGoogleAuthOpen ? self.googleAuthTF.yy + 1: phoneTf.yy + 1;
    //验证码
    CaptchaView *captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(0, captchaViewY, phoneTf.width, phoneTf.height) leftTitleWidth:100];
    
    captchaView.captchaTf.leftLbl.text = [LangSwitcher switchLang:@"短信验证码" key:nil];
    
    [self.bgSV addSubview:captchaView];
    _captchaView = captchaView;
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    
    //新密码
    TLTextField *pwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, captchaView.yy + 10, phoneTf.width, phoneTf.height)
                                                  leftTitle:[LangSwitcher switchLang:@"新密码" key:nil]
                                                 titleWidth:leftW
                                                placeholder:[LangSwitcher switchLang:@"请输入密码(不少于6位)" key:nil]];
    
    pwdTf.returnKeyType = UIReturnKeyNext;
    
    [pwdTf addTarget:self action:@selector(next:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.bgSV addSubview:pwdTf];
    pwdTf.secureTextEntry = YES;
    self.pwdTf = pwdTf;
    
    //重新输入
    TLTextField *rePwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, pwdTf.yy + 1, phoneTf.width, phoneTf.height)
                                                    leftTitle:[LangSwitcher switchLang:@"确认密码" key:nil]
                                                   titleWidth:leftW
                                                  placeholder:[LangSwitcher switchLang:@"请确认密码" key:nil]];
    
    rePwdTf.returnKeyType = UIReturnKeyDone;

    [rePwdTf addTarget:self action:@selector(done:) forControlEvents:UIControlEventEditingDidEndOnExit];

    [self.bgSV addSubview:rePwdTf];
    rePwdTf.secureTextEntry = YES;
    
    self.rePwdTf = rePwdTf;
    
    NSString *btnStr = @"";
    
    if(self.type == TLPwdTypeForget) {
        
        btnStr = [LangSwitcher switchLang:@"确认找回" key:nil];
        
    } else if (self.type == TLPwdTypeReset || self.type == TLPwdTypeTradeReset) {
        
        btnStr= [LangSwitcher switchLang:@"确认修改" key:nil];
        
    } else if (self.type == TLPwdTypeSetTrade) {
        
        btnStr = [LangSwitcher switchLang:@"确认设置" key:nil];
    }
    
    //确认按钮
    UIButton *confirmBtn = [UIButton buttonWithTitle:btnStr titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:5];
    
    confirmBtn.frame = CGRectMake(15, rePwdTf.yy + 30, kScreenWidth - 30, 44);
    [self.bgSV addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)loadData
{
    
    
    TLNetworking *net = [TLNetworking new];
    net.showView = self.view;
    net.code = @"801120";
    net.isLocal = YES;
    net.ISparametArray = YES;
    net.parameters[@"status"] = @"1";
    [net postWithSuccess:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        self.countrys = [CountryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //        NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"data"]];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthResult" object:str];
        for (int i = 0 ; i < self.countrys.count; i++) {
            CountryModel *model = self.countrys[i];
            if ([model.interCode isEqualToString:[TLUser user].interCode]) {
              LangType type =   [LangSwitcher currentLangType];
                if ([LangSwitcher currentLangType] == LangTypeEnglish) {
                    self.titlePhpne.text = model.interName;

                }else{
                    self.titlePhpne.text = model.chineseName;

                }

            }
        }
        
        
        
    } failure:^(NSError *error) {
        
        
    }];
}
#pragma mark - Events
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

- (void)sendCaptcha {
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = CAPTCHA_CODE;
    if (self.type == TLPwdTypeTradeReset) { //重置交易密码
        
        http.parameters[@"bizType"] = USER_FIND_TRADE_PWD;
        
    } else if (self.type == TLPwdTypeForget || self.type == TLPwdTypeReset){ //找回密码||修改登录密码
        
        http.parameters[@"bizType"] = USER_CHANGE_PWD_CODE;
        
    } else if (self.type == TLPwdTypeSetTrade) {//设置资金密码
        
        http.parameters[@"bizType"] = USER_SET_TRADE_PWD;
        
    }
    http.parameters[@"mobile"] = self.phoneTf.text;

    http.parameters[@"interCode"] = [NSString stringWithFormat:@"00%@",[self.PhoneCode.text substringFromIndex:1]];
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"验证码已发送,请注意查收" key:nil]];
        [self.captchaView.captchaBtn begin];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)clickPaste {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    if (pasteboard.string != nil) {
        
        self.googleAuthTF.text = pasteboard.string;
        
    } else {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"粘贴内容为空" key:nil]];
    }
}

- (void)next:(UIButton *)sender {

    [_rePwdTf becomeFirstResponder];
}

- (void)done:(UIButton *)sender {

    [_rePwdTf resignFirstResponder];
}

- (void)confirm {
    
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的手机号" key:nil]];
        
        return;
    }
    
    if ([TLUser user].isGoogleAuthOpen) {
        
        if (![self.googleAuthTF.text valid]) {
            
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入谷歌验证码" key:nil]];
            return;
        }
        
        //判断谷歌验证码是否为纯数字
        if (![NSString isPureNumWithString:self.googleAuthTF.text]) {
            
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的谷歌验证码" key:nil]];
            return ;
        }
        
        //判断谷歌验证码是否为6位
        if (self.googleAuthTF.text.length != 6) {
            
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的谷歌验证码" key:nil]];
            return ;
        }
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
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    
    if (self.type == TLPwdTypeTradeReset) { //资金密码po
        
        http.code = USER_FIND_TRADE_PWD;
        
        http.parameters[@"newTradePwd"] = self.pwdTf.text;
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"token"] = [TLUser user].token;
        
    } else if (self.type == TLPwdTypeForget || self.type == TLPwdTypeReset){
        
        http.code = USER_CHANGE_PWD_CODE;
        http.parameters[@"kind"] = @"C";
        http.parameters[@"mobile"] = self.phoneTf.text;
        http.parameters[@"newLoginPwd"] = self.pwdTf.text;
        
    } else if (self.type == TLPwdTypeSetTrade) {
        
        http.code = USER_SET_TRADE_PWD;
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"tradePwd"] = self.pwdTf.text;
        http.parameters[@"token"] = [TLUser user].token;
        
    }
    
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
    
    if ([TLUser user].isGoogleAuthOpen) {
        
        http.parameters[@"googleCaptcha"] = self.googleAuthTF.text;

    }
    http.parameters[@"interCode"] = [NSString stringWithFormat:@"00%@",[self.PhoneCode.text substringFromIndex:1]];

    [http postWithSuccess:^(id responseObject) {
        
        NSString *promptStr = @"";
        
        if(self.type == TLPwdTypeForget) {
            
            promptStr = [LangSwitcher switchLang:@"找回成功" key:nil];
            
        } else if (self.type == TLPwdTypeReset || self.type == TLPwdTypeTradeReset) {
            
            promptStr= [LangSwitcher switchLang:@"修改成功" key:nil];
            //保存用户账号和密码
//            [[TLUser user] saveUserName:self.phoneTf.text pwd:self.pwdTf.text];
            
        } else if (self.type == TLPwdTypeSetTrade) {
            
            [TLUser user].tradepwdFlag = @"1";
            
            promptStr = [LangSwitcher switchLang:@"设置成功" key:nil];
            
        }
        
        [TLAlert alertWithSucces:promptStr];
        
        [[TLUser user] updateUserInfo];
        
        if (!self.isWallet) {
            
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }

        if (self.success) {
            
            self.success();
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    //
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
