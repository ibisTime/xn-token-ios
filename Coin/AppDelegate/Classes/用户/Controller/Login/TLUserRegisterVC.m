//
//  TLUserRegisterVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "TLUserRegisterVC.h"
//#import "SGScanningQRCodeVC.h"
#import <MSAuthSDK/MSAuthVCFactory.h>
#import <Photos/Photos.h>
#import "TLNavigationController.h"
#import "HTMLStrVC.h"
#import "UIBarButtonItem+convience.h"
#import <CoreLocation/CoreLocation.h>

#import "CaptchaView.h"
#import "APICodeMacro.h"
#import "NSString+Check.h"
#import "ChooseCountryVc.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Extension.h"

#import <UMMobClick/MobClick.h>

#import "TLTabBarController.h"
#import <SecurityGuardSDK/JAQ/SecurityVerification.h>
#import <MSAuthSDK/MSAuthVCFactory.h>
#import <MSAuthSDK/MSAuthSDK.h>
#import <SecurityGuardSDK/JAQ/SecurityVerification.h>


@interface TLUserRegisterVC ()<CLLocationManagerDelegate,MSAuthProtocol>

@property (nonatomic,strong) CaptchaView *captchaView;
//昵称
@property (nonatomic, strong) TLTextField *nickNameTF;
@property (nonatomic, strong) TLTextField *referTF;


@property (nonatomic,strong) TLTextField *phoneTf;

@property (nonatomic,strong) TLTextField *pwdTf;

@property (nonatomic,strong) TLTextField *rePwdTf;

//@property (nonatomic,strong) CLLocationManager *sysLocationManager;
//
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;
//同意按钮
@property (nonatomic, strong) UIButton *checkBtn;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic ,strong) UILabel *titlePhpne;
@property (nonatomic ,strong) UILabel *PhoneCode;
@property (nonatomic ,strong) UIImageView *accessoryImageView;
@property (nonatomic ,strong) UIImageView *pic;
@property (nonatomic,strong) NSMutableArray <CountryModel *>*countrys;

@end

@implementation TLUserRegisterVC
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //取消按钮
//    [UIBarButtonItem addLeftItemWithImageName:kCancelIcon frame:CGRectMake(-20, 0, 40, 60) vc:self action:@selector(back)];
    self.navigationController.navigationBar.hidden = NO;
    self.title = [LangSwitcher switchLang:@"注册" key:nil];

    [self setUpUI];
    [self loadData];


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

- (void)back {
    
   
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Events

- (void)setUpUI {
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    contentScrollView.backgroundColor = kWhiteColor;
    self.contentScrollView = contentScrollView;
    [self.view addSubview:contentScrollView];
    self.view.backgroundColor = kWhiteColor;
    
    CGFloat margin = ACCOUNT_MARGIN;
    CGFloat w = kScreenWidth - 2*margin;
    CGFloat h = ACCOUNT_HEIGHT;
    CGFloat titleWidth = 20;
    
    CGFloat btnMargin = 15;
//    UILabel *lab = [UILabel labelWithBackgroundColor:kWhiteColor textColor:kBlackColor font:30];
//    lab.text = [LangSwitcher switchLang:@"注册!" key:nil];
//    [self.contentScrollView addSubview:lab];
//    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@20);
//        make.left.equalTo(@30);
//
//
//    }];
    //账号
//    UILabel *titlePhone = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
//    [self.contentScrollView addSubview:titlePhone];
//    titlePhone.text = [LangSwitcher switchLang:@"中国" key:nil];
//    self.titlePhpne = titlePhone;
//    [titlePhone mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(lab.mas_bottom).offset(40);
//        make.left.mas_equalTo(20);
//    }];
   
  

//    UILabel *titlePhpne = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
//    [self.contentScrollView addSubview:titlePhpne];
//    titlePhpne.text = [LangSwitcher switchLang:@"手机号" key:nil];
//    titlePhpne.frame = CGRectMake(btnMargin, kHeight(144)+5, w-30, 22);

    UIImageView *pic = [[UIImageView alloc] init];
    self.pic = pic;
    pic.userInteractionEnabled = YES;
    pic.image = kImage(@"中国国旗");
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCountry)];
    
    [pic addGestureRecognizer:tap3];
    pic.contentMode = UIViewContentModeScaleToFill;
    pic.frame = CGRectMake(17, kHeight(30), 24, 16);
    [self.contentScrollView addSubview:pic];
    UILabel *PhoneCode = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    PhoneCode.userInteractionEnabled = YES;
    [self.contentScrollView addSubview:PhoneCode];
    PhoneCode.text = [LangSwitcher switchLang:@"+86" key:nil];
    self.PhoneCode = PhoneCode;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCountry)];
    
    [PhoneCode addGestureRecognizer:tap2];
    [PhoneCode mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(30));
        make.left.mas_equalTo(45);
    }];
    
    self.accessoryImageView = [[UIImageView alloc] init];
    [self.contentScrollView addSubview:self.accessoryImageView];
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
    
    //账号
    TLTextField *phoneTf = [[TLTextField alloc] initWithFrame:CGRectMake(100, 15, w-95, h) leftTitle:[LangSwitcher switchLang:@"" key:nil] titleWidth:titleWidth placeholder:[LangSwitcher switchLang:@"请输入手机号" key:nil]];
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentScrollView addSubview:phoneTf];
    self.phoneTf = phoneTf;
    
    UIView *phone = [[UIView alloc] init];
    [self.contentScrollView addSubview:phone];
    phone.backgroundColor = kLineColor;
    phone.frame = CGRectMake(btnMargin, phoneTf.yy, w-30, 2);
    
    UILabel *codeLab = [UILabel labelWithTitle:[LangSwitcher switchLang:@"验证码" key:nil] frame:CGRectMake(20, phoneTf.yy+5, w, 22)];
    codeLab.font = [UIFont systemFontOfSize:14];
    codeLab.textAlignment = NSTextAlignmentLeft;
    codeLab.textColor = kTextColor;
    [self.contentScrollView addSubview:codeLab];

    
    //验证码
    CaptchaView *captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(margin, codeLab.yy + 1, w, h)];
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    [self.contentScrollView addSubview:captchaView];
    UIView *phone1 = [[UIView alloc] init];
    [self.contentScrollView addSubview:phone1];
    captchaView.captchaTf.keyboardType = UIKeyboardTypePhonePad;

    phone1.backgroundColor = kLineColor;
    phone1.frame = CGRectMake(btnMargin, captchaView.yy, w-30, 2);
    self.captchaView = captchaView;
    
//    //推荐人
//    self.referTF = [[TLTextField alloc] initWithFrame:CGRectMake(margin, captchaView.yy + 1 , w, h) leftTitle:[LangSwitcher switchLang:@"推荐人(选填)" key:nil] titleWidth:titleWidth placeholder:[LangSwitcher switchLang:@"请输入推荐人手机号码" key:nil]];
//    [self.view addSubview:self.referTF];
//    self.referTF.keyboardType = UIKeyboardTypeNumberPad;
    
    //密码
    
    UILabel *pwdLab = [UILabel labelWithTitle:[LangSwitcher switchLang:@"密码" key:nil] frame:CGRectMake(20, captchaView.yy+5, w, 22)];
    pwdLab.font = [UIFont systemFontOfSize:14];
    pwdLab.textAlignment = NSTextAlignmentLeft;
    pwdLab.textColor = kTextColor;
    [self.contentScrollView addSubview:pwdLab];
    TLTextField *pwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, pwdLab.yy + 10, w, h) leftTitle:[LangSwitcher switchLang:@"" key:nil] titleWidth:titleWidth placeholder:[LangSwitcher switchLang:@"请输入密码" key:nil]];
    pwdTf.secureTextEntry = YES;
    pwdTf.returnKeyType = UIReturnKeyNext;
    [pwdTf addTarget:self action:@selector(next) forControlEvents:UIControlEventEditingDidEndOnExit];
//    pwdTf.keyboardType = UIKeyboardTypePhonePad;

    [self.contentScrollView addSubview:pwdTf];
    self.pwdTf = pwdTf;
    UIView *phone2 = [[UIView alloc] init];
    [self.contentScrollView addSubview:phone2];
    phone2.backgroundColor = kLineColor;
    phone2.frame = CGRectMake(btnMargin, pwdTf.yy, w-30, 2);
    //re密码
    UILabel *sureLab = [UILabel labelWithTitle:[LangSwitcher switchLang:@"确认密码" key:nil] frame:CGRectMake(20, pwdTf.yy+5, w, 22)];
    sureLab.font = [UIFont systemFontOfSize:14];
    sureLab.textAlignment = NSTextAlignmentLeft;
    sureLab.textColor = kTextColor;
    [self.contentScrollView addSubview:sureLab];
    
    TLTextField *rePwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, sureLab.yy + 1, w, h) leftTitle:[LangSwitcher switchLang:@"" key:nil] titleWidth:titleWidth placeholder:[LangSwitcher switchLang:@"确认密码" key:nil]];
    rePwdTf.secureTextEntry = YES;
//    rePwdTf.keyboardType = UIKeyboardTypePhonePad;
    rePwdTf.returnKeyType = UIReturnKeyNext;
    [rePwdTf addTarget:self action:@selector(next1) forControlEvents:UIControlEventEditingDidEndOnExit];

    [self.contentScrollView addSubview:rePwdTf];
    self.rePwdTf = rePwdTf;
    UIView *phone3 = [[UIView alloc] init];
    [self.contentScrollView addSubview:phone3];
    phone3.backgroundColor = kLineColor;
    phone3.frame = CGRectMake(btnMargin, rePwdTf.yy, w-30, 2);
//    for (int i = 0; i < 2; i++) {
    
//        UIView *line = [[UIView alloc] init];
//
//        line.backgroundColor = kLineColor;
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
    UIButton *confirmBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"注册" key:nil] titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    
    [confirmBtn addTarget:self action:@selector(goReg) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentScrollView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(btnMargin);
        make.width.mas_equalTo(kScreenWidth - 2*btnMargin);
        make.height.mas_equalTo(h - 5);
        make.top.mas_equalTo(rePwdTf.mas_bottom).mas_equalTo(40);
        
    }];
    
    //选择按钮
//    UIButton *checkBtn = [UIButton buttonWithImageName:@"不打勾" selectedImageName:@"打勾"];
//    
//    checkBtn.selected = YES;
//    
//    [checkBtn addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.contentScrollView addSubview:checkBtn];
//    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(confirmBtn.mas_left).offset(5);
//        make.top.equalTo(confirmBtn.mas_bottom).offset(18);
//    }];
//    
//    self.checkBtn = checkBtn;
//    
//    NSString *text = [LangSwitcher switchLang:@"我已阅读并同意" key:nil];
//
//    //text
//    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:12];
//
//    textLbl.text = text;
//
//    textLbl.userInteractionEnabled = YES;
//
//    [self.contentScrollView addSubview:textLbl];
//    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(checkBtn.mas_right).offset(5);
//        make.centerY.equalTo(checkBtn.mas_centerY);
//
//    }];
//
    
//    self.accessoryImageView = [[UIButton alloc] init];
//    self.accessoryImageView.frame = CGRectMake(kScreenWidth - 40-40, 90, 40, 40);
//    [self.contentScrollView addSubview:self.accessoryImageView];
//    [self.accessoryImageView setImage:kImage(@"更多-灰色") forState:UIControlStateNormal];
//    [self.accessoryImageView addTarget:self action:@selector(chooseCountry) forControlEvents:UIControlEventTouchUpInside];
//    [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerY.equalTo(titlePhone.mas_centerY).offset(0);
//        make.right.mas_equalTo(-20);
//        make.width.height.equalTo(@40);
//    }];
    
    
//    UIButton *protocolBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"《注册协议》" key:nil] titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:12.0];
//
//    [protocolBtn addTarget:self action:@selector(readProtocal) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.contentScrollView addSubview:protocolBtn];
//    [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(textLbl.mas_right);
//        make.centerY.equalTo(checkBtn.mas_centerY);
//
//    }];
    
    self.contentScrollView.contentSize = CGSizeMake(0, self.rePwdTf.yy+300 );
    self.contentScrollView.scrollEnabled = YES;
}

- (void)next
{
    [self.pwdTf resignFirstResponder];
    [self.rePwdTf becomeFirstResponder];
    
}
- (void)next1
{
    [self.rePwdTf resignFirstResponder];
    [self goReg];
}

- (void)chooseCountry
{
    
    //选择国家 设置区号
    CoinWeakSelf;
    ChooseCountryVc *countryVc = [ChooseCountryVc new];
//     countryVc.interCode = [NSString stringWithFormat:@"00%@",[self.PhoneCode.text substringFromIndex:1]];
    countryVc.selectCountry = ^(CountryModel *model) {
        //更新国家 区号
        [self.pic sd_setImageWithURL:[NSURL URLWithString:[model.pic convertImageUrl]]];

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
    LangType type = [LangSwitcher currentLangType];
    NSString *lang;
    if (type == LangTypeSimple || type == LangTypeTraditional) {
        lang = @"zh_CN";
    }else if (type == LangTypeKorean)
    {
        lang = @"nil";


    }else{
        lang = @"en";

    }
    UIViewController *vc = [MSAuthVCFactory simapleVerifyWithType:(MSAuthTypeSlide) language:lang Delegate:self authCode:@"0335" appKey:nil];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)verifyDidFinishedWithResult:(t_verify_reuslt)code Error:(NSError *)error SessionId:(NSString *)sessionId
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            NSLog(@"验证失败 %@", error);
            [TLAlert alertWithSucces:[LangSwitcher switchLang:@"验证失败" key:nil]];
        } else {
            NSLog(@"验证通过 %@", sessionId);
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            http.code = CAPTCHA_CODE;
            http.parameters[@"client"] = @"ios";
            http.parameters[@"sessionId"] = sessionId;
            http.parameters[@"bizType"] = USER_REG_CODE;
            http.parameters[@"mobile"] = self.phoneTf.text;
            http.parameters[@"interCode"] = [NSString stringWithFormat:@"00%@",[self.PhoneCode.text substringFromIndex:1]];
            http.parameters[@"sessionId"] = sessionId;

            [http postWithSuccess:^(id responseObject) {

                [TLAlert alertWithSucces:[LangSwitcher switchLang:@"验证码已发送,请注意查收" key:nil]];

                [self.captchaView.captchaBtn begin];

            } failure:^(NSError *error) {

                [TLAlert alertWithError:[LangSwitcher switchLang:@"发送失败,请检查手机号" key:nil]];

            }];
            
        }
        [self.navigationController popViewControllerAnimated:YES];
        //将sessionid传到经过app服务器做二次验证
    });
}

//- (void)verifyDidFinishedWithError:(NSError *)error SessionId:(NSString *)sessionId {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (error) {
//            NSLog(@"验证失败 %@", error);
//        } else {
//            NSLog(@"验证通过 %@", sessionId);
//        }
//        [self.navigationController popViewControllerAnimated:YES];
//        //将sessionid传到经过app服务器做二次验证
//    });
//}

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

        [self configData];

    } failure:^(NSError *error) {
        
        [self configData];

    }];
    
    
    
}
- (void)goReg {
    
//    if (![self.nickNameTF.text valid]) {
//
//        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请设置你的昵称" key:nil]];
//
//        return ;
//    }
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的手机号" key:nil]];
        
        return;
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
    
//    if (!self.checkBtn.selected) {
//
//        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请同意《注册协议》" key:nil]];
//        return ;
//    }

    [self.view endEditing:YES];

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_REG_CODE;
    http.parameters[@"mobile"] = self.phoneTf.text;
    NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
    CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([model.code isNotBlank]) {
        http.parameters[@"countryCode"] = model.code;
    }else{
        http.parameters[@"countryCode"] = self.countrys[0].code;

        }
    

    http.parameters[@"loginPwd"] = self.pwdTf.text;
//    http.parameters[@"isRegHx"] = @"0";
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
    http.parameters[@"kind"] = APP_KIND;
    http.parameters[@"client"] = @"ios";

    if ([self.referTF.text valid]) {
        
        http.parameters[@"userReferee"] = self.referTF.text;
        http.parameters[@"userRefereeKind"] = APP_KIND;
       
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        [self.view endEditing:YES];
        
        NSString *token = responseObject[@"data"][@"token"];
        NSString *userId = responseObject[@"data"][@"userId"];
        [MobClick profileSignInWithPUID:userId];
        //保存用户账号和密码
//        [[TLUser user] saveUserName:self.phoneTf.text pwd:self.pwdTf.text];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            //获取用户信息
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            http.code = USER_INFO;
            http.parameters[@"userId"] = userId;
            http.parameters[@"token"] = token;
            [http postWithSuccess:^(id responseObject) {
                
                [TLAlert alertWithSucces:[LangSwitcher switchLang:@"注册成功" key:nil]];
                NSDictionary *userInfo = responseObject[@"data"];
                [TLUser user].userId = userId;
                [TLUser user].token = token;
                
                //保存信息
                [[TLUser user] saveUserInfo:userInfo];
                [[TLUser user] setUserInfoWithDict:userInfo];
                
                TLTabBarController *ta = [[TLTabBarController alloc] init];
                
                [UIApplication sharedApplication].keyWindow.rootViewController = ta;
                //dismiss 掉
//                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
//                [self.navigationController popToRootViewControllerAnimated:YES];
                

            } failure:^(NSError *error) {
                
            }];
            
//        });
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)clickSelect:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
}

- (void)readProtocal {
    
    HTMLStrVC *htmlVC = [[HTMLStrVC alloc] init];
    
    htmlVC.type = HTMLTypeRegProtocol;
    
    [self.navigationController pushViewController:htmlVC animated:YES];
    
}
@end
