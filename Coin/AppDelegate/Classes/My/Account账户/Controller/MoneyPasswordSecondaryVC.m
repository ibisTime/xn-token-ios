//
//  MoneyPasswordSecondaryVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/12/12.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "MoneyPasswordSecondaryVC.h"

@interface MoneyPasswordSecondaryVC ()<UITextFieldDelegate>
@property (nonatomic , strong)UITextField *passFid;
@property (nonatomic , strong)UITextField *conPassFid;
@end

@implementation MoneyPasswordSecondaryVC

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
    [self moneyPasswordUI];
}


-(void)moneyPasswordUI
{
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    [self.view addSubview:backImage];
    
//    UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [backImage addSubview:passwordView];
    
    
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, SCREEN_WIDTH, 44)];
    nameLable.text = [LangSwitcher switchLang:@"密码找回" key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(16);
    nameLable.textColor = [UIColor whiteColor];
//    [self.view addSubview:nameLable];
    self.navigationItem.titleView = nameLable;
    
    NSArray *passWordArray = @[[LangSwitcher switchLang:@"密码" key:nil],[LangSwitcher switchLang:@"确认密码" key:nil]];
    NSArray *placArray;
    if ([self.titleNameStr isEqualToString:@"修改资金密码"]) {
        placArray = @[[LangSwitcher switchLang:@"请输入账号资金密码" key:nil],[LangSwitcher switchLang:@"请确认账号资金密码" key:nil]];
    }else
    {
        placArray = @[[LangSwitcher switchLang:@"密码为8~25为数字加字母" key:nil],[LangSwitcher switchLang:@"两次输入密码必须一致" key:nil]];
    }
    
    
    
    UIView *bottomView;
    for (int i = 0; i < 2; i ++) {
        UILabel *passWordLbl = [UILabel labelWithFrame:CGRectMake(35, 160 - 64 + i % 2 * 108, SCREEN_WIDTH - 70, 16) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(16) textColor:kWhiteColor];
        passWordLbl.text = passWordArray[i];
        [self.view addSubview:passWordLbl];
        
        
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, passWordLbl.yy + 21 - 1.5, 10, 15)];
        iconImage.image = kImage(@"安全组拷贝");
        [self.view addSubview:iconImage];
        
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
        [self.view addSubview:passWordFid];
        passWordFid.tag = 10000 + i;
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(35, passWordFid.yy + 8.5, SCREEN_WIDTH - 70, 1)];
        lineView.backgroundColor = kLineColor;
        [self.view addSubview:lineView];
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
    [self.view addSubview:confirmBtn];
    
    
}

-(void)nextBtn
{
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
    
    if ([self.titleNameStr isEqualToString:@"修改资金密码"]) {
        if (_passFid.text.length != 6) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"资金密码为6位数" key:nil]];
            return;
        }
    }else
    {
        if (_passFid.text.length >= 8 && [[UserModel user]isStringTheCapitalLettersWith:_passFid.text] == YES && [[UserModel user]isStringContainNumberWith:_passFid.text] == YES) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"密码位数为8~25位数(字母+数字)" key:nil]];
        }
    }
    
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    if ([self.titleNameStr isEqualToString:@"修改资金密码"]) {
        http.code = @"805077";
        http.parameters[@"newTradePwd"] = self.passFid.text;
        
    }else
    {
        http.code = @"805076";
        http.parameters[@"newLoginPwd"] = self.passFid.text;
    }
    
    //        http.parameters[@"mobile"] = self.phoneTf.text;
    http.parameters[@"smsCaptcha"] = self.code;
    
    
    http.parameters[@"kind"] = APP_KIND;
    
    
    if (self.isModify == 0) {
        
        NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
        CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        http.parameters[@"loginName"] = [NSString stringWithFormat:@"%@%@",model.interCode,self.phone];
        //            http.parameters[@"interCode"] = model.interCode;
    }else
    {
        http.parameters[@"loginName"] = self.phone;
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"找回成功"];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            //                [weakSelf delayMethod];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if ([self.titleNameStr isEqualToString:@"修改资金密码"]) {
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
    }
    return YES;
}

@end
