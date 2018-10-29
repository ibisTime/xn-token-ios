//
//  StorePayVC.m
//  OGC
//
//  Created by 蔡卓越 on 2018/3/14.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "StorePayVC.h"

//Manager
#import "CoinUtil.h"
//Macro
#import "APICodeMacro.h"
//Category
#import "UIBarButtonItem+convience.h"
#import "NSString+Check.h"
#import "UIViewController+BackButtonHander.h"
//M
#import "CurrencyModel.h"
#import "CoinAddressModel.h"
//V
#import "TLTextField.h"
#import "FilterView.h"
#import "TLAlert.h"
//C
#import "QRCodeVC.h"
#import "BillVC.h"
#import "TLCoinWithdrawOrderVC.h"

typedef NS_ENUM(NSInteger, AddressType) {
    
    AddressTypeSelectAddress = 0,       //选择地址
    AddressTypeScan,                    //扫码
    AddressTypeCopy,                    //复制粘贴
};

@interface StorePayVC ()

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
//账户
@property (nonatomic, strong) CurrencyModel *currency;

@end

@implementation StorePayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [LangSwitcher switchLang:@"确认支付" key:nil];
    //获取账户列表
    [self getMyCurrencyList];
}

- (BOOL)navigationShouldPopOnBackButton {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    return NO;
}

#pragma mark - Init

- (void)initSubviews {
    
    CGFloat heightMargin = 50;
    //余额
    self.balanceTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, heightMargin)
                                              leftTitle:[LangSwitcher switchLang:@"可用余额" key:nil]
                                             titleWidth:90
                                            placeholder:@""];
    
    self.balanceTF.textColor = kAppCustomMainColor;
    self.balanceTF.enabled = NO;
    
//    NSString *coinBalance = [CoinUtil convertToRealCoin:self.currency.coinBalance coin:self.currency.currency];
    NSString *leftAmount = [_currency.amountString subNumber:_currency.frozenAmountString];

    
    self.balanceTF.text = [NSString stringWithFormat:@"%@ %@",[CoinUtil convertToRealCoin:leftAmount coin:self.currency.currency] ,self.currency.currency];
    
    [self.view addSubview:self.balanceTF];
    
    //谷歌验证码
//    self.googleAuthTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.balanceTF.yy, kScreenWidth, heightMargin)
//                                                 leftTitle:[LangSwitcher switchLang:@"谷歌验证码" key:nil]
//                                                titleWidth:100
//                                               placeholder:[LangSwitcher switchLang:@"请输入谷歌验证码" key:nil] ];
//
//    self.googleAuthTF.keyboardType = UIKeyboardTypeNumberPad;
//
//    [self.view addSubview:self.googleAuthTF];
//
//    //复制
//    UIView *authView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 95, self.googleAuthTF.height)];
//
//    UIButton *pasteBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"粘贴" key:nil]
//                                        titleColor:kWhiteColor
//                                   backgroundColor:kThemeColor
//                                         titleFont:13.0
//                                      cornerRadius:5];
//
//    pasteBtn.frame = CGRectMake(0, 0, 85, self.googleAuthTF.height - 15);
//
//    pasteBtn.centerY = authView.height/2.0;
//
//    [pasteBtn addTarget:self action:@selector(clickPaste) forControlEvents:UIControlEventTouchUpInside];
//
//    [authView addSubview:pasteBtn];
//
//    self.googleAuthTF.rightView = authView;
    
//    //分割线
//    UIView *googleLine = [[UIView alloc] init];
//
//    googleLine.backgroundColor = kLineColor;
//
//    [self.googleAuthTF addSubview:googleLine];
//    [googleLine mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.top.right.equalTo(@0);
//        make.height.equalTo(@0.5);
//
//    }];
    
    //支付数量
    
    self.tranAmountTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.balanceTF.yy, kScreenWidth, heightMargin)
                                                 leftTitle:[LangSwitcher switchLang:@"支付数量" key:nil]
                                                titleWidth:90
                                               placeholder:[LangSwitcher switchLang:@"请填写数量" key:nil]
                         ];
    
    [self.tranAmountTF setValue:kPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    self.tranAmountTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    //    [self.tranAmountTF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.view addSubview:self.tranAmountTF];

//    //分割线
//    UIView *minerLine = [[UIView alloc] init];
//
//    minerLine.backgroundColor = kLineColor;
//
//    [self.view addSubview:minerLine];
//    [minerLine mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.top.right.equalTo(@0);
//        make.height.equalTo(@0.5);
//
//    }];
    
    //确认付币
    UIButton *confirmPayBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"确认支付" key:nil]
                                             titleColor:kWhiteColor
                                        backgroundColor:kAppCustomMainColor
                                              titleFont:16.0
                                           cornerRadius:5];
    
    [confirmPayBtn addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmPayBtn];
    [confirmPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.top.equalTo(self.tranAmountTF.mas_bottom).offset(30);
        make.right.equalTo(@(-15));
        make.height.equalTo(@45);
        
    }];
    
    self.confirmBtn = confirmPayBtn;
}

//- (FilterView *)coinAddressPicker {
//
//    if (!_coinAddressPicker) {
//
//        CoinWeakSelf;
//
//        NSArray *textArr = @[
//                             //                              [LangSwitcher switchLang:@"选择地址" key:nil],
//                             [LangSwitcher switchLang:@"扫描二维码" key:nil],
//                             [LangSwitcher switchLang:@"粘贴地址" key:nil]
//                             ];
//
//        _coinAddressPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//
//        _coinAddressPicker.title = [LangSwitcher switchLang:@"付币地址" key:nil];
//
//        _coinAddressPicker.selectBlock = ^(NSInteger index) {
//
//            [weakSelf pickerEventWithIndex:index];
//        };
//
//        _coinAddressPicker.tagNames = textArr;
//
//    }
//
//    return _coinAddressPicker;
//}

#pragma mark - 查看提现订单

- (void)clickConfirm:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
//    if ([self.receiveAddressLbl.text isEqualToString:@"请粘贴付币地址或扫码录入"]) {
//
//        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请选择接收地址" key:nil] ];
//        return ;
//    }
    
    CGFloat amount = [self.tranAmountTF.text doubleValue];
    
    if (amount <= 0 || ![self.tranAmountTF.text valid]) {
        
        [TLAlert alertWithInfo:@"支付金额需大于0"];
        return ;
    }
    
//    if ([TLUser user].isGoogleAuthOpen) {
//
//        if (!(self.addressType == AddressTypeSelectAddress && [self.addressModel.status isEqualToString:@"1"])) {
//
//            if (![self.googleAuthTF.text valid]) {
//
//                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入谷歌验证码" key:nil]];
//                return;
//
//            }
//
//            //判断谷歌验证码是否为纯数字
//            if (![NSString isPureNumWithString:self.googleAuthTF.text]) {
//
//                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的谷歌验证码" key:nil]];
//                return ;
//            }
//
//            //判断谷歌验证码是否为6位
//            if (self.googleAuthTF.text.length != 6) {
//
//                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的谷歌验证码" key:nil]];
//                return ;
//            }
//
//        }
//    }
    
//    if (self.addressType == AddressTypeSelectAddress && [self.addressModel.status isEqualToString:@"1"]) {
//
//        [self confirmWithdrawalsWithPwd:nil];
//
//        return ;
//
//    }
    
    [TLAlert alertWithTitle:[LangSwitcher switchLang:@"请输入资金密码" key:nil]
                        msg:@""
                 confirmMsg:[LangSwitcher switchLang:@"确定" key:nil]
                  cancleMsg:[LangSwitcher switchLang:@"取消" key:nil]
                placeHolder:[LangSwitcher switchLang:@"请输入资金密码" key:nil]
                      maker:self cancle:^(UIAlertAction *action) {
                          
                      } confirm:^(UIAlertAction *action, UITextField *textField) {
                          
                          [self confirmWithdrawalsWithPwd:textField.text];
                          
                      }];
    
}

//- (void)clickPaste {
//
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//
//    if (pasteboard.string != nil) {
//
//        self.googleAuthTF.text = pasteboard.string;
//
//    } else {
//
//        [TLAlert alertWithInfo:@"粘贴内容为空"];
//    }
//}

//- (void)textDidChange:(UITextField *)sender {

//    NSDecimalNumber *m = [NSDecimalNumber decimalNumberWithString:self.tranAmountTF.text];
//
//    NSDecimalNumber *n = [NSDecimalNumber decimalNumberWithString:self.withdrawFee];
//
//    NSDecimalNumber *o = [m decimalNumberByMultiplyingBy:n];
//
//    self.minerFeeTF.text = [NSString stringWithFormat:@"%@ %@", [o stringValue], self.currency.currency];
//}

- (void)selectCoinAddress {
    
    [self.coinAddressPicker show];
}

//- (void)pickerEventWithIndex:(NSInteger)index {
//
//    CoinWeakSelf;
//
//    switch (index) {
//
//        case 0:
//        {
//            QRCodeVC *qrCodeVC = [QRCodeVC new];
//
//            qrCodeVC.scanSuccess = ^(NSString *result) {
//
//                weakSelf.receiveAddressLbl.text = result;
//                weakSelf.receiveAddressLbl.textColor = kTextColor;
//                weakSelf.addressType = AddressTypeScan;
//                [weakSelf setGoogleAuth];
//
//            };
//
//            [self.navigationController pushViewController:qrCodeVC animated:YES];
//
//        }break;
//            //粘贴地址
//        case 1:
//        {
//            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//
//            if (pasteboard.string != nil) {
//
//                self.receiveAddressLbl.text = pasteboard.string;
//
//                self.receiveAddressLbl.textColor = kTextColor;
//
//                self.addressType = AddressTypeCopy;
//
//                [weakSelf setGoogleAuth];
//
//            } else {
//
//                [TLAlert alertWithInfo:@"粘贴内容为空"];
//            }
//
//        }break;
//
//        default:
//            break;
//    }
//}

//- (void)setGoogleAuth {
//
//    if (![TLUser user].isGoogleAuthOpen) {
//
//        return ;
//    }
//
//    if ((self.addressType == AddressTypeSelectAddress && [self.addressModel.status isEqualToString:kAddressCertified])) {
//
//        [UIView animateWithDuration:0 animations:^{
//
//            self.googleAuthTF.transform = CGAffineTransformIdentity;
//            self.minerFeeTF.transform = CGAffineTransformIdentity;
//            self.minerView.transform = CGAffineTransformIdentity;
//            self.confirmBtn.transform = CGAffineTransformIdentity;
//
//        }];
//
//    } else {
//
//        [UIView animateWithDuration:0 animations:^{
//
//            self.googleAuthTF.transform = CGAffineTransformMakeTranslation(0, 50);
//            self.minerFeeTF.transform = CGAffineTransformMakeTranslation(0, 50);
//            self.minerView.transform = CGAffineTransformMakeTranslation(0, 50);
//            self.confirmBtn.transform = CGAffineTransformMakeTranslation(0, 50);
//
//        }];
//    }
//}

#pragma mark - Data
- (void)getMyCurrencyList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"802503";
    helper.showView = self.view;
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"currency"] = kOGC;
    helper.isList = YES;
    helper.isCurrency = YES;
    [helper modelClass:[CurrencyModel class]];
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        //去除没有的币种
        NSMutableArray <CurrencyModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
        
        [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CurrencyModel *currencyModel = (CurrencyModel *)obj;
            if ([[CoinUtil shouldDisplayCoinArray] indexOfObject:currencyModel.currency ] != NSNotFound ) {
                
                [shouldDisplayCoins addObject:currencyModel];
            }
        }];
        
        if (shouldDisplayCoins.count > 0) {
            //
            weakSelf.currency = shouldDisplayCoins[0];
            
            [weakSelf initSubviews];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)confirmWithdrawalsWithPwd:(NSString *)pwd {
    
    if (!(self.addressType == AddressTypeSelectAddress && [self.addressModel.status isEqualToString:@"1"])) {
        
        if (![pwd valid]) {
            
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入资金密码" key:nil]];
            return ;
        }
    }
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625340";
    http.showView = self.view;
    http.parameters[@"toStore"] = self.code;
    http.parameters[@"currency"] = self.currency.currency;
    http.parameters[@"transAmount"] = [CoinUtil convertToSysCoin:self.tranAmountTF.text
                                                       coin:self.currency.currency];
    http.parameters[@"tradePwd"] = pwd;
    http.parameters[@"token"] = [TLUser user].token;
//
//    http.parameters[@"applyNote"] = [NSString stringWithFormat:@"%@%@", self.currency.currency, [LangSwitcher switchLang:@"支付" key:nil]];
//    http.parameters[@"applyUser"] = [TLUser user].userId;
//    http.parameters[@"payCardInfo"] = self.currency.currency;
//    http.parameters[@"payCardNo"] = self.receiveAddressLbl.text;
    
    
//    if ([TLUser user].isGoogleAuthOpen) {
//
//        if (!(self.addressType == AddressTypeSelectAddress && [self.addressModel.status isEqualToString:@"1"])) {
//
//            http.parameters[@"googleCaptcha"] = self.googleAuthTF.text;
//
//        }
//    }
    
//    if (!(self.addressType == AddressTypeSelectAddress && [self.addressModel.status isEqualToString:@"1"])) {
//
//        http.parameters[@"tradePwd"] = pwd;
//
//    }
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"支付成功" key:nil]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kWithDrawCoinSuccess object:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        });
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark- 获取手续费
//- (void)requestWithdrawFee {
//
//    TLNetworking *http = [TLNetworking new];
//
//    http.code = USER_CKEY_CVALUE;
//    http.parameters[SYS_KEY] = [NSString stringWithFormat:@"withdraw_fee_%@",[self.currency.currency lowercaseString]];
//
//    [http postWithSuccess:^(id responseObject) {
//
//        self.withdrawFee = responseObject[@"data"][@"cvalue"];
//
//        self.minerFeeTF.text = [NSString stringWithFormat:@"%@ %@", self.withdrawFee, self.currency.currency];
//
//    } failure:^(NSError *error) {
//
//
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
