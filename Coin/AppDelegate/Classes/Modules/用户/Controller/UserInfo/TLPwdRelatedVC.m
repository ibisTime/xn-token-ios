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
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Extension.h"
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
@property (nonatomic ,strong) UIImageView *pic;
@property (nonatomic,strong) NSMutableArray <CountryModel *>*countrys;
@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *nameLable;

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
//    [self initTop];

    [self setUpUI];
    [self loadData];
    [self configData];
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
- (void)configData
{
    
    BOOL isChoose =  [[NSUserDefaults standardUserDefaults] boolForKey:@"chooseCoutry"];
    
    if (isChoose == YES) {
        
        NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
        CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if (model) {
            NSString *url = [model.pic convertImageUrl];
            [self.pic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kImage(@"中国国旗")];
            self.PhoneCode.text = [NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]];
            
        }
    }else{
        NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
        CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (model) {
            NSString *url = [model.pic convertImageUrl];
            [self.pic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kImage(@"中国国旗")];
            self.PhoneCode.text = [NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]];
            
            
        }else{
            //
            CountryModel *model = self.countrys[0];
            self.pic.image = kImage(@"中国国旗");
            self.PhoneCode.text  = @"+86";
            
            
        }
        
    }
}
- (void)initTop
{
    
    
    if(self.type == TLPwdTypeForget) {
        self.backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.backButton.frame = CGRectMake(15, kStatusBarHeight+5, 40, 40);
        [self.backButton setImage:kImage(@"返回1-1") forState:(UIControlStateNormal)];
        [self.backButton addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:self.backButton];
        self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(54, kStatusBarHeight+5, kScreenWidth - 108, 44)];
        self.nameLable.text = [LangSwitcher switchLang:@"忘记密码" key:nil];
        self.nameLable.textAlignment = NSTextAlignmentCenter;
        self.nameLable.font = Font(16);
        self.nameLable.textColor = kTextBlack;
        [self.view addSubview:self.nameLable];
        
    } else if (self.type == TLPwdTypeReset) {
        
        self.nameLable.text = [LangSwitcher switchLang:@"修改登录密码" key:nil];
        
    } else if (self.type == TLPwdTypeTradeReset) {
        
        self.nameLable.text = [LangSwitcher switchLang:@"修改资金密码" key:nil];
        
    } else if (self.type == TLPwdTypeSetTrade) {
        
        self.nameLable.text = [LangSwitcher switchLang:@"设置资金密码" key:nil];
        
    }

    
}

- (void)buttonClick
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Init

- (void)setUpUI {
    
    CGFloat leftW = 100;
    
    //账号
    
    UIView *view = [[UIView alloc] init];
    
    [self.view addSubview:view];
    view.backgroundColor = kWhiteColor;
    view.frame = CGRectMake(0, 0, 100, 43);
    UIImageView *pic = [[UIImageView alloc] init];
    self.pic = pic;
    pic.userInteractionEnabled = YES;
//    NSString *url = [NSString stringWithFormat:@"%@.png",[TLUser user].userId];
//    [pic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kImage(@"中国国旗")];
//    pic.image = kImage(@"中国国旗");
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCountry)];
    
    [pic addGestureRecognizer:tap3];
    pic.contentMode = UIViewContentModeScaleToFill;
    pic.frame = CGRectMake(17, 13, 24, 16);
    [view addSubview:pic];
    UILabel *PhoneCode = [UILabel labelWithBackgroundColor:kWhiteColor textColor:kTextColor font:16];
    [view addSubview:PhoneCode];
    PhoneCode.text = [NSString stringWithFormat:@"+%@",[[TLUser user].interCode substringFromIndex:2]];
    self.PhoneCode = PhoneCode;
    PhoneCode.backgroundColor = kWhiteColor;

    [PhoneCode mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@13);
        make.left.equalTo(pic.mas_right).offset(5);
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
    TLTextField *phoneTf = [[TLTextField alloc] initWithFrame:CGRectMake(100, 0, kScreenWidth, 45)
                                                    leftTitle:[LangSwitcher switchLang:@"" key:nil]
                                                   titleWidth:0
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
                                                placeholder:[LangSwitcher switchLang:@"请输入密码" key:nil]];
    
    pwdTf.returnKeyType = UIReturnKeyNext;
    pwdTf.keyboardType = UIKeyboardTypePhonePad;
    pwdTf.maxCount = 6;
    [pwdTf addTarget:self action:@selector(next:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.bgSV addSubview:pwdTf];
    pwdTf.secureTextEntry = YES;
    self.pwdTf = pwdTf;
    
    //重新输入
    TLTextField *rePwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, pwdTf.yy + 1, phoneTf.width, phoneTf.height)
                                                    leftTitle:[LangSwitcher switchLang:@"确认密码" key:nil]
                                                   titleWidth:leftW
                                                  placeholder:[LangSwitcher switchLang:@"请确认密码" key:nil]];
    rePwdTf.keyboardType = UIKeyboardTypePhonePad;

    rePwdTf.returnKeyType = UIReturnKeyDone;
    rePwdTf.maxCount = 6;
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
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
    
    if (!self.captchaView.captchaTf.text) {
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的验证码" key:nil]];
        
        return;
    }
    
    if ((!self.pwdTf.text )) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入密码" key:nil]];
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
    NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
    CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (model) {
        http.parameters[@"countryCode"] = model.code;
    }
    
  

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
