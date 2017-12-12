//
//  WithdrawalsCoinVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "WithdrawalsCoinVC.h"

#import "UIBarButtonItem+convience.h"
#import "TLAlert.h"
#import "NSString+Check.h"
#import "UIViewController+BackButtonHander.h"
#import "APICodeMacro.h"

#import "BillVC.h"

#import "TLTextField.h"
#import "FilterView.h"

#import "QRCodeVC.h"
#import "CoinAddressListVC.h"

typedef NS_ENUM(NSInteger, AddressType) {
    
    AddressTypeSelectAddress = 0,       //选择地址
    AddressTypeScan,                    //扫码
    AddressTypeCopy,                    //复制粘贴
};

@interface WithdrawalsCoinVC ()

//可用余额
@property (nonatomic, strong) TLTextField *balanceTF;
//接收地址
@property (nonatomic, strong) UILabel *receiveAddressLbl;
//选择
@property (nonatomic, strong) FilterView *coinAddressPicker;
//转账数量
@property (nonatomic, strong) TLTextField *tranAmountTF;
//谷歌验证码
@property (nonatomic, strong) TLTextField *googleAuthTF;
//矿工费
@property (nonatomic, strong) TLTextField *minerFeeTF;
//开关
@property (nonatomic, strong) UISwitch *sw;
//提示
@property (nonatomic, strong) UIView *minerView;
//确认付币
@property (nonatomic, strong) UIButton *confirmBtn;
//手续费率
@property (nonatomic, copy) NSString *withdrawFee;
//地址类型
@property (nonatomic, assign) AddressType addressType;
//地址
@property (nonatomic, strong) CoinAddressModel *addressModel;

@end

@implementation WithdrawalsCoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"提币";
    //记录
    [self addRecordItem];
    //
    [self initSubviews];
    //获取手续费费率
    [self requestWithdrawFee];
}

- (BOOL)navigationShouldPopOnBackButton {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    return NO;
}

#pragma mark - Init
- (void)addRecordItem {
    
    [UIBarButtonItem addRightItemWithTitle:@"记录" titleColor:kTextColor frame:CGRectMake(0, 0, 40, 30) vc:self action:@selector(clickRecord:)];

}

- (void)initSubviews {
    
    CGFloat heightMargin = 50;
    //余额
    self.balanceTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, heightMargin) leftTitle:@"可用余额" titleWidth:90 placeholder:@""];
    
    self.balanceTF.textColor = kThemeColor;
    
    self.balanceTF.enabled = NO;
    
    NSString *leftAmount = [self.currency.amountString subNumber:self.currency.frozenAmountString];

    
    self.balanceTF.text = [NSString stringWithFormat:@"%@ %@", [leftAmount convertToSimpleRealCoin], self.currency.currency];
    
    [self.view addSubview:self.balanceTF];
    
    //接受地址
    UIView *receiveView = [[UIView alloc] initWithFrame:CGRectMake(0, self.balanceTF.yy + 10, kScreenWidth, heightMargin)];
                                                                   
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
    
    //
    UILabel *receiveTextLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    receiveTextLbl.text = @"接收地址";
    
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
    
    //获取placeholder的颜色
//    UIColor *placeholderColor = [[[UITextField alloc] init] valueForKeyPath:@"_placeholderLabel.textColor"];
    
    UILabel *receiveAddressLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kPlaceholderColor font:14.0];
    
    receiveAddressLbl.text = @"请选择付币地址或扫码录入";
    
    receiveAddressLbl.numberOfLines = 0;
    
    [receiveView addSubview:receiveAddressLbl];
    [receiveAddressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@90);
        make.right.equalTo(rightArrowIV.mas_left).offset(-10);
        make.centerY.equalTo(receiveView.mas_centerY);
        
    }];
    
    self.receiveAddressLbl = receiveAddressLbl;
    
    //
    UIButton *receiveBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, self.balanceTF.yy + 10, kScreenWidth, heightMargin)];
    
    [receiveBtn addTarget:self action:@selector(selectCoinAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:receiveBtn];
    
    //谷歌验证码
    self.googleAuthTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, receiveView.yy, kScreenWidth, heightMargin)
                                                 leftTitle:@"谷歌验证码"
                                                titleWidth:100
                                               placeholder:@"请输入谷歌验证码"];
    
    self.googleAuthTF.keyboardType = UIKeyboardTypeNumberPad;

    [self.view addSubview:self.googleAuthTF];
    
    //复制
    UIView *authView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 95, self.googleAuthTF.height)];
    
    UIButton *pasteBtn = [UIButton buttonWithTitle:@"粘贴" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:13.0 cornerRadius:5];
    
    pasteBtn.frame = CGRectMake(0, 0, 85, self.googleAuthTF.height - 15);
    
    pasteBtn.centerY = authView.height/2.0;
    
    [pasteBtn addTarget:self action:@selector(clickPaste) forControlEvents:UIControlEventTouchUpInside];
    
    [authView addSubview:pasteBtn];
    
    self.googleAuthTF.rightView = authView;
    
    //分割线
    UIView *googleLine = [[UIView alloc] init];
    
    googleLine.backgroundColor = kLineColor;
    
    [self.googleAuthTF addSubview:googleLine];
    [googleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    
    //转账数量
    self.tranAmountTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, receiveView.yy, kScreenWidth, heightMargin) leftTitle:@"转账数量" titleWidth:90 placeholder:@"请输入付币数量"];
    
    [self.tranAmountTF setValue:kPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    self.tranAmountTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self.tranAmountTF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.view addSubview:self.tranAmountTF];
    
    //矿工费
    self.minerFeeTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.tranAmountTF.yy + 10, kScreenWidth, heightMargin) leftTitle:@"手续费" titleWidth:90 placeholder:@""];
    
    self.minerFeeTF.enabled = NO;
    
    self.minerFeeTF.font = Font(14.0);
    
    self.minerFeeTF.text = [NSString stringWithFormat:@"0 %@", self.currency.currency];
    
    [self.view addSubview:self.minerFeeTF];
    [self.minerFeeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(self.tranAmountTF.mas_bottom).offset(10);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(heightMargin));
        
    }];
    
    //提示
    UIView *minerView = [[UIView alloc] init];
    
    minerView.backgroundColor = [UIColor colorWithHexString:@"#fdfdfd"];
    
    [self.view addSubview:minerView];
    [minerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.top.equalTo(self.minerFeeTF.mas_bottom);

    }];
    
    self.minerView = minerView;
    
    UILabel *minerPromptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:11.0];
    
    minerPromptLbl.text = @"手续费将在提币金额中扣除";
    
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
    
    //注意
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"注意")];
    
    [minerView addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(minerPromptLbl.mas_centerY);
        
    }];
    
    //内部转账
//    UIView *interalTranView = [[UIView alloc] init];
//
//    interalTranView.backgroundColor = kWhiteColor;
//
//    [self.view addSubview:interalTranView];
//    [interalTranView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.right.equalTo(@(0));
//        make.top.equalTo(minerView.mas_bottom).offset(10);
//        make.height.equalTo(@50);
//
//    }];
//    //
//    UILabel *tranTextLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
//
//    tranTextLbl.text = @"内部转账";
//
//    [interalTranView addSubview:tranTextLbl];
//    [tranTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(@15);
//        make.centerY.equalTo(interalTranView.mas_centerY);
//
//    }];
//
//    //开关
//    UISwitch *sw = [[UISwitch alloc] init];
//
//    sw.on = YES;
//
//    [interalTranView addSubview:sw];
//    [sw mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(@(-15));
//        make.centerY.equalTo(@0);
//
//    }];
//
//    self.sw = sw;
//
//    //内部转账提示
//    UIView *tranPromptView = [[UIView alloc] init];
//
//    tranPromptView.backgroundColor = [UIColor colorWithHexString:@"#fdfdfd"];
//
//    [self.view addSubview:tranPromptView];
//    [tranPromptView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.right.equalTo(@0);
//        make.top.equalTo(interalTranView.mas_bottom).offset(0);
//
//    }];
//
//    UILabel *tranPromptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:11.0];
//
//    tranPromptLbl.text = @"同意提币至bitbank进行托管, 0手续费0确认, 不走区块链接极速到账, bitbank.com";
//
//    tranPromptLbl.numberOfLines = 0;
//
//    [tranPromptView addSubview:tranPromptLbl];
//    [tranPromptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 15, 10, 15));
//
//        make.left.equalTo(tranPromptView.mas_left).offset(15);
//        make.centerY.equalTo(tranPromptView.mas_centerY);
//        make.right.equalTo(tranPromptView.mas_right).offset(-15);
//
//    }];
//
//    UIView *tranLine = [[UIView alloc] init];
//
//    tranLine.backgroundColor = kLineColor;
//
//    [tranPromptView addSubview:tranLine];
//    [tranLine mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.top.right.equalTo(@0);
//        make.height.equalTo(@0.5);
//
//    }];
    
    //确认付币
    UIButton *confirmPayBtn = [UIButton buttonWithTitle:@"确认付币" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:16.0 cornerRadius:5];

    [confirmPayBtn addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmPayBtn];
    [confirmPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(@(15));
        make.top.equalTo(minerView.mas_bottom).offset(30);
        make.right.equalTo(@(-15));
        make.height.equalTo(@45);

    }];
    
    self.confirmBtn = confirmPayBtn;
}

- (FilterView *)coinAddressPicker {
    
    if (!_coinAddressPicker) {
        
        CoinWeakSelf;
        
        NSArray *textArr = @[@"选择地址", @"扫描二维码", @"粘贴地址"];
        
        _coinAddressPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _coinAddressPicker.title = @"付币地址";
        
        _coinAddressPicker.selectBlock = ^(NSInteger index) {
            
            [weakSelf pickerEventWithIndex:index];
        };
        
        _coinAddressPicker.tagNames = textArr;
        
    }
    
    return _coinAddressPicker;
}

#pragma mark - Events
- (void)clickRecord:(UIButton *)sender {
    
    BillVC *billVC = [BillVC new];
    
    billVC.accountNumber = self.currency.accountNumber;
    
    billVC.billType = BillTypeWithdraw;

    [self.navigationController pushViewController:billVC animated:YES];
}

- (void)clickConfirm:(UIButton *)sender {

    [self.view endEditing:YES];
    
    if ([self.receiveAddressLbl.text isEqualToString:@"请选择付币地址或扫码录入"]) {
        
        [TLAlert alertWithInfo:@"请选择接收地址"];
        return ;
    }
    
    CGFloat amount = [self.tranAmountTF.text doubleValue];
    
    if (amount <= 0 || ![self.tranAmountTF.text valid]) {
        
        [TLAlert alertWithInfo:@"提币金额需大于0"];
        return ;
    }
    
    if ([TLUser user].isGoogleAuthOpen) {
        
        if (!(self.addressType == AddressTypeSelectAddress && [self.addressModel.status isEqualToString:@"1"])) {
            
            if (![self.googleAuthTF.text valid]) {
                
                [TLAlert alertWithInfo:@"请输入谷歌验证码"];
                return ;
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
            
        }
    }
    
    if (self.addressType == AddressTypeSelectAddress && [self.addressModel.status isEqualToString:@"1"]) {
        
        [self confirmWithdrawalsWithPwd:nil];
        
        return ;

    }
    
    [TLAlert alertWithTitle:@"请输入资金密码" msg:@"" confirmMsg:@"确定" cancleMsg:@"取消" placeHolder:@"请输入资金密码" maker:self cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action, UITextField *textField) {
        
        [self confirmWithdrawalsWithPwd:textField.text];
        
    }];

}

- (void)clickPaste {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    if (pasteboard.string != nil) {
        
        self.googleAuthTF.text = pasteboard.string;
        
    } else {
        
        [TLAlert alertWithInfo:@"粘贴内容为空"];
    }
}

- (void)textDidChange:(UITextField *)sender {
    
//    NSDecimalNumber *m = [NSDecimalNumber decimalNumberWithString:self.tranAmountTF.text];
//
//    NSDecimalNumber *n = [NSDecimalNumber decimalNumberWithString:self.withdrawFee];
//
//    NSDecimalNumber *o = [m decimalNumberByMultiplyingBy:n];
//
//    self.minerFeeTF.text = [NSString stringWithFormat:@"%@ %@", [o stringValue], self.currency.currency];
}

- (void)selectCoinAddress {
    
    [self.coinAddressPicker show];
}

- (void)pickerEventWithIndex:(NSInteger)index {
    
    CoinWeakSelf;
    
    switch (index) {
        //选择地址
        case 0:
        {
            [self.coinAddressPicker hide];
            
            CoinAddressListVC *addressVC = [CoinAddressListVC new];
            
            addressVC.addressBlock = ^(CoinAddressModel *addressModel) {

                weakSelf.addressModel = addressModel;
                
                weakSelf.receiveAddressLbl.text = weakSelf.addressModel.address;
                
                weakSelf.receiveAddressLbl.textColor = kTextColor;
                
                weakSelf.addressType = AddressTypeSelectAddress;
                
                [weakSelf setGoogleAuth];
            };
            
            [self.navigationController pushViewController:addressVC animated:YES];
            
        }break;
        //扫描二维码
        case 1:
        {
            QRCodeVC *qrCodeVC = [QRCodeVC new];
            
            qrCodeVC.scanSuccess = ^(NSString *result) {
                
                weakSelf.receiveAddressLbl.text = result;
                
                weakSelf.receiveAddressLbl.textColor = kTextColor;
                
                weakSelf.addressType = AddressTypeScan;

                [weakSelf setGoogleAuth];

            };
            
            [self.navigationController pushViewController:qrCodeVC animated:YES];
            
        }break;
        //粘贴地址
        case 2:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            
            if (pasteboard.string != nil) {
                
                self.receiveAddressLbl.text = pasteboard.string;
                
                self.receiveAddressLbl.textColor = kTextColor;
                
                self.addressType = AddressTypeCopy;
                
                [weakSelf setGoogleAuth];

            } else {
                
                [TLAlert alertWithInfo:@"粘贴内容为空"];
            }
            
        }break;
            
        default:
            break;
    }
}

- (void)setGoogleAuth {
    
    if (![TLUser user].isGoogleAuthOpen) {
        
        return ;
    }
    
    if ((self.addressType == AddressTypeSelectAddress && [self.addressModel.status isEqualToString:kAddressCertified])) {

        [UIView animateWithDuration:0 animations:^{
            
            self.googleAuthTF.transform = CGAffineTransformIdentity;

            self.minerFeeTF.transform = CGAffineTransformIdentity;
            
            self.minerView.transform = CGAffineTransformIdentity;
            
            self.confirmBtn.transform = CGAffineTransformIdentity;
            
        }];
        
    } else {
        
        [UIView animateWithDuration:0 animations:^{
            
            self.googleAuthTF.transform = CGAffineTransformMakeTranslation(0, 50);

            self.minerFeeTF.transform = CGAffineTransformMakeTranslation(0, 50);
            
            self.minerView.transform = CGAffineTransformMakeTranslation(0, 50);
            
            self.confirmBtn.transform = CGAffineTransformMakeTranslation(0, 50);
        }];
    }
}

#pragma mark - Data
- (void)confirmWithdrawalsWithPwd:(NSString *)pwd {
    
    if (!(self.addressType == AddressTypeSelectAddress && [self.addressModel.status isEqualToString:@"1"])) {
        
        if (![pwd valid]) {
            
            [TLAlert alertWithInfo:@"请输入资金密码"];
            return ;
        }
    }
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"802750";
    http.showView = self.view;
    http.parameters[@"accountNumber"] = self.currency.accountNumber;
    http.parameters[@"amount"] = [self.tranAmountTF.text convertToSysCoin];
//    http.parameters[@"applyNote"] = [NSString stringWithFormat:@"%@提现", self.currency.currency];
    http.parameters[@"applyNote"] = @"C端提现";
    http.parameters[@"applyUser"] = [TLUser user].userId;
    http.parameters[@"payCardInfo"] = self.currency.currency;
    http.parameters[@"payCardNo"] = self.receiveAddressLbl.text;
    
    if ([TLUser user].isGoogleAuthOpen) {
        
        if (!(self.addressType == AddressTypeSelectAddress && [self.addressModel.status isEqualToString:@"1"])) {
            
            http.parameters[@"googleCaptcha"] = self.googleAuthTF.text;
            
        }
    }
    
    if (!(self.addressType == AddressTypeSelectAddress && [self.addressModel.status isEqualToString:@"1"])) {
        
        http.parameters[@"tradePwd"] = pwd;

    }
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"提币申请提交成功"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kWithDrawCoinSuccess object:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        });
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)requestWithdrawFee {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_CKEY_CVALUE;
    http.parameters[@"key"] = @"withdraw_fee";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.withdrawFee = responseObject[@"data"][@"cvalue"];
        
        self.minerFeeTF.text = [NSString stringWithFormat:@"%@ %@", self.withdrawFee, self.currency.currency];

    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
