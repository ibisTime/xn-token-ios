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
//腾讯云
//#import "ChatManager.h"   czy
//#import "IMModel.h"
//
//#import <ImSDK/TIMManager.h>

@interface TLUserLoginVC ()

@property (nonatomic,strong) TLTextField *phoneTf;
@property (nonatomic,strong) AccountTf *pwdTf;

@property (nonatomic, copy) NSString *verifyCode;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic ,strong) UIButton *accessoryImageView;
@property (nonatomic ,strong) UILabel *titlePhpne;
@property (nonatomic ,strong) UILabel *PhoneCode;
@end

@implementation TLUserLoginVC

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [LangSwitcher switchLang:@"登录" key:nil];
    
    [self setBarButtonItem];
    
    [self setUpUI];
    //腾讯云登录成功
//    [self setUpNotification];
    
}

#pragma mark - Init

- (void)setBarButtonItem {

    //取消按钮
   [UIBarButtonItem addLeftItemWithImageName:kCancelIcon frame:CGRectMake(-30, 0, 80, 44) vc:self action:@selector(back)];
    //注册
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
    
    UILabel *titleLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kBlackColor font:30];
    [bgView addSubview:titleLab];
    titleLab.text = [LangSwitcher switchLang:@"欢迎回来!" key:nil];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@30);
        make.left.mas_equalTo(20);
    }];
    //账号
    UILabel *titlePhpne = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    [bgView addSubview:titlePhpne];
    titlePhpne.text = [LangSwitcher switchLang:@"中国" key:nil];
    self.titlePhpne = titlePhpne;
    [titlePhpne mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(titleLab.mas_bottom).offset(40);
        make.left.mas_equalTo(20);
    }];
    UILabel *PhoneCode = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    [bgView addSubview:PhoneCode];
    PhoneCode.text = [LangSwitcher switchLang:@"+86" key:nil];
    self.PhoneCode = PhoneCode;
    PhoneCode.frame = CGRectMake(15, kHeight(134), 45, h);
    TLTextField *phone = [[TLTextField alloc] initWithFrame:CGRectMake(60, kHeight(134), w, h) leftTitle:[LangSwitcher switchLang:@"" key:nil] titleWidth:0 placeholder:[LangSwitcher switchLang:@"请输入手机号" key:nil]];
    phone.keyboardType = UIKeyboardTypeNumberPad;
    AccountTf *phoneTf = [[AccountTf alloc] initWithFrame:CGRectMake(0, kHeight(134), w-40, h)];
//    phoneTf.leftIconView.image = [UIImage imageNamed:@"手机"];
    
//    phoneTf.placeHolder = [LangSwitcher switchLang:@"请输入手机号码" key:nil];
    [bgView addSubview:phone];
    self.phoneTf = phone;
    phone.keyboardType = UIKeyboardTypeNumberPad;

    self.accessoryImageView = [[UIButton alloc] init];
    [bgView addSubview:self.accessoryImageView];
    [self.accessoryImageView setImage:kImage(@"更多-灰色") forState:UIControlStateNormal];
    [self.accessoryImageView addTarget:self action:@selector(chooseCountry) forControlEvents:UIControlEventTouchUpInside];
    [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(titlePhpne.mas_centerY).offset(0);
        make.right.mas_equalTo(-20);
        make.width.height.equalTo(@40);
    }];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kLineColor;
    [bgView addSubview:lineView];
    lineView.frame = CGRectMake(20, phoneTf.yy, w-40-40, 2);
    
    
    //密码
    AccountTf *pwdTf = [[AccountTf alloc] initWithFrame:CGRectMake(40, phoneTf.yy + 3, w-40, h)];
    pwdTf.secureTextEntry = YES;
//    pwdTf.leftIconView.image = [UIImage imageNamed:@"密码"];
    pwdTf.placeHolder = [LangSwitcher switchLang:@"请输入密码" key:nil];
    [bgView addSubview:pwdTf];
    self.pwdTf = pwdTf;
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLineColor;
    [bgView addSubview:line];
    line.frame = CGRectMake(20, pwdTf.yy, w-40-40, 2);
    
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
    UIButton *forgetPwdBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"忘记密码?" key:nil] titleColor:kTextColor2 backgroundColor:kClearColor titleFont:14.0];
    
    forgetPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetPwdBtn addTarget:self action:@selector(findPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPwdBtn];
    
    [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(loginBtn.mas_centerX);
        make.top.equalTo(loginBtn.mas_bottom).offset(18);

    }];
    
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
    countryVc.selectCountry = ^(CountryModel *model) {
        //更新国家 区号
        if ([LangSwitcher currentLangType] == LangTypeSimple) {
            weakSelf.titlePhpne.text = model.chineseName;

        }else if ([LangSwitcher currentLangType] == LangTypeEnglish){

            weakSelf.titlePhpne.text = model.interName;

        }else{
            weakSelf.titlePhpne.text = model.interName;

            
        }
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

- (void)findPwd {
    
    TLUserForgetPwdVC *vc = [[TLUserForgetPwdVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)goReg {
    
    TLUserRegisterVC *registerVC = [[TLUserRegisterVC alloc] init];
    self.title = [LangSwitcher switchLang:@"注册" key:nil];

    [self.navigationController pushViewController:registerVC animated:YES];
    
}

- (void)goLogin {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的手机号" key:nil]];
        
        return;
    }
    
    if (!(self.pwdTf.text &&self.pwdTf.text.length > 5)) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入6位以上密码" key:nil]];
        return;
    }
    if (!self.titlePhpne.text || !self.PhoneCode.text) {
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请选择国家" key:nil]];

        return;
    }
    [self.view endEditing:YES];

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_LOGIN_CODE;
    
    http.parameters[@"loginName"] = self.phoneTf.text;
    http.parameters[@"loginPwd"] = self.pwdTf.text;
    http.parameters[@"kind"] = APP_KIND;

    [http postWithSuccess:^(id responseObject) {
        
        [self requesUserInfoWithResponseObject:responseObject];
        
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
