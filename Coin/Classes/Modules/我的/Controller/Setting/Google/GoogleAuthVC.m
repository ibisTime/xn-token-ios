//
//  GoogleAuthVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/12/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "GoogleAuthVC.h"

#import "TLTextField.h"
#import "CaptchaView.h"

#import "APICodeMacro.h"

#import "NSString+Check.h"

@interface GoogleAuthVC ()<UITextFieldDelegate>

//密钥
@property (nonatomic, strong) TLTextField *secretTF;
//谷歌验证码
@property (nonatomic, strong) TLTextField *googleAuthTF;
//短信验证码
@property (nonatomic,strong) CaptchaView *captchaView;

@end

@implementation GoogleAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"谷歌验证";
    
    [self initSubviews];
    //获取密钥
    [self getSecret];
}

#pragma mark - Init
- (void)initSubviews {
    
    CGFloat leftMargin = 0;
    CGFloat leftW = 100;
    CGFloat height = 45;
    
    //密钥
    self.secretTF = [[TLTextField alloc] initWithFrame:CGRectMake(leftMargin, 10, kScreenWidth - 2*leftMargin, height)
                                                    leftTitle:@"密钥"
                                                   titleWidth:leftW
                                                  placeholder:@""];
    
    self.secretTF.delegate = self;
    
    [self.view addSubview:self.secretTF];
    
    //复制
    UIView *secretView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 95, self.secretTF.height)];
    
    UIButton *copyBtn = [UIButton buttonWithTitle:@"复制" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:13.0 cornerRadius:5];
    
    copyBtn.frame = CGRectMake(0, 0, 85, self.secretTF.height - 15);
    
    copyBtn.centerY = secretView.height/2.0;

    [copyBtn addTarget:self action:@selector(clickCopy) forControlEvents:UIControlEventTouchUpInside];
    
    [secretView addSubview:copyBtn];
    
    self.secretTF.rightView = secretView;
    
    //谷歌验证码
    self.googleAuthTF = [[TLTextField alloc] initWithFrame:CGRectMake(leftMargin, self.secretTF.yy, kScreenWidth - 2*leftMargin, height)
                                             leftTitle:@"谷歌验证码"
                                            titleWidth:leftW
                                           placeholder:@"请输入谷歌验证码"];
    
    [self.view addSubview:self.googleAuthTF];
    
    //复制
    UIView *authView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 95, self.googleAuthTF.height)];
    
    UIButton *pasteBtn = [UIButton buttonWithTitle:@"粘贴" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:13.0 cornerRadius:5];
    
    pasteBtn.frame = CGRectMake(0, 0, 85, self.googleAuthTF.height - 15);

    pasteBtn.centerY = authView.height/2.0;

    [pasteBtn addTarget:self action:@selector(clickPaste) forControlEvents:UIControlEventTouchUpInside];
    
    [authView addSubview:pasteBtn];
    
    self.googleAuthTF.rightView = authView;
    
    //短信验证码
    self.captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(leftMargin, self.googleAuthTF.yy, kScreenWidth - 2*leftMargin, height)];
    
    self.captchaView.captchaTf.leftLbl.text = @"短信验证码";
    
    [self.captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.captchaView];
    
    //修改按钮
    
    NSString *title = [TLUser user].isGoogleAuthOpen ? @"修改谷歌验证": @"开启谷歌验证";

    UIButton *confirmBtn = [UIButton buttonWithTitle:title titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:16.0 cornerRadius:5];
    
    confirmBtn.frame = CGRectMake(15, self.captchaView.yy + 30, kScreenWidth - 2*15, 45);
    
    [confirmBtn addTarget:self action:@selector(changeGoogleAuth) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
    
    for (int i = 0; i < 3; i++) {
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, i*height + 10, kScreenWidth, 0.5)];
        
        line.backgroundColor = kLineColor;
        
        [self.view addSubview:line];
    }
}

#pragma mark - Events
- (void)clickCopy {
    
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    
    pasteBoard.string = self.secretTF.text;
    
    if (pasteBoard == nil) {
        
        [TLAlert alertWithError:@"复制内容为空, 请重新复制"];
        
    } else {
        
        [TLAlert alertWithSucces:@"复制成功"];
    }
}

- (void)clickPaste {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    if (pasteboard.string != nil) {
        
        self.googleAuthTF.text = pasteboard.string;
        
    } else {
        
        [TLAlert alertWithInfo:@"粘贴内容为空"];
    }
}

- (void)sendCaptcha {
    
    //发送验证码
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = CAPTCHA_CODE;
    http.parameters[@"bizType"] = @"805071";
    http.parameters[@"mobile"] = [TLUser user].mobile;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"验证码已发送,请注意查收"];
        
        [self.captchaView.captchaBtn begin];
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)changeGoogleAuth {
    
    if (![self.secretTF.text valid]) {
        
        [TLAlert alertWithInfo:@"密钥为空, 请重新获取"];
        return ;
    }
    
    if (![self.googleAuthTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入谷歌验证码"];
        return;
    }
    
    if (![self.captchaView.captchaTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入短信验证码"];
        return ;
    }
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805071";
    http.showView = self.view;
    
    http.parameters[@"googleCaptcha"] = self.googleAuthTF.text;
    http.parameters[@"secret"] = self.secretTF.text;
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *title = [TLUser user].isGoogleAuthOpen ? @"修改成功": @"开启成功";
        [TLAlert alertWithSucces:title];
        //谷歌验证设置为已开启
        [TLUser user].googleAuthFlag = @"1";
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Data
- (void)getSecret {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805070";
    http.showView = self.view;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.secretTF.text = responseObject[@"data"][@"secret"];
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.secretTF) {
        
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
