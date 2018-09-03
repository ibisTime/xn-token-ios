//
//  TLUserFindPwdVC.m
//  Coin
//
//  Created by shaojianfei on 2018/7/12.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLUserFindPwdVC.h"
#import "CaptchaView.h"
#import "NSString+Check.h"
#import "APICodeMacro.h"
#import "UIBarButtonItem+convience.h"
#import "ChooseCountryVc.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Extension.h"
#import "CountryModel.h"
@interface TLUserFindPwdVC ()
@property (nonatomic,strong) TLTextField *phoneTf;

@property (nonatomic,strong) TLTextField *pwdTf;

@property (nonatomic,strong) TLTextField *rePwdTf;

@property (nonatomic, strong) CaptchaView *captchaView;
@property (nonatomic ,strong) UILabel *titlePhpne;
@property (nonatomic ,strong) UILabel *PhoneCode;
@property (nonatomic ,strong) UIImageView *accessoryImageView;
@property (nonatomic ,strong) UIImageView *pic;

@property (nonatomic,strong) NSMutableArray <CountryModel *>*countrys;
@end

@implementation TLUserFindPwdVC

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self loadData];
    [self configData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([TLUser user].loginPwdFlag == 1) {
        self.title = [LangSwitcher switchLang:@"找回登录密码" key:nil];
        
    }else{
        self.title = [LangSwitcher switchLang:@"设置登录密码" key:nil];
        
    }
    
    self.view.backgroundColor = kWhiteColor;
    
    [self initSubviews];
   
}
- (void)configData
{
    
    BOOL isChoose =  [[NSUserDefaults standardUserDefaults] boolForKey:@"chooseCoutry"];
    
    if (isChoose == YES) {
        
        
        NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
        CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([model.code isNotBlank]) {
            NSString *url = [model.pic convertImageUrl];
            
            [self.pic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kImage(@"中国国旗")];
            self.PhoneCode.text = [NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]];
        }else {
            for (CountryModel *country in self.countrys) {
                if ([country.interCode isEqualToString:model.interCode]) {
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:country];
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"chooseModel"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSString *url = [country.pic convertImageUrl];
                    
                    [self.pic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kImage(@"中国国旗")];
                    self.PhoneCode.text = [NSString stringWithFormat:@"+%@",[country.interCode substringFromIndex:2]];
                }
            }
        }
        
    }else{
        
        CountryModel *model = self.countrys[0];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"chooseModel"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"chooseCoutry"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *url = [model.pic convertImageUrl];
        
        [self.pic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kImage(@"中国国旗")];
        self.PhoneCode.text = [NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]];
        
        
        
    }
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
        
        for (int i = 0; i < self.countrys.count; i++) {
            
            CountryModel *model = self.countrys[i];
            NSString *code =[TLUser user].interCode;
            if (code == model.interCode) {
                NSString *url = [model.pic convertImageUrl];
                [self.pic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kImage(@"中国国旗")];
                self.PhoneCode.text = [NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]];
            }
        }
        
        //        [self.tableView reloadData];
        //        NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"data"]];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthResult" object:str];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    
}
- (void)initSubviews {
    
    self.view.backgroundColor = kWhiteColor;
    
    CGFloat margin = ACCOUNT_MARGIN;
    CGFloat w = kScreenWidth - 2*margin;
    CGFloat h = ACCOUNT_HEIGHT;
    
    CGFloat btnMargin = 15;
    //    UILabel *lab = [UILabel labelWithBackgroundColor:kWhiteColor textColor:kBlackColor font:30];
    //    lab.text = @"找回密码!";
    //    [self.view addSubview:lab];
    //    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(@40);
    //        make.left.equalTo(@30);
    //
    //
    //    }];
    //账号
    //    UILabel *titlePhone = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    //    [self.view addSubview:titlePhone];
    //    titlePhone.text = [LangSwitcher switchLang:@"中国" key:nil];
    //    self.titlePhpne = titlePhone;
    //    [titlePhone mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.top.equalTo(lab.mas_bottom).offset(20);
    //        make.left.mas_equalTo(20);
    //    }];
    //    //账号
    //    UILabel *sureLab = [UILabel labelWithTitle:@"手机号" frame:CGRectMake(20, kHeight(122), w, 22)];
    //    sureLab.font = [UIFont systemFontOfSize:14];
    //    sureLab.textAlignment = NSTextAlignmentLeft;
    //    sureLab.textColor = kTextColor;
    //    [self.view addSubview:sureLab];
    //
    
    
    UIImageView *pic = [[UIImageView alloc] init];
    self.pic = pic;
    pic.image = kImage(@"中国国旗");
        pic.userInteractionEnabled = YES;
    
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCountry)];
    
        [pic addGestureRecognizer:tap3];
    pic.contentMode = UIViewContentModeScaleToFill;
    pic.frame = CGRectMake(17, kHeight(30), 24, 16);
    [self.view addSubview:pic];
    UILabel *PhoneCode = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    [self.view addSubview:PhoneCode];
        PhoneCode.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCountry)];
    
        [PhoneCode addGestureRecognizer:tap2];
    PhoneCode.text = [LangSwitcher switchLang:@"+86" key:nil];
    self.PhoneCode = PhoneCode;
    [PhoneCode mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(30));
        make.left.mas_equalTo(45);
    }];
    
    self.accessoryImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.accessoryImageView];
    self.accessoryImageView.image = kImage(@"TriangleNomall");
//    [self.accessoryImageView addTarget:self action:@selector(chooseCountry) forControlEvents:UIControlEventTouchUpInside];
        self.accessoryImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCountry)];
        [self.accessoryImageView addGestureRecognizer:tap];
    
    self.accessoryImageView.contentMode = UIViewContentModeScaleToFill;
    [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(PhoneCode.mas_centerY);
        make.left.mas_equalTo(PhoneCode.mas_right).offset(5);
        make.width.equalTo(@14);
        make.height.equalTo(@7);
        
    }];
    TLTextField *phoneTf = [[TLTextField alloc] initWithFrame:CGRectMake(100, 15, w-95, h) leftTitle:[LangSwitcher switchLang:@"" key:nil] titleWidth:20 placeholder:[LangSwitcher switchLang:@"请输入手机号" key:nil]];
    
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneTf];
    self.phoneTf = phoneTf;
    if ([TLUser user].isLogin) {
        phoneTf.text = [TLUser user].mobile;
    }
    UIView *phone = [[UIView alloc] init];
    [self.view addSubview:phone];
    phone.backgroundColor = kLineColor;
    phone.frame = CGRectMake(btnMargin, phoneTf.yy, w-30, 1);
    //验证码
    
    UILabel *codeLab = [UILabel labelWithTitle:[LangSwitcher switchLang:@"验证码" key:nil] frame:CGRectMake(20, phoneTf.yy, w, 22)];
    codeLab.font = [UIFont systemFontOfSize:14];
    codeLab.textAlignment = NSTextAlignmentLeft;
    codeLab.textColor = kTextColor;
    [self.view addSubview:codeLab];
    CaptchaView *captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(margin, codeLab.yy + 1, w, h)];
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:captchaView];
    captchaView.captchaTf.keyboardType = UIKeyboardTypePhonePad;

    self.captchaView = captchaView;
    UIView *phone2 = [[UIView alloc] init];
    [self.view addSubview:phone2];
    phone2.backgroundColor = kLineColor;
    phone2.frame = CGRectMake(btnMargin, captchaView.yy, w-30, 1);
    //密码
    UILabel *pwdLab = [UILabel labelWithTitle:[LangSwitcher switchLang:@"密码" key:nil] frame:CGRectMake(20, captchaView.yy, w, 22)];
    pwdLab.font = [UIFont systemFontOfSize:14];
    pwdLab.textAlignment = NSTextAlignmentLeft;
    pwdLab.textColor = kTextColor;
    [self.view addSubview:pwdLab];
    
    TLTextField *pwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, pwdLab.yy + 10, w, h) leftTitle:[LangSwitcher switchLang:@"" key:nil] titleWidth:20 placeholder:[LangSwitcher switchLang:@"请输入密码" key:nil]];
    pwdTf.secureTextEntry = YES;
    pwdTf.returnKeyType = UIReturnKeyNext;
    [pwdTf addTarget:self action:@selector(next) forControlEvents:UIControlEventEditingDidEndOnExit];

//    pwdTf.keyboardType = UIKeyboardTypePhonePad;

    [self.view addSubview:pwdTf];
    self.pwdTf = pwdTf;
    UIView *phone3 = [[UIView alloc] init];
    [self.view addSubview:phone3];
    phone3.backgroundColor = kLineColor;
    phone3.frame = CGRectMake(btnMargin, pwdTf.yy, w-30, 1);
    //re密码
    UILabel *pLab = [UILabel labelWithTitle:[LangSwitcher switchLang:@"密码" key:nil] frame:CGRectMake(20, pwdTf.yy, w, 22)];
    pLab.font = [UIFont systemFontOfSize:14];
    pLab.textAlignment = NSTextAlignmentLeft;
    pLab.textColor = kTextColor;
    [self.view addSubview:pLab];
    TLTextField *rePwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, pLab.yy + 1, w, h) leftTitle:[LangSwitcher switchLang:@"" key:nil] titleWidth:20 placeholder:[LangSwitcher switchLang:@"确认密码" key:nil]];
    rePwdTf.secureTextEntry = YES;
    rePwdTf.returnKeyType = UIReturnKeyNext;
    [rePwdTf addTarget:self action:@selector(next1) forControlEvents:UIControlEventEditingDidEndOnExit];

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
    //    self.accessoryImageView = [[UIButton alloc] init];
    ////    self.accessoryImageView.frame = CGRectMake(kScreenWidth - 40-40, 90, 40, 40);
    //    [self.view addSubview:self.accessoryImageView];
    //    [self.accessoryImageView setImage:kImage(@"更多-灰色") forState:UIControlStateNormal];
    //    [self.accessoryImageView addTarget:self action:@selector(chooseCountry) forControlEvents:UIControlEventTouchUpInside];
    //        [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //            make.centerY.equalTo(titlePhone.mas_centerY).offset(0);
    //            make.right.mas_equalTo(-20);
    //            make.width.height.equalTo(@40);
    //        }];
    UIButton *confirmBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"下一步" key:nil] titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    
    [confirmBtn addTarget:self action:@selector(changePwd) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(btnMargin);
        make.width.mas_equalTo(kScreenWidth - 2*btnMargin);
        make.height.mas_equalTo(h - 5);
        make.top.mas_equalTo(rePwdTf.mas_bottom).mas_equalTo(40);
        
    }];
}

- (void)next
{
    [self.pwdTf resignFirstResponder];
    [self.rePwdTf becomeFirstResponder];
    
}
- (void)next1
{
    [self.rePwdTf resignFirstResponder];

    [self changePwd];
}
- (void)chooseCountry
{
    
    //选择国家 设置区号
    CoinWeakSelf;
    ChooseCountryVc *countryVc = [ChooseCountryVc new];
//     countryVc.interCode = [NSString stringWithFormat:@"00%@",[self.PhoneCode.text substringFromIndex:1]];
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
    
    if (![self.phoneTf.text isBlank]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的手机号" key:nil]];
        
        return;
    }
    
    if ([self.captchaView.captchaTf.text isBlank] ) {
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的验证码" key:nil]];
        
        return;
    }
    
    if (([self.pwdTf.text isBlank])) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入密码" key:nil]];
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
    
    NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
    CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (model) {
        http.parameters[@"countryCode"] = model.code;
        
    }else{
        
        http.parameters[@"countryCode"] =  self.countrys[0].code;
        
    }
    
    [http postWithSuccess:^(id responseObject) {
        if ([TLUser user].loginPwdFlag  == 1) {
            [TLAlert alertWithSucces:[LangSwitcher switchLang:@"修改成功" key:nil]];
            
        }else{
            [TLAlert alertWithSucces:[LangSwitcher switchLang:@"设置成功" key:nil]];
            
            
        }
        [[TLUser user] updateUserInfo];
        
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
