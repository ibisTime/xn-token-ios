//
//  TLUserLoginVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLUserLoginVC.h"

#import "BindMobileVC.h"
#import "TLUserRegisterVC.h"
#import "TLUserForgetPwdVC.h"

#import "APICodeMacro.h"
#import "AppMacro.h"
#import "NSString+Check.h"
#import "UIBarButtonItem+convience.h"
#import "UILabel+Extension.h"

#import "CurrencyModel.h"

#import "AccountTf.h"
#import "ChooseCountryVc.h"
#import "TLTabBarController.h"
#import "TLCaptchaView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Extension.h"
#import "TLUserFindPwdVC.h"

#import <UMMobClick/MobClick.h>
//腾讯云
//#import "ChatManager.h"   czy
//#import "IMModel.h"
//
//#import <ImSDK/TIMManager.h>

@interface TLUserLoginVC ()<UITextFieldDelegate>

@property (nonatomic,strong) TLTextField *phoneTf;
@property (nonatomic,strong) AccountTf *pwdTf;

@property (nonatomic, copy) NSString *verifyCode;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic ,strong) UIImageView *accessoryImageView;
@property (nonatomic ,strong) UILabel *titlePhpne;
@property (nonatomic ,strong) UILabel *PhoneCode;
@property (nonatomic ,strong) UIButton *forgetPwdBtn;
@property (nonatomic ,strong) UILabel *forgetLab;
@property (nonatomic ,strong) UIButton *codeButton;
@property (nonatomic ,strong) TLCaptchaView *captchaView;
@property (nonatomic ,strong)  UIImageView *pic;

@property (nonatomic,strong) NSMutableArray <CountryModel *>*countrys;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) CountryModel *model;


@end

@implementation TLUserLoginVC

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [LangSwitcher switchLang:@"登录" key:nil];
    
    [self setUpUI];

    [self loadData];

    [self changeCodeLogin];
    
 
//    if ([dic hasPrefix:@"CN"]) {
//
//
//    }else{
//
//        self.pic.image = kImage(@"中国国旗");
//
//        self.PhoneCode.text = [LangSwitcher switchLang:@"+60" key:nil];
//
//    }
//    NSLog(@"%@",dic);
    //腾讯云登录成功
//    [self setUpNotification];
    

}

- (void)configData
{
    NSString *money ;
   
    
    //获取缓存的国家
    NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
    
    //有缓存加载缓存国家
    if (data) {
        
        CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        //如果国家编号不为空，说明是1.7.0之后缓存的，直接设置即可
        if ([model.code isNotBlank]) {
            
            NSString *url = [model.pic convertImageUrl];
            
            [self.pic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kImage(@"中国国旗")];
            
            self.PhoneCode.text = [NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]];
        
        }
        //如果国家编号为空，说明是1.7.0之前缓存的，需要移除
        else {
            
            CountryModel *defaultCountry = [self.countrys objectAtIndex:0];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:defaultCountry];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"chooseModel"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *url = [defaultCountry.pic convertImageUrl];
            [self.pic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kImage(@"中国国旗")];
            self.PhoneCode.text = [NSString stringWithFormat:@"+%@",[defaultCountry.interCode substringFromIndex:2]];
            if ([defaultCountry.interSimpleCode isEqualToString:@"CN"] ||[defaultCountry.interSimpleCode isEqualToString:@"HK"] ||[model.interSimpleCode isEqualToString:@"TW"] || [defaultCountry.interSimpleCode isEqualToString:@"MO"]) {
                [LangSwitcher changLangType:LangTypeSimple];
                
                    money = @"CNY";
               
                    
            
            }else if ([defaultCountry.interSimpleCode isEqualToString:@"KR"] || [defaultCountry.interSimpleCode isEqualToString:@"KO"] )
            {
                [LangSwitcher changLangType:LangTypeKorean];
                money = @"KRW";

            }else{
                
                [LangSwitcher changLangType:LangTypeEnglish];
                money = @"USD";

            }
        }
        
    }
    //没有缓存加载网络请求国家中的中国
    else {
        
        CountryModel *defaultCountry = [self.countrys objectAtIndex:0];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:defaultCountry];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"chooseModel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *url = [defaultCountry.pic convertImageUrl];
        [self.pic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kImage(@"中国国旗")];
        self.PhoneCode.text = [NSString stringWithFormat:@"+%@",[defaultCountry.interCode substringFromIndex:2]];
        if ([defaultCountry.interSimpleCode isEqualToString:@"CN"] ||[defaultCountry.interSimpleCode isEqualToString:@"HK"] ||[defaultCountry.interSimpleCode isEqualToString:@"TW"] || [defaultCountry.interSimpleCode isEqualToString:@"MO"]) {
            [LangSwitcher changLangType:LangTypeSimple];
            
            money = @"CNY";
            
            
            
        }else if ([defaultCountry.interSimpleCode isEqualToString:@"KR"] || [defaultCountry.interSimpleCode isEqualToString:@"KO"] )
        {
            [LangSwitcher changLangType:LangTypeKorean];
            money = @"KRW";
            
        }else{
            
            [LangSwitcher changLangType:LangTypeEnglish];
            money = @"USD";
            
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:money forKey:KLocalMoney];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)configData_bak
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
#pragma mark - Init

- (void)loadData {

    
    //获取国家列表
    TLNetworking *net = [TLNetworking new];
    net.showView = self.view;
    net.code = @"801120";
    net.isLocal = YES;
    net.ISparametArray = YES;
    net.parameters[@"status"] = @"1";
    [net postWithSuccess:^(id responseObject) {
        
        self.countrys = [CountryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];

        [self configData];

    } failure:^(NSError *error) {
        
    }];

    
//    [UIBarButtonItem addRightItemWithTitle:[LangSwitcher switchLang:@"注册" key:nil] titleColor:kTextColor frame:CGRectMake(0, 0, 60, 44) vc:self action:@selector(goReg)];
}

- (void)setUpUI {
    
    self.view.backgroundColor = kBackgroundColor;
    
    CGFloat w = kScreenWidth;
    CGFloat h = ACCOUNT_HEIGHT;
    
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled  = YES;
    imageView.image = kImage(@"登录背景");
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(@(0));
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        
    }];
    
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.contentMode = UIViewContentModeScaleToFill;
    [imageView addSubview:logoView];
    logoView.image = kImage(@"logo");
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(@(43+kStatusBarHeight));
        make.centerX.mas_equalTo(imageView.mas_centerX);
        make.width.mas_equalTo(@108);
        make.height.mas_equalTo(@49);
        
    }];
    
     UIView *bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = kWhiteColor;
    bgView.layer.cornerRadius = 12;
    bgView.clipsToBounds = YES;
    
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(kHeight(139)));
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(@(kHeight(416)));
        make.width.mas_equalTo(w-40);
        
    }];
    
    //找回密码
    UIButton *registBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"立即注册" key:nil] titleColor:kAppCustomMainColor backgroundColor:kWhiteColor titleFont:14.0];
    
//    registBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [registBtn addTarget:self action:@selector(goReg) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:registBtn];
    registBtn.layer.cornerRadius = 5;
    registBtn.clipsToBounds = YES;
    if ([LangSwitcher currentLangType] == LangTypeEnglish) {
        [registBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 80, 0, 0 )];

    }else{
        [registBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0 )];

    }
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(bgView.mas_centerX);
        make.top.equalTo(bgView.mas_bottom).offset(-5);
        make.width.equalTo(@(kWidth(295)));
        make.height.equalTo(@(57));

        
    }];
    UILabel *title = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    title.textAlignment = NSTextAlignmentCenter;
    [registBtn addSubview:title];
    title.text = [LangSwitcher switchLang:@"还没账号?" key:nil];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(registBtn.mas_centerX).offset(-5);
        make.centerY.equalTo(registBtn.mas_centerY);
    }];
    
    UILabel *titleLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15];
    [bgView addSubview:titleLab];
    titleLab.text = [LangSwitcher switchLang:@"手机号" key:nil];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@50);
        make.left.mas_equalTo(20);
    }];
    //账号
//    UILabel *titlePhpne = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
//    [bgView addSubview:titlePhpne];
//    titlePhpne.text = [LangSwitcher switchLang:@"中国" key:nil];
//    self.titlePhpne = titlePhpne;
//    [titlePhpne mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(titleLab.mas_bottom).offset(40);
//        make.left.mas_equalTo(20);
//    }];
    
    
    UIImageView *pic = [[UIImageView alloc] init];
    self.pic = pic;
    pic.userInteractionEnabled = YES;
//    pic.image = kImage(@"中国国旗");
   

    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCountry)];
    
    [pic addGestureRecognizer:tap3];
    pic.contentMode = UIViewContentModeScaleToFill;
    pic.frame = CGRectMake(17, kHeight(114-40)+17.5, 24, 16);
    [bgView addSubview:pic];
    UILabel *PhoneCode = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:12];
    PhoneCode.userInteractionEnabled = YES;
    [bgView addSubview:PhoneCode];
//    PhoneCode.text = [LangSwitcher switchLang:@"+86" key:nil];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCountry)];
    [PhoneCode addGestureRecognizer:tap2];
    PhoneCode.textAlignment = NSTextAlignmentCenter;
    self.PhoneCode = PhoneCode;
    PhoneCode.frame = CGRectMake(40, kHeight(114-40), 55, h);
    
        self.accessoryImageView = [[UIImageView alloc] init];
        [bgView addSubview:self.accessoryImageView];
        self.accessoryImageView.image = kImage(@"TriangleNomall");
//        [self.accessoryImageView addTarget:self action:@selector(chooseCountry) forControlEvents:UIControlEventTouchUpInside];
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
//      TLTextField *pwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, pwdLab.yy + 10, w, h) leftTitle:[LangSwitcher switchLang:@"" key:nil] titleWidth:titleWidth placeholder:[LangSwitcher switchLang:@"请输入密码(不少于6位)" key:nil]];
    TLTextField *phone = [[TLTextField alloc] initWithFrame:CGRectMake(120, kHeight(114-40), w-140, h) leftTitle:[LangSwitcher switchLang:@"" key:nil] titleWidth:0 placeholder:[LangSwitcher switchLang:@"请输入手机号" key:nil]];
    phone.keyboardType = UIKeyboardTypeNumberPad;
//    AccountTf *phoneTf = [[AccountTf alloc] initWithFrame:CGRectMake(0, kHeight(114-40), w-40, h)];
//    phoneTf.leftIconView.image = [UIImage imageNamed:@"手机"];
    
//    phoneTf.placeHolder = [LangSwitcher switchLang:@"请输入手机号码" key:nil];
    [bgView addSubview:phone];
    self.phoneTf = phone;
    phone.keyboardType = UIKeyboardTypeNumberPad;


    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kLineColor;
    [bgView addSubview:lineView];
    lineView.frame = CGRectMake(20, phone.yy, w-40-40, 2);
    
    
    //密码
    AccountTf *pwdTf = [[AccountTf alloc] initWithFrame:CGRectMake(15, phone.yy + 3, w-180, h)];
    pwdTf.secureTextEntry = YES;
//    pwdTf.leftIconView.image = [UIImage imageNamed:@"密码"];
    pwdTf.placeHolder = [LangSwitcher switchLang:@"请输入密码" key:nil];
    [bgView addSubview:pwdTf];
//    pwdTf.keyboardType = UIKeyboardTypePhonePad;
    pwdTf.returnKeyType = UIReturnKeyDone;
    pwdTf.delegate =self;
    self.pwdTf = pwdTf;
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLineColor;
    [bgView addSubview:line];
    line.frame = CGRectMake(20, pwdTf.yy, w-40-40, 2);
    
    UILabel *forgetLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    forgetLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:forgetLab];
    forgetLab.userInteractionEnabled = YES;
    forgetLab.frame = CGRectMake(w-180, phone.yy, 160, h);
    forgetLab.text = [LangSwitcher switchLang:@"忘记密码?" key:nil];
    self.forgetLab = forgetLab;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findPwd)];
    
    [forgetLab addGestureRecognizer:tap1];
    //验证码
    TLCaptchaView *captchaView = [[TLCaptchaView alloc] initWithFrame:CGRectMake(-70, phone.yy + 1, w-30+50, phone.height)];
    captchaView.captchaTf.leftLbl.text = @"";
    captchaView.captchaTf.leftLbl.frame = CGRectZero;
    captchaView.captchaBtn.frame = CGRectMake(0, 7, 85, h - 15);
    [bgView addSubview:captchaView];
    self.captchaView = captchaView;
    captchaView.captchaTf.keyboardType = UIKeyboardTypePhonePad;
    captchaView.captchaTf.returnKeyType = UIReturnKeyDone;
    captchaView.captchaTf.delegate =self;

    captchaView.hidden = YES;
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
//    UIButton *codeButton = [UIButton buttonWithTitle:@"获取验证码" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:14 cornerRadius:3.0];
//    self.codeButton = codeButton;
//    codeButton.layer.borderWidth = 1.0;
//    codeButton.layer.borderColor = kAppCustomMainColor.CGColor;
////    [bgView addSubview:codeButton];
//    codeButton.frame = CGRectMake(w-180, phone.yy+7, 120, h-10);;
//    codeButton.hidden = YES;
//    
//    [codeButton addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findPwd)];
//    [forgetLab addGestureRecognizer:tap];
    
//    for (int i = 0; i < 2; i++) {
//
//        UIView *line = [[UIView alloc] init];
//
//        line.backgroundColor = kLineColor;
//
//        [bgView addSubview:line];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//            make.height.mas_equalTo(0.5);
//            make.top.mas_equalTo((i+1)*h);
//
//        }];
//    }
    //登录
    UIButton *loginBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"登录" key:nil] titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:17.0 cornerRadius:5];
    [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(20));
        make.height.equalTo(@(h ));
        make.right.equalTo(@(-20));
        make.top.equalTo(pwdTf.mas_bottom).offset(30);
        
    }];
    
    //找回密码
    UIButton *forgetPwdBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"验证码快捷登录" key:nil] titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:14.0];
    self.forgetPwdBtn = forgetPwdBtn;
     [forgetPwdBtn setTitle:[LangSwitcher switchLang:@"账号密码登录" key:nil] forState:UIControlStateSelected];
    forgetPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetPwdBtn addTarget:self action:@selector(changeCodeLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPwdBtn];
    
    [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(loginBtn.mas_centerX);
        make.top.equalTo(loginBtn.mas_bottom).offset(18);

    }];
    
}

- (void)sendCaptcha
{
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的手机号" key:nil]];
        
        return;
    }
    
    
    
        //发送验证码
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = CAPTCHA_CODE;
        http.parameters[@"bizType"] = @"805044";
        http.parameters[@"mobile"] = self.phoneTf.text;
        http.parameters[@"interCode"] = [NSString stringWithFormat:@"00%@",[self.PhoneCode.text substringFromIndex:1]];;
        
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:[LangSwitcher switchLang:@"验证码已发送,请注意查收" key:nil]];
            
            [self.captchaView.captchaBtn begin];
            
        } failure:^(NSError *error) {
            
        }];
        
    
    
}
- (void)changeCodeLogin
{
    self.forgetPwdBtn.selected = !self.forgetPwdBtn.selected;
   
    self.forgetLab.hidden = !self.forgetLab.hidden;
    self.codeButton.hidden = !self.codeButton.hidden;
    self.pwdTf.hidden = !self.pwdTf.hidden;
    self.captchaView.hidden = !self.captchaView.hidden;
}

//- (void)setUpNotification {
//
//    //登录成功之后，给予回调
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:kUserLoginNotification object:nil];
//
//}

#pragma mark - Events

- (void)chooseCountry
{
    
    //选择国家 设置区号
    CoinWeakSelf;
    ChooseCountryVc *countryVc = [ChooseCountryVc new];
//    countryVc.interCode = [NSString stringWithFormat:@"00%@",[self.PhoneCode.text substringFromIndex:1]];
    countryVc.selectCountry = ^(CountryModel *model) {
        //更新国家 区号
        self.model = model;
        self.code = model.code;
        [self.pic sd_setImageWithURL:[NSURL URLWithString:[model.pic convertImageUrl]]];
        weakSelf.PhoneCode.text = [NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]];
    } ;
    [self presentViewController:countryVc animated:YES completion:nil];
}

- (void)back {
    
    if (self.NeedLogin == YES) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.view endEditing:YES];
 
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//登录成功
//- (void)login {
//
//
//    // apple delegate
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
//
//    [self dismissViewControllerAnimated:YES completion:nil];
//
//    if (self.loginSuccess) {
//
//        self.loginSuccess();
//    }
//
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [self goLogin];
    
    return YES;
    
}
- (void)findPwd {
    
    TLUserFindPwdVC *vc = [[TLUserFindPwdVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)goReg {
    
    TLUserRegisterVC *registerVC = [[TLUserRegisterVC alloc] init];
    self.title = [LangSwitcher switchLang:@"注册" key:nil];

    [self.navigationController pushViewController:registerVC animated:YES];
    
}

- (void)goLogin {
    
    if (![self.phoneTf.text isPhoneNum] ) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的手机号" key:nil]];
        
        return;
    }
    
    if ((!self.pwdTf.text ) && self.pwdTf.hidden == NO) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入密码" key:nil]];
        return;
    }
    if (!self.PhoneCode.text) {
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请选择国家" key:nil]];

        return;
    }
    
    if (![self.captchaView.captchaTf.text isPhoneNum] &&self.captchaView.hidden == NO) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入验证码" key:nil]];
        return;
    }
    [self.view endEditing:YES];

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    if (self.captchaView.hidden == NO) {
        //验证码登录
        http.code = @"805044";

    http.parameters[@"mobile"] = self.phoneTf.text;
    NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
    CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([model.code isNotBlank]) {
            http.parameters[@"countryCode"] = model.code;
            
        }else{
            
            http.parameters[@"countryCode"] =  self.countrys[0].code;

        }
        
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;

        
    }else{
        
        NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
        CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        http.code = USER_LOGIN_CODE;
        if ([model.code isNotBlank]) {
            
                http.parameters[@"countryCode"] = model.code;
            }else {
                http.parameters[@"countryCode"] =  self.countrys[0].code;

            }
        
    http.parameters[@"loginName"] = self.phoneTf.text;
    http.parameters[@"loginPwd"] = self.pwdTf.text;
    http.parameters[@"kind"] = APP_KIND;
    }
    http.parameters[@"client"] = @"ios";

    
    [http postWithSuccess:^(id responseObject) {
        NSLog(@"%@",responseObject[@"data"][@"userId"]);
        [self requesUserInfoWithResponseObject:responseObject];
        [MobClick profileSignInWithPUID:responseObject[@"data"][@"userId"]];
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)requesUserInfoWithResponseObject:(id)responseObject {
    
    NSString *token = responseObject[@"data"][@"token"];
    NSString *userId = responseObject[@"data"][@"userId"];
    
    //保存用户账号和密码
//    [[TLUser user] saveUserName:self.phoneTf.text pwd:self.pwdTf.text];
    
    //1.获取用户信息
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_INFO;
    http.parameters[@"userId"] = userId;
    http.parameters[@"token"] = token;
    [http postWithSuccess:^(id responseObject) {
        
        NSDictionary *userInfo = responseObject[@"data"];
        
        [TLUser user].userId = userId;
        [TLUser user].token = token;
        
        //保存用户信息
        [[TLUser user] saveUserInfo:userInfo];
        //初始化用户信息
        [[TLUser user] setUserInfoWithDict:userInfo];
        //
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if (self.loginSuccess) {
            
            self.loginSuccess();
        }
        
        if (self.IsAPPJoin == YES) {
             [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
            self.NeedLogin = NO;
            [self.navigationController popToRootViewControllerAnimated:YES];
         TLTabBarController*tab   = [[TLTabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
            
            return ;
        }
        self.NeedLogin = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

//
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    
    NSLog(@"TagsAlias回调:%@", callbackString);
}

- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}




@end
