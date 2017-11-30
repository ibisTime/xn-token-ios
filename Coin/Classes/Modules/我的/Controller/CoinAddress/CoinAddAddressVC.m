//
//  CoinAddAddressVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CoinAddAddressVC.h"

#import "CoinHeader.h"

#import "APICodeMacro.h"

#import "NSString+Check.h"

#import "TLTextField.h"
#import "CaptchaView.h"
#import "FilterView.h"

#import "QRCodeVC.h"

@interface CoinAddAddressVC ()
//标签
@property (nonatomic, strong) TLTextField *remarkTF;
//提币地址
@property (nonatomic, strong) UILabel *receiveAddressLbl;
//选择
@property (nonatomic, strong) FilterView *coinAddressPicker;
//验证码
@property (nonatomic,strong) CaptchaView *captchaView;
//认证账户
//开关
@property (nonatomic, strong) UISwitch *sw;

@end

@implementation CoinAddAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加地址";
    
    [self initSubviews];
}

#pragma mark - Init
- (void)initSubviews {
    
    CGFloat heightMargin = 50;

    //标签
    self.remarkTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, heightMargin) leftTitle:@"标签" titleWidth:90 placeholder:@"请输入标签"];
    
    [self.remarkTF setValue:kPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.view addSubview:self.remarkTF];
    
    //分割线
    UIView *remarkLine = [[UIView alloc] init];
    
    remarkLine.backgroundColor = kLineColor;
    
    [self.remarkTF addSubview:remarkLine];
    [remarkLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@(-0.5));
        
    }];
    
    //提币地址
    UIView *receiveView = [[UIView alloc] initWithFrame:CGRectMake(0, self.remarkTF.yy, kScreenWidth, heightMargin)];
    
    receiveView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:receiveView];
    //更多
    UIImageView *rightArrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    [receiveView addSubview:rightArrowIV];
    [rightArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(receiveView.mas_right).offset(-15);
        make.centerY.equalTo(receiveView.mas_centerY);
        make.width.equalTo(@6.5);
        
    }];
    
    UILabel *receiveTextLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    receiveTextLbl.text = @"提币地址";
    
    [receiveView addSubview:receiveTextLbl];
    [receiveTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(receiveView.mas_centerY);
        
    }];
    
    UIView *receiveLine = [[UIView alloc] init];
    
    receiveLine.backgroundColor = kLineColor;
    
    [receiveView addSubview:receiveLine];
    [receiveLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    
    UILabel *receiveAddressLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kPlaceholderColor font:14.0];
    
    receiveAddressLbl.text = @"请选择提币地址或扫码录入";
    
    receiveAddressLbl.numberOfLines = 0;
    
    [receiveView addSubview:receiveAddressLbl];
    [receiveAddressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@90);
        make.right.equalTo(rightArrowIV.mas_left).offset(-10);
        make.centerY.equalTo(receiveView.mas_centerY);
        
    }];
    
    self.receiveAddressLbl = receiveAddressLbl;
    
    //
    UIButton *receiveBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, self.remarkTF.yy + 10, kScreenWidth, heightMargin)];
    
    [receiveBtn addTarget:self action:@selector(selectCoinAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:receiveBtn];
    
    //验证码
    CaptchaView *captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(0, receiveView.yy + 1, kScreenWidth, heightMargin)];
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:captchaView];
    
    self.captchaView = captchaView;
    
    
    //认证账户
    UIView *authAccountView = [[UIView alloc] init];
    
    authAccountView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:authAccountView];
    [authAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@(0));
        make.top.equalTo(captchaView.mas_bottom).offset(0);
        make.height.equalTo(@50);
        
    }];
    
    //
    UILabel *tranTextLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    tranTextLbl.text = @"将该账户设置为认证账户";
    
    [authAccountView addSubview:tranTextLbl];
    [tranTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(authAccountView.mas_centerY);
        
    }];
    
    //开关
    UISwitch *sw = [[UISwitch alloc] init];
    
    sw.on = NO;
    
    [authAccountView addSubview:sw];
    [sw mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
        
    }];
    
    //分割线
    UIView *authLine = [[UIView alloc] init];
    
    authLine.backgroundColor = kLineColor;
    
    [authAccountView addSubview:authLine];
    [authLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    
    //提示
    UIView *minerView = [[UIView alloc] init];
    
    minerView.backgroundColor = [UIColor colorWithHexString:@"#fdfdfd"];
    
    [self.view addSubview:minerView];
    [minerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.top.equalTo(authAccountView.mas_bottom);
        
    }];
    
    UILabel *minerPromptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:11.0];
    
    minerPromptLbl.text = @"向认证账户提现将不再输入资金密码、短信验证码";
    
    minerPromptLbl.numberOfLines = 0;
    
    [minerView addSubview:minerPromptLbl];
    [minerPromptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 32, 10, 15));
        
        make.left.equalTo(self.view.mas_left).offset(32);
        make.centerY.equalTo(minerView.mas_centerY);
        make.width.equalTo(@(kScreenWidth - 32 - 15));
        
    }];
    //分割线
    UIView *minerLine = [[UIView alloc] init];
    
    minerLine.backgroundColor = kLineColor;
    
    [minerView addSubview:minerLine];
    [minerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    
    //确认
    UIButton *confirmPayBtn = [UIButton buttonWithTitle:@"确认" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:16.0 cornerRadius:5];
    
    [confirmPayBtn addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmPayBtn];
    [confirmPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.top.equalTo(minerView.mas_bottom).offset(40);
        make.right.equalTo(@(-15));
        make.height.equalTo(@45);
        
    }];
}

- (FilterView *)coinAddressPicker {
    
    if (!_coinAddressPicker) {
        
        CoinWeakSelf;
        
        NSArray *textArr = @[@"扫描二维码", @"粘贴地址"];
        
        _coinAddressPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _coinAddressPicker.title = @"提币地址";
        
        _coinAddressPicker.selectBlock = ^(NSInteger index) {
            
            [weakSelf pickerEventWithIndex:index];
        };
        
        _coinAddressPicker.tagNames = textArr;
        
    }
    
    return _coinAddressPicker;
}

#pragma mark - Events

- (void)sendCaptcha {
    
//    if ([TLUser user].mobile) {
//
//        [TLAlert alertWithInfo:@"手机号不存在, 请登录"];
//
//        return ;
//    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = CAPTCHA_CODE;
    http.parameters[@"bizType"] = @"625203";
    http.parameters[@"mobile"] = [TLUser user].mobile;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"验证码已发送,请注意查收"];
        
        [self.captchaView.captchaBtn begin];
        
    } failure:^(NSError *error) {
        
        [TLAlert alertWithError:@"发送失败,请检查手机号"];
        
    }];
    
}

- (void)clickConfirm:(UIButton *)sender {
    
    if (self.sw.on) {
        
        [TLAlert alertWithTitle:@"请输入资金密码" msg:@"" confirmMsg:@"确定" cancleMsg:@"取消" placeHolder:@"请输入资金密码" maker:self cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action, UITextField *textField) {
            
            [self confirmWithdrawalsWithPwd:textField.text];
            
        }];
        
    } else {
        
        [self confirmWithdrawalsWithPwd:nil];

    }

}

- (void)selectCoinAddress {
    
    [self.view endEditing:YES];
    
    [self.coinAddressPicker show];
}

- (void)pickerEventWithIndex:(NSInteger)index {
    
    CoinWeakSelf;
    
    switch (index) {
            //扫描二维码
        case 0:
        {
            QRCodeVC *qrCodeVC = [QRCodeVC new];
            
            qrCodeVC.scanSuccess = ^(NSString *result) {
                
                weakSelf.receiveAddressLbl.text = result;
                
                weakSelf.receiveAddressLbl.textColor = kTextColor;
            };
            
            [self.navigationController pushViewController:qrCodeVC animated:YES];
            
        }break;
            //粘贴地址
        case 1:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            
            if (pasteboard.string != nil) {
                
                self.receiveAddressLbl.text = pasteboard.string;
                
                self.receiveAddressLbl.textColor = kTextColor;
                
            } else {
                
                [TLAlert alertWithInfo:@"粘贴内容为空"];
            }
            
            
        }break;
            
        default:
            break;
    }
}

#pragma mark - Data
//新增用户ETH地址
- (void)confirmWithdrawalsWithPwd:(NSString *)pwd {
    
    if (![self.remarkTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入标签"];
        return ;
    }
    
    if ([self.receiveAddressLbl.text isEqualToString:@"请选择提币地址或扫码录入"]) {
        
        [TLAlert alertWithInfo:@"请选择提币地址"];
        return ;
    }
    
    if (!(self.captchaView.captchaTf.text && self.captchaView.captchaTf.text.length > 3)) {
        
        [TLAlert alertWithInfo:@"请输入正确的验证码"];
        return;
    }
    
    if (![pwd valid] && self.sw.on) {
        
        [TLAlert alertWithInfo:@"请输入资金密码"];
        return ;
    }
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625203";
    http.showView = self.view;
    http.parameters[@"address"] = self.receiveAddressLbl.text;
    http.parameters[@"isCerti"] = self.sw.on ? @"1": @"0";
    http.parameters[@"label"] = self.remarkTF.text;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
    http.parameters[@"payCardNo"] = self.receiveAddressLbl.text;
    http.parameters[@"tradePwd"] = pwd;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"添加成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        if (self.success) {
            
            self.success();
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
