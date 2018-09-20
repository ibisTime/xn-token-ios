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
#import <SecurityGuardSDK/JAQ/SecurityVerification.h>
#import <MSAuthSDK/MSAuthVCFactory.h>
#import <MSAuthSDK/MSAuthSDK.h>
#import <SecurityGuardSDK/JAQ/SecurityVerification.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface CloseGoogleAuthVC ()<MSAuthProtocol>

//谷歌验证码
@property (nonatomic, strong) TLTextField *googleAuthTF;
//短信验证码
@property (nonatomic,strong) CaptchaView *captchaView;

@end

@implementation CloseGoogleAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LangSwitcher switchLang:@"谷歌验证" key:nil];
    
    [self initSubviews];
    
}

#pragma mark - Init
- (void)initSubviews {
    
    CGFloat leftMargin = 0;
    
    CGFloat leftW = 100;
    
    CGFloat height = 45;
    
    //谷歌验证码
    self.googleAuthTF = [[TLTextField alloc] initWithFrame:CGRectMake(leftMargin, 10, kScreenWidth - 2*leftMargin, height)
                                                 leftTitle:[LangSwitcher switchLang:@"谷歌验证码" key:nil]
                                                titleWidth:leftW
                                               placeholder:[LangSwitcher switchLang:@"请输入谷歌验证码" key:nil]];
    
    self.googleAuthTF.keyboardType = UIKeyboardTypeNumberPad;

    [self.view addSubview:self.googleAuthTF];
    
    //复制
    UIView *authView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 95, self.googleAuthTF.height)];
    
    UIButton *pasteBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"粘贴" key:nil] titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:13.0 cornerRadius:5];
    
    pasteBtn.frame = CGRectMake(0, 0, 85, self.googleAuthTF.height - 15);
    
    pasteBtn.centerY = authView.height/2.0;
    
    [pasteBtn addTarget:self action:@selector(clickPaste) forControlEvents:UIControlEventTouchUpInside];
    
    [authView addSubview:pasteBtn];
    
    self.googleAuthTF.rightView = authView;
    self.captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(leftMargin, self.googleAuthTF.yy, kScreenWidth - 2*leftMargin, height) leftTitleWidth:100];
    self.captchaView.captchaTf.leftLbl.text = [LangSwitcher switchLang:@"短信验证码" key:nil];
    [self.captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.captchaView];
    //短信验证码
//    self.captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(leftMargin, self.googleAuthTF.yy, kScreenWidth - 2*leftMargin, height)];
//
//    self.captchaView.captchaTf.leftLbl.text = [LangSwitcher switchLang:@"短信验证码" key:nil];
//
//    [self.captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.view addSubview:self.captchaView];
    
    //修改按钮
    UIButton *confirmBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"关闭谷歌认证" key:nil] titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    
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
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"粘贴内容为空" key:nil]];
    }
}

- (void)sendCaptcha {

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
            //发送验证码
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            http.code = CAPTCHA_CODE;
            http.parameters[@"client"] = @"ios";
            http.parameters[@"sessionId"] = sessionId;
            http.parameters[@"bizType"] = @"805072";
            http.parameters[@"mobile"] = [TLUser user].mobile;
            http.parameters[@"interCode"] = [TLUser user].interCode;
            http.parameters[@"sessionId"] = sessionId;

            [http postWithSuccess:^(id responseObject) {

                [TLAlert alertWithSucces:[LangSwitcher switchLang:@"验证码已发送,请注意查收" key:nil]];

                [self.captchaView.captchaBtn begin];

            } failure:^(NSError *error) {

            }];
        }
        [self.navigationController popViewControllerAnimated:YES];
        //将sessionid传到经过app服务器做二次验证
    });
}


- (void)changeGoogleAuth {
    
    if (![self.googleAuthTF.text valid]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入谷歌验证码" key:nil]];
        return;
    }
    
    //判断谷歌验证码是否为纯数字
    if (![NSString isPureNumWithString:self.googleAuthTF.text]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的谷歌验证码" key:nil]];
        return ;
    }
    
    //判断谷歌验证码是否为6位
    if (self.googleAuthTF.text.length != 6) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的谷歌验证码" key:nil]];
        return ;
    }
    
    if (![self.captchaView.captchaTf.text valid]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入短信验证码" key:nil]];
        return ;
    }
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805072";
    http.showView = self.view;
    
    http.parameters[@"googleCaptcha"] = self.googleAuthTF.text;
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"interCode"] = [TLUser user].interCode;

    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"关闭成功" key:nil]];
        
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
