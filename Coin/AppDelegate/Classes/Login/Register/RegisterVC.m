//
//  RegisterVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/12.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "RegisterVC.h"
#import "SearchCountriesVC.h"
#import "CompleteTheRegistrationVC.h"
#import <UMMobClick/MobClick.h>
@interface RegisterVC ()<UIScrollViewDelegate,MSAuthProtocol,UITextFieldDelegate>
{
    UIButton *isSelectBtn;
    UIView *registerLineView;
    NSInteger w;
}

@property (nonatomic , strong)UIScrollView *scrollView;
//+86
@property (nonatomic , strong)UIButton *phoneAreaCodeBtn;
@property (nonatomic , strong)UITextField *phoneTextFid;
@property (nonatomic , strong)UITextField *codeTextFid;
@property (nonatomic , strong)UIButton *codeBtn;
//密码  确认密码
@property (nonatomic , strong)UITextField *passFid;
@property (nonatomic , strong)UITextField *conPassFid;
//资金密码   确认资金密码
@property (nonatomic , strong)UITextField *moneyFid;

@property (nonatomic , strong)UITextField *conMoneyFid;

@property (nonatomic , strong)UILabel *levelStateLbl;
@end

@implementation RegisterVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navigationTransparentClearColor];
}

//如果仅设置当前页导航透明，需加入下面方法
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self navigationSetDefault];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
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
    }
    
    
    
}

#pragma mark -- scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIView *lineView1 = [self.view viewWithTag:123];
    UIView *lineView2 = [self.view viewWithTag:124];
    UIView *lineView3 = [self.view viewWithTag:125];
    
    w = scrollView.contentOffset.x/SCREEN_WIDTH;
    
    if (w == 0) {
        lineView1.backgroundColor = kHexColor(@"68c5ca");
        lineView2.backgroundColor = kWhiteColor;
        lineView3.backgroundColor = kWhiteColor;
    }
    if (w == 1) {
        lineView1.backgroundColor = kHexColor(@"68c5ca");
        lineView2.backgroundColor = kHexColor(@"68c5ca");
        lineView3.backgroundColor = kWhiteColor;
    }
    if (w == 2) {
        lineView1.backgroundColor = kHexColor(@"68c5ca");
        lineView2.backgroundColor = kHexColor(@"68c5ca");
        lineView3.backgroundColor = kHexColor(@"68c5ca");
    }
    
    NSLog(@"%.2f",scrollView.contentOffset.x);
    NSLog(@"%ld",w);
    
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

#pragma mark -- 下一步
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
        UIView *pointView1 = [self.view viewWithTag:300];

        if (pointView1.backgroundColor != [UIColor greenColor]) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"密码位数为8~25位数(字母+数字)" key:nil]];
            return;
        }
        
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * 2, 0) animated:YES];
        [self.view endEditing:YES];
        
    }
    
    if (w == 2) {
        if (_moneyFid.text.length != 6) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"资金密码为6位数" key:nil]];
            return;
        }
        if (![_moneyFid.text isPhoneNum]) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入资金密码" key:nil]];
            return;
        }
        if (![_conMoneyFid.text isPhoneNum]) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请确认资金密码" key:nil]];
            return;
        }
        if (![_moneyFid.text isEqualToString:_conMoneyFid.text]) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"密码不一致" key:nil]];
            return;
        }
        
        [self.view endEditing:YES];
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        if (isSelectBtn.tag == 100) {
            http.code = @"805045";
            http.parameters[@"mobile"] = self.phoneTextFid.text;
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
            CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            http.parameters[@"countryCode"] = model.code;
        }else
        {
            http.code = @"805046";
            http.parameters[@"email"] = self.phoneTextFid.text;
        }
        
        
        http.parameters[@"smsCaptcha"] = self.codeTextFid.text;
        http.parameters[@"loginPwd"] = self.passFid.text;
        http.parameters[@"tradePwd"] = self.moneyFid.text;
        
        http.parameters[@"kind"] = APP_KIND;
        http.parameters[@"client"] = @"ios";
        
        [http postWithSuccess:^(id responseObject) {
            NSString *token = responseObject[@"data"][@"token"];
            NSString *userId = responseObject[@"data"][@"userId"];
            [MobClick profileSignInWithPUID:userId];
            //获取用户信息
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            http.code = USER_INFO;
            http.parameters[@"userId"] = userId;
            http.parameters[@"token"] = token;
            [http postWithSuccess:^(id responseObject) {
                
                
                CompleteTheRegistrationVC *vc = [CompleteTheRegistrationVC new];
                vc.userInfo = responseObject[@"data"];
                vc.token = token;
                vc.userid = userId;
                [self.navigationController pushViewController:vc animated:YES];
                
            } failure:^(NSError *error) {
                
            }];
        } failure:^(NSError *error) {
            
        }];
        
        
    }
}


- (void)textFieldDidChange:(UITextField *)textField {
    NSLog(@"%@",textField.text);
    if (textField.tag != 12345) {
        return;
    }
    NSString *level;
    NSString *State;
    NSString *str;
    level = [LangSwitcher switchLang:@"安全级别" key:nil];
//    NSString *State = [LangSwitcher switchLang:@"底" key:nil];
//    NSString *str = [NSString stringWithFormat:@"%@ %@",level,State];
    UIView *pointView1 = [self.view viewWithTag:300];
    UIView *pointView2 = [self.view viewWithTag:301];
    UIView *pointView3 = [self.view viewWithTag:302];
//    UIView *pointView4 = [self.view viewWithTag:303];
    pointView1.backgroundColor = kWhiteColor;
    pointView2.backgroundColor = kWhiteColor;
    pointView3.backgroundColor = kWhiteColor;
//    pointView4.backgroundColor = kWhiteColor;
    
    NSString *testString = textField.text;
    NSInteger alength = [testString length];
    if (textField.text.length >= 8 && [[UserModel user]isStringTheCapitalLettersWith:textField.text] == YES && [[UserModel user]isStringContainNumberWith:textField.text] == YES) {
        pointView1.backgroundColor = [UIColor greenColor];
        State = [LangSwitcher switchLang:@"低" key:nil];
        
        
        for (int i = 0; i<alength; i++) {
            char commitChar = [testString characterAtIndex:i];
            if((commitChar>96)&&(commitChar<123)){
                NSLog(@"字符串中含有小写英文字母");
                pointView2.backgroundColor = [UIColor greenColor];
                State = [LangSwitcher switchLang:@"中" key:nil];
            }
//            if((commitChar>47)&&(commitChar<58)){
////                包含数字
//                pointView4.backgroundColor = [UIColor greenColor];
//                State = [LangSwitcher switchLang:@"中" key:nil];
//            }
            
            if((commitChar>64)&&(commitChar<91)){
                
                NSLog(@"字符串中含有大写英文字母");
                pointView3.backgroundColor = [UIColor greenColor];
                State = [LangSwitcher switchLang:@"中" key:nil];
                
            }
            
            if (pointView3.backgroundColor == [UIColor greenColor] && pointView2.backgroundColor == [UIColor greenColor] && pointView1.backgroundColor == [UIColor greenColor]) {
                State = [LangSwitcher switchLang:@"高" key:nil];
            }
        }
    }else
    {
        pointView1.backgroundColor = kWhiteColor;
        pointView2.backgroundColor = kWhiteColor;
        pointView3.backgroundColor = kWhiteColor;
//        pointView4.backgroundColor = kWhiteColor;
    }
    if ([TLUser isBlankString:State] == YES) {
        State = [LangSwitcher switchLang:@"低" key:nil];
    }
    str = [NSString stringWithFormat:@"%@ %@",level,State];
    [self LabelSecurityLevelLevel:level setState:State setStr:str];
    
//    _warningLabel.text = [self checkContentTypeWithString:textField.text];
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

            if (isSelectBtn.tag == 100) {
                TLNetworking *http = [TLNetworking new];
                http.showView = self.view;
                http.code = CAPTCHA_CODE;
                http.parameters[@"client"] = @"ios";
                http.parameters[@"sessionId"] = sessionId;
                http.parameters[@"bizType"] = @"805045";
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
                http.parameters[@"bizType"] = @"805046";
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

-(void)initView
{
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    [self.view addSubview:backImage];
    
    UILabel *nameLable = [[UILabel alloc]init];
    nameLable.text = [LangSwitcher switchLang:@"注册Theia个人账户" key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(16);
    nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = nameLable;
    
    
    for (int i = 0; i < 3; i ++) {
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(12 + i % 3 * (SCREEN_WIDTH - 24)/3, SCREEN_HEIGHT - kNavigationBarHeight - 45 - 7.5, (SCREEN_WIDTH - 30)/3, 7.5)];
        bottomView.backgroundColor = kWhiteColor;
        [self.view addSubview:bottomView];
        bottomView.tag = 123 + i;
        if (i == 0) {
            bottomView.backgroundColor = kHexColor(@"68c5ca");
        }
    }
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT + kStatusBarHeight)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
//    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    [self registrationWayUI];
    [self setThePassword];
    [self moneyPasswordUI];
    
}

-(void)registrationWayUI
{
    NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
    CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSArray *array = @[[LangSwitcher switchLang:@"手机注册" key:nil],[LangSwitcher switchLang:@"邮箱注册" key:nil]];
    
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
    
    _phoneAreaCodeBtn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:14];
    
    _phoneAreaCodeBtn.frame = CGRectMake(46, registerLineView.yy + 50, 0, 15);
    _phoneAreaCodeBtn.titleLabel.font = HGboldfont(14);
    [_phoneAreaCodeBtn sizeToFit];
    _phoneAreaCodeBtn.frame = CGRectMake(46, registerLineView.yy + 50, _phoneAreaCodeBtn.frame.size.width + 6.5, 15);
    [_phoneAreaCodeBtn setImage:kImage(@"矩形4") forState:(UIControlStateNormal)];
    
    CGFloat imageW = _phoneAreaCodeBtn.imageView.image.size.width;
    CGFloat titleW = _phoneAreaCodeBtn.titleLabel.frame.size.width;
    CGFloat imageOffset = titleW + 0.5 * 3;
    CGFloat titleOffset = imageW + 0.5 * 3;
    
    _phoneAreaCodeBtn.imageEdgeInsets = UIEdgeInsetsMake(6.5, imageOffset, 0, - imageOffset);
    _phoneAreaCodeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, - titleOffset, 0, titleOffset);
    
    [_phoneAreaCodeBtn addTarget:self action:@selector(phoneAreaCodeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.scrollView addSubview:_phoneAreaCodeBtn];
    
    UITextField *phoneTextFid = [[UITextField alloc]initWithFrame:CGRectMake(_phoneAreaCodeBtn.xx + 15, registerLineView.yy + 50, SCREEN_WIDTH - _phoneAreaCodeBtn.xx - 60, 15)];
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


-(void)setThePassword
{
    UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:passwordView];
    
    NSArray *passWordArray = @[[LangSwitcher switchLang:@"输入登录密码" key:nil],[LangSwitcher switchLang:@"确认登录密码" key:nil]];
    NSArray *placArray = @[[LangSwitcher switchLang:@"请输入账号登录密码" key:nil],[LangSwitcher switchLang:@"请确认账号登录密码" key:nil]];
    
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
        if (i == 0) {
            passWordFid.delegate = self;
        }
        passWordFid.tag = 12345 + i;
        [passWordFid addTarget:self action:@selector(textFieldDidChange:) forControlEvents:(UIControlEventEditingChanged)];
        [passWordFid setValue:FONT(12) forKeyPath:@"_placeholderLabel.font"];
        passWordFid.font = FONT(12);
        passWordFid.textColor = [UIColor whiteColor];
        [passWordFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
//        passWordFid.clearsOnBeginEditing = NO;
        if (i == 0) {
            _passFid = passWordFid;
        }else
        {
            _conPassFid = passWordFid;
        }
        passWordFid.clearButtonMode = UITextFieldViewModeWhileEditing;
        [passwordView addSubview:passWordFid];
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(35, passWordFid.yy + 8.5, SCREEN_WIDTH - 70, 1)];
        lineView.backgroundColor = kLineColor;
        [passwordView addSubview:lineView];
        
    }
    
    NSArray *securityArray = @[[LangSwitcher switchLang:@"密码位数为8~25位(字母+数字)" key:nil],[LangSwitcher switchLang:@"密码中包含小写字母" key:nil],[LangSwitcher switchLang:@"密码中包含大写字母" key:nil]];
    for (int i = 0; i < 3; i ++) {
        UIView *pointView = [[UIView alloc]initWithFrame:CGRectMake(35, 160 - 64 + kNavigationBarHeight + 108 * 2 - 30 +i%4 * 20, 8, 8)];
        pointView.backgroundColor = kWhiteColor;
        kViewRadius(pointView, 4);
        pointView.tag = 300 + i;
        [passwordView addSubview:pointView];
        
        UILabel *securityLbl = [UILabel labelWithFrame:CGRectMake(49, 160 - 64 + kNavigationBarHeight + 108 * 2 - 30 +i%4 * 20 - 2, SCREEN_WIDTH - 49 - 35, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:kWhiteColor];
        securityLbl.text = securityArray[i];
        securityLbl.tag = 200 + i;
        [passwordView addSubview:securityLbl];
    }
    
    
    UILabel *label = [self.view viewWithTag:202];
    UILabel *levelStateLbl = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH - 35, label.y - 4, 0, 18) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(12) textColor:kWhiteColor];
    NSString *level = [LangSwitcher switchLang:@"安全级别" key:nil];
    NSString *State = [LangSwitcher switchLang:@"低" key:nil];
    NSString *str = [NSString stringWithFormat:@"%@ %@",level,State];
    self.levelStateLbl = levelStateLbl;
    [self LabelSecurityLevelLevel:level setState:State setStr:str];
    [passwordView addSubview:levelStateLbl];
    
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"" titleColor:kClearColor backgroundColor:kClearColor titleFont:0];
    confirmBtn.frame = CGRectMake(SCREEN_WIDTH - 85, levelStateLbl.yy + 20, 50, 50);
    [confirmBtn setBackgroundImage:kImage(@"矩形3拷贝") forState:(UIControlStateNormal)];
    [confirmBtn addTarget:self action:@selector(nextBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [passwordView addSubview:confirmBtn];
}

-(void)LabelSecurityLevelLevel:(NSString *)level setState:(NSString *)State setStr:(NSString *)str
{
    UILabel *label = [self.view viewWithTag:202];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]      initWithString:str];
    [attrStr addAttribute:NSFontAttributeName value:HGboldfont(18) range:NSMakeRange(str.length - State.length,State.length)];
    _levelStateLbl.attributedText = attrStr;
    [_levelStateLbl sizeToFit];
    _levelStateLbl.frame = CGRectMake(SCREEN_WIDTH - 35 - _levelStateLbl.width, label.y - 6, _levelStateLbl.width, 18);
}


-(void)moneyPasswordUI
{
    UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:passwordView];
    
    NSArray *passWordArray = @[[LangSwitcher switchLang:@"输入资金密码" key:nil],[LangSwitcher switchLang:@"确认资金密码" key:nil]];
    NSArray *placArray = @[[LangSwitcher switchLang:@"请输入账号资金密码" key:nil],[LangSwitcher switchLang:@"请确认账号资金密码" key:nil]];
    
    
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
        passWordFid.delegate = self;
        passWordFid.tag = 10000 + i;
        [passwordView addSubview:passWordFid];
        if (i == 0) {
            self.moneyFid = passWordFid;
        }else
        {
            self.conMoneyFid = passWordFid;
        }
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(35, passWordFid.yy + 8.5, SCREEN_WIDTH - 70, 1)];
        lineView.backgroundColor = kLineColor;
        [passwordView addSubview:lineView];
        if (i == 1) {
            bottomView =lineView;
        }
    }
    
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"完成注册" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:18];
    confirmBtn.frame = CGRectMake(50, bottomView.yy + 75, SCREEN_WIDTH - 100, 50);
    kViewRadius(confirmBtn, 10);
    [confirmBtn setBackgroundImage:kImage(@"矩形5-1") forState:(UIControlStateNormal)];
    [confirmBtn addTarget:self action:@selector(nextBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [passwordView addSubview:confirmBtn];
    
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField.tag == 10000 || textField.tag == 10001) {
        if ([string length]>0)
        {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if ((single >='0' && single<='9'))//数据格式正确
            {
                return YES;
            }else{
                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"密码为6位数数字" key:nil]];
                return NO;
            }
        }else
        {
            return YES;
        }
    }
    return YES;
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
