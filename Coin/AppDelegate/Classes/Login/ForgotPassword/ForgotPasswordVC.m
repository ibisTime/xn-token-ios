//
//  ForgotPasswordVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/22.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "SearchCountriesVC.h"
@interface ForgotPasswordVC ()<UIScrollViewDelegate,MSAuthProtocol>
{
    UIButton *isSelectBtn;
    UIView *registerLineView;
    NSInteger w;
    NSString *email;
    NSString *phone;
}

@property (nonatomic , strong)UIScrollView *scrollView;
@property (nonatomic , strong)UITextField *phoneTextFid;
@property (nonatomic , strong)UITextField *codeTextFid;
@property (nonatomic , strong)UIButton *codeBtn;
@property (nonatomic , strong)UITextField *passFid;
@property (nonatomic , strong)UITextField *conPassFid;
@property (nonatomic , strong)UIButton *phoneAreaCodeBtn;

@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}

-(void)initView
{
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    [self.view addSubview:backImage];
    
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT + kStatusBarHeight)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    //    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    [self registrationWayUI];
    [self moneyPasswordUI];
}

-(void)registrationWayUI
{
    
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, SCREEN_WIDTH, 44)];
    nameLable.text = [LangSwitcher switchLang:@"忘记密码" key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(16);
    nameLable.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:nameLable];
    
    
    NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
    CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSArray *array = @[[LangSwitcher switchLang:@"手机找回" key:nil],[LangSwitcher switchLang:@"邮箱找回" key:nil]];
    
    for (int i = 0; i < 2; i ++) {
        UIButton *phoneAndEmailRegister = [UIButton buttonWithTitle:array[i] titleColor:kHexColor(@"d6d5d5") backgroundColor:kClearColor titleFont:16];
        [phoneAndEmailRegister setTitleColor:kWhiteColor forState:(UIControlStateSelected)];
        phoneAndEmailRegister.frame = CGRectMake(35 + i %2*((SCREEN_WIDTH - 70)/2), 160 - 64 + kNavigationBarHeight, (SCREEN_WIDTH - 70)/2, 16);
        if (i == 0) {
            phoneAndEmailRegister.selected = YES;
            isSelectBtn = phoneAndEmailRegister;
            
            registerLineView = [[UIView alloc]initWithFrame:CGRectMake(35, 160 - 64 + kNavigationBarHeight + 30, (SCREEN_WIDTH - 70)/2, 1)];
            registerLineView.backgroundColor = kWhiteColor;
            [self.scrollView addSubview:registerLineView];
        }
        phoneAndEmailRegister.titleLabel.font = HGboldfont(16);
        [phoneAndEmailRegister addTarget:self action:@selector(phoneAndEmailRegisterClick:) forControlEvents:(UIControlEventTouchUpInside)];
        phoneAndEmailRegister.tag = 100 + i;
        [self.scrollView addSubview:phoneAndEmailRegister];
    }
    
    UIButton *phoneAreaCodeBtn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:14];
    
    phoneAreaCodeBtn.frame = CGRectMake(46, registerLineView.yy + 50, 0, 15);
    phoneAreaCodeBtn.titleLabel.font = HGboldfont(14);
    [phoneAreaCodeBtn sizeToFit];
    phoneAreaCodeBtn.frame = CGRectMake(46, registerLineView.yy + 50, phoneAreaCodeBtn.frame.size.width + 6.5, 15);
    [phoneAreaCodeBtn setImage:kImage(@"矩形4") forState:(UIControlStateNormal)];
    
    CGFloat imageW = phoneAreaCodeBtn.imageView.image.size.width;
    CGFloat titleW = phoneAreaCodeBtn.titleLabel.frame.size.width;
    CGFloat imageOffset = titleW + 0.5 * 3;
    CGFloat titleOffset = imageW + 0.5 * 3;
    
    phoneAreaCodeBtn.imageEdgeInsets = UIEdgeInsetsMake(6.5, imageOffset, 0, - imageOffset);
    phoneAreaCodeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, - titleOffset, 0, titleOffset);
    
    [phoneAreaCodeBtn addTarget:self action:@selector(phoneAreaCodeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    self.phoneAreaCodeBtn =  phoneAreaCodeBtn;
    [self.scrollView addSubview:phoneAreaCodeBtn];
    
    UITextField *phoneTextFid = [[UITextField alloc]initWithFrame:CGRectMake(phoneAreaCodeBtn.xx + 15, registerLineView.yy + 50, SCREEN_WIDTH - phoneAreaCodeBtn.xx - 60, 15)];
    phoneTextFid.placeholder = [LangSwitcher switchLang:@"请输入您的手机号码" key:nil];
    //    phoneTextFid.keyboardType = UIKeyboardTypeEmailAddress;
    [phoneTextFid setValue:FONT(12) forKeyPath:@"_placeholderLabel.font"];
    phoneTextFid.font = FONT(12);
    self.phoneTextFid = phoneTextFid;
    phoneTextFid.textColor = [UIColor whiteColor];
    [phoneTextFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
    phoneTextFid.clearsOnBeginEditing = NO;
    phoneTextFid.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:phoneTextFid];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(35, phoneTextFid.yy + 13, SCREEN_WIDTH - 70, 1)];
    lineView.backgroundColor = kWhiteColor;
    [self.scrollView addSubview:lineView];
    
    UILabel *codeLabel = [UILabel labelWithFrame:CGRectMake(46, lineView.yy + 29, 0, 15) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(14) textColor:kWhiteColor];
    codeLabel.text = [LangSwitcher switchLang:@"验证码" key:nil];
    [codeLabel sizeToFit];
    if (codeLabel.width >= 100) {
        codeLabel.frame = CGRectMake(46, lineView.yy + 29, 100, 15);
    }else
    {
        codeLabel.frame = CGRectMake(46, lineView.yy + 29, codeLabel.width, 15);
    }
    
    [self.scrollView addSubview:codeLabel];
    
    UIButton *codeBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"获取验证码" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:14];
    [codeBtn sizeToFit];
    codeBtn.frame = CGRectMake(SCREEN_WIDTH - 35 - codeBtn.width - 26, lineView.yy + 16, codeBtn.width + 26, 31);
    [codeBtn setBackgroundImage:kImage(@"圆角矩形2拷贝2") forState:(UIControlStateNormal)];
    [codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    self.codeBtn = codeBtn;
    [self.scrollView addSubview:codeBtn];
    
    UITextField *codeTextFid = [[UITextField alloc]initWithFrame:CGRectMake(codeLabel.xx + 15, lineView.yy + 29, SCREEN_WIDTH - codeLabel.xx - 15 - codeBtn.width - 45, 15)];
    self.codeTextFid = codeTextFid;
    codeTextFid.placeholder = [LangSwitcher switchLang:@"请输入验证码" key:nil];
    //    codeTextFid.keyboardType = UIKeyboardTypeEmailAddress;
    [codeTextFid setValue:FONT(12) forKeyPath:@"_placeholderLabel.font"];
    codeTextFid.font = FONT(12);
    codeTextFid.textColor = [UIColor whiteColor];
    [codeTextFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
    codeTextFid.clearsOnBeginEditing = NO;
    codeTextFid.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:codeTextFid];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(35, codeLabel.yy + 13, SCREEN_WIDTH - 70, 1)];
    lineView1.backgroundColor = kWhiteColor;
    [self.scrollView addSubview:lineView1];
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"" titleColor:kClearColor backgroundColor:kClearColor titleFont:0];
    confirmBtn.frame = CGRectMake(SCREEN_WIDTH - 85, lineView1.yy + 100, 50, 50);
    [confirmBtn setBackgroundImage:kImage(@"矩形3拷贝") forState:(UIControlStateNormal)];
    [confirmBtn addTarget:self action:@selector(nextBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.scrollView addSubview:confirmBtn];
}

-(void)codeBtnClick
{
    
    if (![self.phoneTextFid.text isPhoneNum]) {
        if (isSelectBtn.tag == 100) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入手机号" key:nil]];
            return;
        }else
        {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入邮箱号" key:nil]];
            return;
        }
        
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
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (isSelectBtn.tag == 100) {
                TLNetworking *http = [TLNetworking new];
                http.showView = self.view;
                http.code = CAPTCHA_CODE;
                http.parameters[@"client"] = @"ios";
                http.parameters[@"sessionId"] = sessionId;
                http.parameters[@"bizType"] = @"805076";
                http.parameters[@"mobile"] = self.phoneTextFid.text;
                NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
                CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                http.parameters[@"interCode"] = model.interCode;
                http.parameters[@"sessionId"] = sessionId;
                
                [http postWithSuccess:^(id responseObject) {
                    
                    [TLAlert alertWithSucces:[LangSwitcher switchLang:@"验证码已发送,请注意查收" key:nil]];
                    [[UserModel user] phoneCode:self.codeBtn];
                    //                [MBProgressHUD hideHUDForView:self.view animated:YES];
                } failure:^(NSError *error) {
                    
                    [TLAlert alertWithError:[LangSwitcher switchLang:@"发送失败,请检查手机号" key:nil]];
                    //                [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
            }else
            {
                TLNetworking *http = [TLNetworking new];
                http.showView = self.view;
                http.code = @"805954";
                //    http.parameters[@"companyCode"] = @"";
                http.parameters[@"email"] = self.phoneTextFid.text;
                http.parameters[@"bizType"] = @"805076";
                http.parameters[@"client"] = @"ios";
                http.parameters[@"sessionId"] = sessionId;
                
                [http postWithSuccess:^(id responseObject) {
                    //
                    [TLAlert alertWithSucces:[LangSwitcher switchLang:@"验证码已发送,请注意查收" key:nil]];
                    [[UserModel user] phoneCode:self.codeBtn];
                    
                } failure:^(NSError *error) {
                    [TLAlert alertWithError:[LangSwitcher switchLang:@"发送失败,请检查手机号" key:nil]];
                }];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
        //将sessionid传到经过app服务器做二次验证
    });
}



#pragma mark -- scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    w = scrollView.contentOffset.x/SCREEN_WIDTH;
    
    //禁止左划
    static float newx = 0;
    static float oldx = 0;
    newx= scrollView.contentOffset.x ;
    if (newx > oldx) {
        scrollView.scrollEnabled = NO;
        scrollView.scrollEnabled = YES;
    }
    oldx = newx;
}


#pragma mark -- 搜索
-(void)phoneAreaCodeBtnClick
{
    SearchCountriesVC *vc = [SearchCountriesVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 选择注册方式
-(void)phoneAndEmailRegisterClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        registerLineView.frame = CGRectMake(35 + (sender.tag - 100)*(SCREEN_WIDTH - 70)/2, 160 - 64 + kNavigationBarHeight + 30, (SCREEN_WIDTH - 70)/2, 1);
    }];
    sender.selected = !sender.selected;
    isSelectBtn.selected = !isSelectBtn.selected;
    isSelectBtn = sender;
    [self PageShowsUI:sender];
}



-(void)PageShowsUI:(UIButton *)sender
{
    if (sender.tag == 100) {
        NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
        CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [_phoneAreaCodeBtn setTitle:[NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]] forState:(UIControlStateNormal)];
        [_phoneAreaCodeBtn sizeToFit];
        _phoneAreaCodeBtn.frame = CGRectMake(46, registerLineView.yy + 50, _phoneAreaCodeBtn.frame.size.width + 6.5, 15);
        [_phoneAreaCodeBtn setImage:kImage(@"矩形4") forState:(UIControlStateNormal)];
        CGFloat imageW = _phoneAreaCodeBtn.imageView.image.size.width;
        CGFloat titleW = _phoneAreaCodeBtn.titleLabel.frame.size.width;
        CGFloat imageOffset = titleW + 0.5 * 3;
        CGFloat titleOffset = imageW + 0.5 * 3;
        _phoneAreaCodeBtn.imageEdgeInsets = UIEdgeInsetsMake(6.5, imageOffset, 0, - imageOffset);
        _phoneAreaCodeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, - titleOffset, 0, titleOffset);
        _phoneTextFid.frame = CGRectMake(_phoneAreaCodeBtn.xx + 15, registerLineView.yy + 50, SCREEN_WIDTH - _phoneAreaCodeBtn.xx - 60, 15);
        _phoneTextFid.placeholder = [LangSwitcher switchLang:@"请输入您的手机号码" key:nil];
        email = _phoneTextFid.text;
        _phoneTextFid.text = phone;
    }else
    {
        
        [_phoneAreaCodeBtn setTitle:[LangSwitcher switchLang:@"邮箱" key:nil] forState:(UIControlStateNormal)];
        [_phoneAreaCodeBtn sizeToFit];
        
        [_phoneAreaCodeBtn setImage:kImage(@"") forState:(UIControlStateNormal)];
        _phoneAreaCodeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _phoneAreaCodeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _phoneAreaCodeBtn.frame = CGRectMake(46, registerLineView.yy + 50, _phoneAreaCodeBtn.width, 15);
        
        _phoneTextFid.frame = CGRectMake(_phoneAreaCodeBtn.xx + 10, registerLineView.yy + 50, SCREEN_WIDTH - _phoneAreaCodeBtn.xx - 60, 15);
        _phoneTextFid.placeholder = [LangSwitcher switchLang:@"请输入您的邮箱账号" key:nil];
        phone = _phoneTextFid.text;
        _phoneTextFid.text = email;
    }
}


-(void)nextBtn
{
    if (w == 0) {
        if (![self.phoneTextFid.text isPhoneNum]) {
            if (isSelectBtn.tag == 100) {
                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入手机号" key:nil]];
                return;
            }else
            {
                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入邮箱号" key:nil]];
                return;
            }
            
        }
        if (![self.codeTextFid.text isPhoneNum]) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入验证码" key:nil]];
            return;
        }
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    }
    if (w == 1) {
        
        if (![_passFid.text isPhoneNum]) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入账号登录密码" key:nil]];
            return;
        }
        if (![_conPassFid.text isPhoneNum]) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请确认账号登录密码" key:nil]];
            return;
        }
        
        if (![_passFid.text isEqualToString:_conPassFid.text]) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"密码不一致" key:nil]];
            return;
        }
        if (_passFid.text.length < 8 || [[UserModel user]isStringTheCapitalLettersWith:_passFid.text] == NO || [[UserModel user]isStringContainNumberWith:_passFid.text] == NO || _passFid.text.length > 25) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"密码位数为8~25位(字母+数字)" key:nil]];
            return;
        }
        
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"805076";
//        http.parameters[@"mobile"] = self.phoneTf.text;
        http.parameters[@"smsCaptcha"] = self.codeTextFid.text;
        http.parameters[@"newLoginPwd"] = self.passFid.text;
        http.parameters[@"kind"] = APP_KIND;

        
        if (isSelectBtn.tag == 100) {
            
            NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
            CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            http.parameters[@"loginName"] = [NSString stringWithFormat:@"%@%@",model.interCode,self.phoneTextFid.text];
//            http.parameters[@"interCode"] = model.interCode;
        }else
        {
            http.parameters[@"loginName"] = self.phoneTextFid.text;
        }
        
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"找回成功"];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                [weakSelf delayMethod];
                [self.navigationController popViewControllerAnimated:YES];
            });

            
        } failure:^(NSError *error) {
            
            
        }];
    }
}



-(void)moneyPasswordUI
{
    
    
    
    
    UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:passwordView];
    
    
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, SCREEN_WIDTH, 44)];
    nameLable.text = [LangSwitcher switchLang:@"密码找回" key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(16);
    nameLable.textColor = [UIColor whiteColor];
    [passwordView addSubview:nameLable];
    
    
    
    NSArray *passWordArray = @[[LangSwitcher switchLang:@"密码" key:nil],[LangSwitcher switchLang:@"确认密码" key:nil]];
    NSArray *placArray = @[[LangSwitcher switchLang:@"密码为8~25为数字加字母" key:nil],[LangSwitcher switchLang:@"两次输入密码必须一致" key:nil]];
    
    
    UIView *bottomView;
    for (int i = 0; i < 2; i ++) {
        UILabel *passWordLbl = [UILabel labelWithFrame:CGRectMake(35, 160 - 64 + kNavigationBarHeight + i % 2 * 108, SCREEN_WIDTH - 70, 16) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(16) textColor:kWhiteColor];
        passWordLbl.text = passWordArray[i];
        [passwordView addSubview:passWordLbl];
        
        
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, passWordLbl.yy + 21 - 1.5, 10, 15)];
        iconImage.image = kImage(@"安全组拷贝");
        [passwordView addSubview:iconImage];
        
        UITextField *passWordFid = [[UITextField alloc]initWithFrame:CGRectMake(iconImage.xx + 15, passWordLbl.yy + 21 - 1.5, SCREEN_WIDTH - iconImage.xx - 40 , 15)];
        passWordFid.placeholder = placArray[i];
        passWordFid.secureTextEntry = YES;
        [passWordFid setValue:FONT(12) forKeyPath:@"_placeholderLabel.font"];
        passWordFid.font = FONT(12);
        passWordFid.textColor = [UIColor whiteColor];
        [passWordFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
        passWordFid.clearsOnBeginEditing = NO;
        passWordFid.clearButtonMode = UITextFieldViewModeWhileEditing;
        [passwordView addSubview:passWordFid];
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(35, passWordFid.yy + 8.5, SCREEN_WIDTH - 70, 1)];
        lineView.backgroundColor = kLineColor;
        [passwordView addSubview:lineView];
        if (i == 1) {
            bottomView =lineView;
        }
        if (i == 0) {
            self.passFid = passWordFid;
        }else
        {
            self.conPassFid = passWordFid;
        }
    }
    
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"完成" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:18];
    confirmBtn.frame = CGRectMake(50, bottomView.yy + 75, SCREEN_WIDTH - 100, 50);
    kViewRadius(confirmBtn, 10);
    [confirmBtn setBackgroundImage:kImage(@"矩形5-1") forState:(UIControlStateNormal)];
    [confirmBtn addTarget:self action:@selector(nextBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [passwordView addSubview:confirmBtn];
    
    
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
