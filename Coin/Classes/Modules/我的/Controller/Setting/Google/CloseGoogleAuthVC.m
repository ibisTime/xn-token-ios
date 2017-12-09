//
//  CloseGoogleAuthVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/12/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CloseGoogleAuthVC.h"

#import "TLTextField.h"
#import "CaptchaView.h"

#import "APICodeMacro.h"

#import "NSString+Check.h"

@interface CloseGoogleAuthVC ()

//谷歌验证码
@property (nonatomic, strong) TLTextField *googleAuthTF;
//短信验证码
@property (nonatomic,strong) CaptchaView *captchaView;

@end

@implementation CloseGoogleAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"谷歌验证";
    
    [self initSubviews];
    
}

#pragma mark - Init
- (void)initSubviews {
    
    CGFloat leftMargin = 0;
    
    CGFloat leftW = 100;
    
    CGFloat height = 45;
    
    //谷歌验证码
    self.googleAuthTF = [[TLTextField alloc] initWithFrame:CGRectMake(leftMargin, 10, kScreenWidth - 2*leftMargin, height)
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
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"关闭谷歌认证" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:16.0 cornerRadius:5];
    
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
    http.parameters[@"bizType"] = @"805072";
    http.parameters[@"mobile"] = [TLUser user].mobile;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"验证码已发送,请注意查收"];
        
        [self.captchaView.captchaBtn begin];
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)changeGoogleAuth {
    
    if (![self.googleAuthTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入谷歌验证码"];
        return;
    }
    
    if (![self.captchaView.captchaTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入短信验证码"];
        return ;
    }
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805072";
    http.showView = self.view;
    
    http.parameters[@"googleCaptcha"] = self.googleAuthTF.text;
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"关闭成功"];
        
        //谷歌验证设置为未开启
        [TLUser user].googleAuthFlag = @"0";
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
