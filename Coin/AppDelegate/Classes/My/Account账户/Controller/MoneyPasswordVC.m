//
//  MoneyPasswordVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/28.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "MoneyPasswordVC.h"
#import "MoneyPasswordSecondaryVC.h"
@interface MoneyPasswordVC ()<UIScrollViewDelegate,MSAuthProtocol>
{
    UIButton *isSelectBtn;
    UIView *registerLineView;
    NSInteger w;
    CGFloat height;
    NSInteger isModify;
}

//@property (nonatomic , strong)UIScrollView *scrollView;
@property (nonatomic , strong)UITextField *phoneTextFid;
@property (nonatomic , strong)UITextField *codeTextFid;
@property (nonatomic , strong)UIButton *codeBtn;
//@property (nonatomic , strong)UITextField *passFid;
//@property (nonatomic , strong)UITextField *conPassFid;
@property (nonatomic , strong)UIButton *phoneAreaCodeBtn;

@end

@implementation MoneyPasswordVC


-(void)viewWillAppear:(BOOL)animated
{
    [self navigationTransparentClearColor];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self navigationSetDefault];
}

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
//
//    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT + kStatusBarHeight)];
//    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
//    self.scrollView.bounces = NO;
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.pagingEnabled = YES;
//    self.scrollView.delegate = self;
//    [self.view addSubview:self.scrollView];
    
    [self registrationWayUI];
//    [self moneyPasswxordUI];
    
//    height = 160 - 64 + kNavigationBarHeight + 30;
}

-(void)registrationWayUI
{
    
    
    UILabel *nameLable = [[UILabel alloc] init];
    nameLable.text = [LangSwitcher switchLang:self.titleNameStr key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(16);
    nameLable.textColor = [UIColor whiteColor];
//    [self.view addSubview:nameLable];
    self.navigationItem.titleView = nameLable;
    
    
    NSArray *array;
    if ([TLUser isBlankString:[TLUser user].mobile] == NO && [TLUser isBlankString:[TLUser user].email] == NO ) {
        array = @[[LangSwitcher switchLang:@"手机找回" key:nil],[LangSwitcher switchLang:@"邮箱找回" key:nil]];
        height = 160 - 64 + 30;
        isModify = 0;
    }else if([TLUser isBlankString:[TLUser user].mobile] == NO && [TLUser isBlankString:[TLUser user].email] == YES )
    {
        height = 100 - 64;
        isModify = 0;
    }else if ([TLUser isBlankString:[TLUser user].mobile] == YES && [TLUser isBlankString:[TLUser user].email] == NO)
    {
        height = 100 - 64;
        isModify = 1;
    }
    
    
    
    NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
    CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    array = @[[LangSwitcher switchLang:@"手机找回" key:nil],[LangSwitcher switchLang:@"邮箱找回" key:nil]];
    
    for (int i = 0; i < array.count; i ++) {
        UIButton *phoneAndEmailRegister = [UIButton buttonWithTitle:array[i] titleColor:kHexColor(@"d6d5d5") backgroundColor:kClearColor titleFont:16];
        [phoneAndEmailRegister setTitleColor:kWhiteColor forState:(UIControlStateSelected)];
        phoneAndEmailRegister.frame = CGRectMake(35 + i %2*((SCREEN_WIDTH - 70)/2), 160 - 64, (SCREEN_WIDTH - 70)/2, 16);
        if (i == 0) {
            phoneAndEmailRegister.selected = YES;
            isSelectBtn = phoneAndEmailRegister;
            
            registerLineView = [[UIView alloc]initWithFrame:CGRectMake(35, 160 - 64  + 30, (SCREEN_WIDTH - 70)/2, 1)];
            registerLineView.backgroundColor = kWhiteColor;
            [self.view addSubview:registerLineView];
            
            
        }
        
        phoneAndEmailRegister.titleLabel.font = HGboldfont(16);
        
        if ([TLUser isBlankString:[TLUser user].mobile] == NO && [TLUser isBlankString:[TLUser user].email] == NO )
        {
            [phoneAndEmailRegister addTarget:self action:@selector(phoneAndEmailRegisterClick:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        phoneAndEmailRegister.tag = 100 + i;
        [self.view addSubview:phoneAndEmailRegister];
    }
    
    UIButton *phoneAreaCodeBtn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:14];
    phoneAreaCodeBtn.frame = CGRectMake(46,  + 50, 0, 15);
    phoneAreaCodeBtn.titleLabel.font = HGboldfont(15);
    [phoneAreaCodeBtn sizeToFit];
    phoneAreaCodeBtn.frame = CGRectMake(46, height + 50, phoneAreaCodeBtn.frame.size.width , 15);
    
    self.phoneAreaCodeBtn =  phoneAreaCodeBtn;
    [self.view addSubview:phoneAreaCodeBtn];
    
    UITextField *phoneTextFid = [[UITextField alloc]initWithFrame:CGRectMake(phoneAreaCodeBtn.xx + 15, height + 50, SCREEN_WIDTH - phoneAreaCodeBtn.xx - 60, 15)];
    phoneTextFid.placeholder = [LangSwitcher switchLang:@"请输入您的手机号码" key:nil];
    
    [phoneTextFid setValue:FONT(14) forKeyPath:@"_placeholderLabel.font"];
    phoneTextFid.font = FONT(14);
    phoneTextFid.enabled = NO;
    self.phoneTextFid = phoneTextFid;
    _phoneTextFid.text = [TLUser user].mobile;
    phoneTextFid.textColor = [UIColor whiteColor];
    [phoneTextFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
    phoneTextFid.clearsOnBeginEditing = NO;
    phoneTextFid.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:phoneTextFid];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(35, phoneTextFid.yy + 13, SCREEN_WIDTH - 70, 1)];
    lineView.backgroundColor = kWhiteColor;
    [self.view addSubview:lineView];
    
    UILabel *codeLabel = [UILabel labelWithFrame:CGRectMake(46, lineView.yy + 29, 0, 15) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(15) textColor:kWhiteColor];
    codeLabel.text = [LangSwitcher switchLang:@"验证码" key:nil];
    [codeLabel sizeToFit];
    if (codeLabel.width >= 100) {
        codeLabel.frame = CGRectMake(46, lineView.yy + 29, 100, 15);
    }else
    {
        codeLabel.frame = CGRectMake(46, lineView.yy + 29, codeLabel.width, 15);
    }
    
    [self.view addSubview:codeLabel];
    
    UIButton *codeBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"获取验证码" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:14];
    [codeBtn sizeToFit];
    codeBtn.frame = CGRectMake(SCREEN_WIDTH - 35 - codeBtn.width - 26, lineView.yy + 16, codeBtn.width + 26, 31);
    [codeBtn setBackgroundImage:kImage(@"圆角矩形2拷贝2") forState:(UIControlStateNormal)];
    [codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    self.codeBtn = codeBtn;
    [self.view addSubview:codeBtn];
    
    UITextField *codeTextFid = [[UITextField alloc]initWithFrame:CGRectMake(codeLabel.xx + 15, lineView.yy + 29, SCREEN_WIDTH - codeLabel.xx - 15 - codeBtn.width - 45, 15)];
    self.codeTextFid = codeTextFid;
    codeTextFid.placeholder = [LangSwitcher switchLang:@"请输入验证码" key:nil];
    //    codeTextFid.keyboardType = UIKeyboardTypeEmailAddress;
    [codeTextFid setValue:FONT(14) forKeyPath:@"_placeholderLabel.font"];
    codeTextFid.font = FONT(14);
    codeTextFid.textColor = [UIColor whiteColor];
    [codeTextFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
    codeTextFid.clearsOnBeginEditing = NO;
    codeTextFid.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:codeTextFid];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(35, codeLabel.yy + 13, SCREEN_WIDTH - 70, 1)];
    lineView1.backgroundColor = kWhiteColor;
    [self.view addSubview:lineView1];
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"" titleColor:kClearColor backgroundColor:kClearColor titleFont:0];
    confirmBtn.frame = CGRectMake(SCREEN_WIDTH - 85, lineView1.yy + 100, 50, 50);
    [confirmBtn setBackgroundImage:kImage(@"矩形3拷贝") forState:(UIControlStateNormal)];
    [confirmBtn addTarget:self action:@selector(nextBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:confirmBtn];
    
    
    if ([TLUser isBlankString:[TLUser user].mobile] == YES && [TLUser isBlankString:[TLUser user].email] == NO){
        //            phoneAndEmailRegister.tag = 101 + i;
        //        }else
        //        {
        //
        [_phoneAreaCodeBtn setTitle:[LangSwitcher switchLang:@"邮箱" key:nil] forState:(UIControlStateNormal)];
        [_phoneAreaCodeBtn sizeToFit];
        _phoneAreaCodeBtn.frame = CGRectMake(46, height + 50, _phoneAreaCodeBtn.width, 15);
        _phoneTextFid.frame = CGRectMake(_phoneAreaCodeBtn.xx + 10, height + 50, SCREEN_WIDTH - _phoneAreaCodeBtn.xx - 60, 15);
        _phoneTextFid.placeholder = [LangSwitcher switchLang:@"请输入您的邮箱账号" key:nil];
        _phoneTextFid.text = [TLUser user].email;
    }
    
    
}

-(void)codeBtnClick
{
    
    if (![self.phoneTextFid.text isPhoneNum]) {
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
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (isModify == 0) {
                TLNetworking *http = [TLNetworking new];
                http.showView = self.view;
                http.code = CAPTCHA_CODE;
                http.parameters[@"client"] = @"ios";
                http.parameters[@"sessionId"] = sessionId;
                if ([self.titleNameStr isEqualToString:@"修改资金密码"])
                {
                    http.parameters[@"bizType"] = @"805077";
                    
                }else
                {
                    http.parameters[@"bizType"] = @"805076";
                }
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
                
                if ([self.titleNameStr isEqualToString:@"修改资金密码"]) {
                    http.parameters[@"bizType"] = @"805077";
                }else
                {
                    http.parameters[@"bizType"] = @"805076";
                }
                
                
                
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

#pragma mark -- 选择注册方式
-(void)phoneAndEmailRegisterClick:(UIButton *)sender
{
    isModify = sender.tag - 100;
    [UIView animateWithDuration:0.3 animations:^{
        registerLineView.frame = CGRectMake(35 + (sender.tag - 100)*(SCREEN_WIDTH - 70)/2, 160 - 64  + 30, (SCREEN_WIDTH - 70)/2, 1);
    }];
    sender.selected = !sender.selected;
    isSelectBtn.selected = !isSelectBtn.selected;
    isSelectBtn = sender;
    [self PageShowsUI:sender];
}



-(void)PageShowsUI:(UIButton *)sender
{
    if (isModify == 0) {
        NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
        CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [_phoneAreaCodeBtn setTitle:[NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]] forState:(UIControlStateNormal)];
        [_phoneAreaCodeBtn sizeToFit];
        _phoneAreaCodeBtn.frame = CGRectMake(46, height + 50, _phoneAreaCodeBtn.frame.size.width, 15);
        
        _phoneTextFid.placeholder = [LangSwitcher switchLang:@"请输入您的手机号码" key:nil];
        _phoneTextFid.text = [TLUser user].mobile;
    }
    if(isModify == 1)
    {
        
        [_phoneAreaCodeBtn setTitle:[LangSwitcher switchLang:@"邮箱" key:nil] forState:(UIControlStateNormal)];
        _phoneTextFid.text = [TLUser user].email;
        [_phoneAreaCodeBtn sizeToFit];
        _phoneAreaCodeBtn.frame = CGRectMake(46, height + 50, _phoneAreaCodeBtn.width, 15);
        _phoneTextFid.frame = CGRectMake(_phoneAreaCodeBtn.xx + 10, height + 50, SCREEN_WIDTH - _phoneAreaCodeBtn.xx - 60, 15);
        _phoneTextFid.placeholder = [LangSwitcher switchLang:@"请输入您的邮箱账号" key:nil];
    }
}


-(void)nextBtn
{
    if (w == 0) {
        if (![self.phoneTextFid.text isPhoneNum]) {
            if ([isSelectBtn.titleLabel.text isEqualToString:[LangSwitcher switchLang:@"手机找回" key:nil]]) {
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
        
        MoneyPasswordSecondaryVC *vc = [MoneyPasswordSecondaryVC new];
        vc.phone = self.phoneTextFid.text;
        vc.code = self.codeTextFid.text;
        vc.isModify = isModify;
        vc.titleNameStr = self.titleNameStr;
        [self.navigationController pushViewController:vc animated:YES];
//        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    }
//    if (w == 1) {
//        
//        if (![_passFid.text isPhoneNum]) {
//            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入账号登录密码" key:nil]];
//            return;
//        }
//        if (![_conPassFid.text isPhoneNum]) {
//            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请确认账号登录密码" key:nil]];
//            return;
//        }
//        
//        if (![_passFid.text isEqualToString:_conPassFid.text]) {
//            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"密码不一致" key:nil]];
//            return;
//        }
//        
//        if ([self.titleNameStr isEqualToString:@"修改资金密码"]) {
//            if (_passFid.text.length != 6) {
//                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"资金密码为6位数" key:nil]];
//                return;
//            }
//        }else
//        {
//            if (_passFid.text.length >= 8 && [[UserModel user]isStringTheCapitalLettersWith:_passFid.text] == YES && [[UserModel user]isStringContainNumberWith:_passFid.text] == YES) {
//                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"密码位数为8~25位(字母+数字)" key:nil]];
//            }
//        }
//    
//        
//        TLNetworking *http = [TLNetworking new];
//        http.showView = self.view;
//        if ([self.titleNameStr isEqualToString:@"修改资金密码"]) {
//            http.code = @"805077";
//        }else
//        {
//            http.code = @"805076";
//        }
//        
//        //        http.parameters[@"mobile"] = self.phoneTf.text;
//        http.parameters[@"smsCaptcha"] = self.codeTextFid.text;
//        http.parameters[@"newLoginPwd"] = self.passFid.text;
//        http.parameters[@"kind"] = APP_KIND;
//        
//        
//        if (isModify == 0) {
//            
//            NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
//            CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//            http.parameters[@"loginName"] = [NSString stringWithFormat:@"%@%@",model.interCode,self.phoneTextFid.text];
//            //            http.parameters[@"interCode"] = model.interCode;
//        }else
//        {
//            http.parameters[@"loginName"] = self.phoneTextFid.text;
//        }
//        
//        [http postWithSuccess:^(id responseObject) {
//            
//            [TLAlert alertWithSucces:@"找回成功"];
//            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
//            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                //                [weakSelf delayMethod];
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//            
//            
//        } failure:^(NSError *error) {
//            
//            
//        }];
//    }
}


//
//-(void)moneyPasswordUI
//{
//    UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [self.scrollView addSubview:passwordView];
//    
//    
//    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, SCREEN_WIDTH, 44)];
//    nameLable.text = [LangSwitcher switchLang:@"密码找回" key:nil];
//    nameLable.textAlignment = NSTextAlignmentCenter;
//    nameLable.font = Font(16);
//    nameLable.textColor = [UIColor whiteColor];
//    [passwordView addSubview:nameLable];
//    
//    
//    NSArray *passWordArray = @[[LangSwitcher switchLang:@"密码" key:nil],[LangSwitcher switchLang:@"确认密码" key:nil]];
//    NSArray *placArray;
//    if ([self.titleNameStr isEqualToString:@"修改资金密码"]) {
//        placArray = @[[LangSwitcher switchLang:@"请输入账号资金密码" key:nil],[LangSwitcher switchLang:@"请确认账号资金密码" key:nil]];
//    }else
//    {
//       placArray = @[[LangSwitcher switchLang:@"密码为8~25为数字加字母" key:nil],[LangSwitcher switchLang:@"两次输入密码必须一致" key:nil]];
//    }
//    
//    
//    
//    UIView *bottomView;
//    for (int i = 0; i < 2; i ++) {
//        UILabel *passWordLbl = [UILabel labelWithFrame:CGRectMake(35, 160 - 64 + kNavigationBarHeight + i % 2 * 108, SCREEN_WIDTH - 70, 16) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(16) textColor:kWhiteColor];
//        passWordLbl.text = passWordArray[i];
//        [passwordView addSubview:passWordLbl];
//        
//        
//        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, passWordLbl.yy + 21 - 1.5, 10, 15)];
//        iconImage.image = kImage(@"安全组拷贝");
//        [passwordView addSubview:iconImage];
//        
//        UITextField *passWordFid = [[UITextField alloc]initWithFrame:CGRectMake(iconImage.xx + 15, passWordLbl.yy + 21 - 1.5, SCREEN_WIDTH - iconImage.xx - 40 , 15)];
//        passWordFid.placeholder = placArray[i];
//        passWordFid.secureTextEntry = YES;
//        [passWordFid setValue:FONT(12) forKeyPath:@"_placeholderLabel.font"];
//        passWordFid.font = FONT(12);
//        passWordFid.textColor = [UIColor whiteColor];
//        [passWordFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
//        passWordFid.clearsOnBeginEditing = NO;
//        passWordFid.clearButtonMode = UITextFieldViewModeWhileEditing;
//        [passwordView addSubview:passWordFid];
//        passWordFid.tag = 10000 + i;
//        
//        
//        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(35, passWordFid.yy + 8.5, SCREEN_WIDTH - 70, 1)];
//        lineView.backgroundColor = kLineColor;
//        [passwordView addSubview:lineView];
//        if (i == 1) {
//            bottomView =lineView;
//        }
//        if (i == 0) {
//            self.passFid = passWordFid;
//        }else
//        {
//            self.conPassFid = passWordFid;
//        }
//    }
//    
//    
//    
//    
//    UIButton *confirmBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"完成" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:18];
//    confirmBtn.frame = CGRectMake(50, bottomView.yy + 75, SCREEN_WIDTH - 100, 50);
//    kViewRadius(confirmBtn, 10);
//    [confirmBtn setBackgroundImage:kImage(@"矩形5-1") forState:(UIControlStateNormal)];
//    [confirmBtn addTarget:self action:@selector(nextBtn) forControlEvents:(UIControlEventTouchUpInside)];
//    [passwordView addSubview:confirmBtn];
//    
//    
//}




@end
