//
//  EditVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/20.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "EditEmailVC.h"

#import "CoinHeader.h"

#import "TLTextField.h"

#import "NSString+Check.h"
#import "UIBarButtonItem+convience.h"
#import "CaptchaView.h"
//#import "TLCaptchaView.h"
#import "CaptchaView.h"

@interface EditEmailVC ()

@property (nonatomic, strong) TLTextField *contentTf;
//@property (nonatomic, strong) TLTextField *codeTf;
@property (nonatomic, strong) CaptchaView *captchaView;

@end

@implementation EditEmailVC

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.contentTf becomeFirstResponder];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.contentTf resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [LangSwitcher switchLang:@"绑定邮箱" key:nil];
    [self setUpUI];
    
    //
    self.contentTf.text = [TLUser user].email;
    
}

- (void)setUpUI {
    
    [UIBarButtonItem addRightItemWithTitle:[LangSwitcher switchLang:@"完成" key:nil] titleColor:kTextColor frame:CGRectMake(0, 0, 40, 20) vc:self action:@selector(hasDone)];
    
    
    self.contentTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 45)
                                              leftTitle:[LangSwitcher switchLang:@"邮箱" key:nil]
                                             titleWidth:80
                                            placeholder:[LangSwitcher switchLang:@"请输入您的邮箱"    key:nil]];
    
    
    self.contentTf.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:self.contentTf];
    
   
    
    //
    self.captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(0, self.contentTf.yy + 0.7, kScreenWidth, 45) leftTitleWidth:80];
//    self.captchaView.captchaTf.text = [LangSwitcher switchLang:@"验证码" key:nil];
    [self.view addSubview:self.captchaView];
    UILabel *code = [[UILabel alloc] init];
    [self.captchaView addSubview:code];
    
    code.textColor = kTextColor;
    code.font = [UIFont systemFontOfSize:14];
    code.text = [LangSwitcher switchLang:@"验证码" key:nil];
    [code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.captchaView.mas_left).offset(15);
        make.centerY.equalTo(self.captchaView.mas_centerY).offset(0);

    }];
//    self.codeTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.contentTf.yy, kScreenWidth, 45)
//                                           leftTitle:[LangSwitcher switchLang:@"验证码" key:nil]
//                                          titleWidth:80
//                                         placeholder:[LangSwitcher switchLang:@"请输入验证码"    key:nil]];
//    self.codeTf.keyboardType = UIKeyboardTypeNumberPad;
//    [self.view addSubview:self.codeTf];
    [self.captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    
    
}


#pragma mark- 发送验证码
- (void)sendCaptcha {
    
    if (![self.contentTf.text valid]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入邮箱" key:nil]];
        return;
    }
    
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805954";
//    http.parameters[@"companyCode"] = @"";
    http.parameters[@"email"] = self.contentTf.text;
    http.parameters[@"bizType"] = @"805081";
//    http.parameters[@"systemCode"] = [];

    [http postWithSuccess:^(id responseObject) {
        //
        [self.captchaView.captchaBtn begin];
        
    } failure:^(NSError *error) {
        
    }];

}

- (void)hasDone {
    
    NSString *content = self.contentTf.text;
    NSString *captcha = self.captchaView.captchaTf.text;

    
    if (![content valid]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入邮箱" key:nil]];
        return;
    }
    
    if (![captcha valid]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入验证码" key:nil]];
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805081";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"email"] = content;
    http.parameters[@"captcha"] = captcha;
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"绑定成功" key:nil]];
        [TLUser user].nickname = self.contentTf.text;
        
        [[TLUser user] updateUserInfo];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.done) {
            self.done(content);
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
    
}


@end

