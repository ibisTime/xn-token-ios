//
//  ZHChangeMobileVC.m
//  ZHBusiness
//
//  Created by  蔡卓越 on 2016/12/12.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLChangeMobileVC.h"

#import "TLPwdRelatedVC.h"

#import "TLCaptchaView.h"
#import "TLTextField.h"

#import "TLUser.h"

#import "NSString+Check.h"
#import "APICodeMacro.h"

@interface TLChangeMobileVC ()

@property (nonatomic,strong) TLTextField *phoneTf;
@property (nonatomic,strong) TLCaptchaView *captchaView;
//@property (nonatomic,strong) TLTextField *tradePwdTf;

@end

@implementation TLChangeMobileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat leftW = 90;
    self.title = @"修改手机号";
    CGFloat leftMargin = 0;
    
    //手机号
    TLTextField *phoneTf = [[TLTextField alloc] initWithFrame:CGRectMake(leftMargin, 10, kScreenWidth - 2*leftMargin, 45)
                                                    leftTitle:@"新手机号"
                                                   titleWidth:leftW
                                                  placeholder:@"请输入新手机号"];
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.bgSV addSubview:phoneTf];
    self.phoneTf = phoneTf;
    
    //验证码
    TLCaptchaView *captchaView = [[TLCaptchaView alloc] initWithFrame:CGRectMake(phoneTf.x, phoneTf.yy + 1, phoneTf.width, phoneTf.height)];
    [self.bgSV addSubview:captchaView];
    self.captchaView = captchaView;
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    
//    //资金密码按钮
//    TLTextField *tradePwdTf = [[TLTextField alloc] initWithframe:CGRectMake(0, captchaView.yy  + 1, kScreenWidth, 50) leftTitle:@"资金密码" titleWidth:90 placeholder:@"请输入支付密码"];
//    tradePwdTf.secureTextEntry = YES;
//    tradePwdTf.isSecurity = YES;
//    [self.view addSubview:tradePwdTf];
//    self.tradePwdTf = tradePwdTf;
    
//    //新手机号
//    TLTextField *newPhoneTf = [[TLTextField alloc] initWithframe:CGRectMake(0, captchaView.yy + 20, kScreenWidth, 45)
//                                                    leftTitle:@"新手机号"
//                                                   titleWidth:leftW
//                                                  placeholder:@"请输入手机号"];
//    [self.bgSV addSubview:newPhoneTf];
//    
//    //验证码
//    TLCaptchaView *newCaptchaView = [[TLCaptchaView alloc] initWithFrame:CGRectMake(phoneTf.x, newPhoneTf.yy + 1, phoneTf.width, phoneTf.height)];
//    [self.bgSV addSubview:newCaptchaView];
    
    //确认按钮
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确认修改" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    
    confirmBtn.frame = CGRectMake(15, captchaView.yy + 30, kScreenWidth - 30, 44);
    [self.bgSV addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    //
//    UIButton *setPwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, confirmBtn.yy + 10, kScreenWidth - 30, 30) title:@"您还未设置资金密码,前往设置->" backgroundColor:[UIColor clearColor]];
//    [self.view addSubview:setPwdBtn];
//    [setPwdBtn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
//    setPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [setPwdBtn addTarget:self action:@selector(setTrade:) forControlEvents:UIControlEventTouchUpInside];
//    
//    if ([[TLUser user].tradepwdFlag isEqualToString:@"1"]) {
//        setPwdBtn.hidden = YES;
//    }
    
}

- (void)setTrade:(UIButton *)btn {

    TLPwdRelatedVC *tradeVC = [[TLPwdRelatedVC alloc] initWithType:TLPwdTypeTradeReset];
    tradeVC.success = ^() {
        
        btn.hidden = YES;
        
    };
    [self.navigationController pushViewController:tradeVC animated:YES];


}

- (void)sendCaptcha {

    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }
//    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = CAPTCHA_CODE;
    http.parameters[@"bizType"] = USER_CAHNGE_MOBILE;
    http.parameters[@"mobile"] = self.phoneTf.text;

    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"验证码已发送,请注意查收"];

        [self.captchaView.captchaBtn begin];
        
    } failure:^(NSError *error) {
        
    }];


}

- (void)confirm {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        return;
    }
    
    if (![self.captchaView.captchaTf.text valid] || self.captchaView.captchaTf.text.length < 4 ) {
        [TLAlert alertWithInfo:@"请输入正确的验证码"];
        return;
    }

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_CAHNGE_MOBILE;
    http.parameters[@"newMobile"] = self.phoneTf.text;
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"userId"] = [TLUser user].userId;

    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"修改成功"];
        [TLUser user].mobile = self.phoneTf.text;
        
        //保存用户账号和密码
        [[TLUser user] saveUserName:self.phoneTf.text pwd:[TLUser user].userPassward];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
