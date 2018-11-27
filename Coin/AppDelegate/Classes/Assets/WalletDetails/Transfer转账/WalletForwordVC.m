//
//  WalletForwordVC.m
//  Coin
//
//  Created by shaojianfei on 2018/6/11.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "WalletForwordVC.h"
#import "UIBarButtonItem+convience.h"
#import "TLAlert.h"
#import "NSString+Check.h"
#import "UIViewController+BackButtonHander.h"
#import "APICodeMacro.h"

#import "BillVC.h"
#import "TLCoinWithdrawOrderVC.h"
#import "TLTextField.h"
#import "FilterView.h"
#import "QRCodeVC.h"
#import "MnemonicUtil.h"
#import "MnemonicUtil.h"
#import "utxoModel.h"
#import "BTCBlockchainInfo.h"
#import "BTCTransactionOutput.h"
#import "BTCData.h"
#import "BTCKey.h"
#import "BTCScript.h"
#import "BTCScriptMachine.h"
#import "BTCAddress.h"
#import "BTCChainCom.h"
#import "BTCTransaction.h"
#import "BTCTransactionInput.h"
#import "BTCNetwork.h"
#import "BTCKeychain.h"
#import "BTCHashID.h"
#import "BTCPoundage.h"
#import "CoinAddressModel.h"
#import "UsdtClient.h"

typedef NS_ENUM(NSInteger, WalletAddressType) {

    WalletAddressTypeSelectAddress = 0,       //选择地址
    WalletAddressTypeScan,                    //扫码
    WalletAddressTypeCopy,                    //复制粘贴
};
typedef enum : NSUInteger {
    BTCAPIChain,
    BTCAPIBlockchain,
} BTCAPI;
@interface WalletForwordVC ()<UITextFieldDelegate>
{
    BOOL isHaveDian;
    NSString *symbolblance;
}
//可用余额
@property (nonatomic, strong) TLTextField *balanceTF;
//接收地址
@property (nonatomic, strong) UILabel *receiveAddressLbl;
//选择
@property (nonatomic, strong) FilterView *coinAddressPicker;

//矿工费
//@property (nonatomic, strong) FilterView *WorkMoneyPicker;

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
@property (nonatomic, assign) WalletAddressType addressType;
//地址
@property (nonatomic, strong) CoinAddressModel *addressModel;

@property (nonatomic, strong) UILabel *choseLab;
//矿工费

@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) UILabel * blanceFree;

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, copy) NSString *word;
@property (nonatomic, strong) UILabel *symbolBlance;
@property (nonatomic, assign) CGFloat gamPrice;
@property (nonatomic, copy) NSString *tempPrice;

@property (nonatomic, copy) NSString *pricr;
@property (nonatomic, copy) NSString *btcAddress;

@property (nonatomic, copy) NSString *btcPrivate;
@property (nonatomic, strong) NSMutableArray <utxoModel *>*utxis;

@property (nonatomic, copy) NSString *signTx;

@property (nonatomic, copy) NSString *priceSlow ;
@property (nonatomic, copy) NSString *priceFast;
@property (nonatomic, assign)CGFloat btcPrice;

@property (nonatomic, strong) BTCKey *key;

@property (nonatomic , strong)NSString *btcPrompt;

@end

@implementation WalletForwordVC


- (void)initSubviews {
    
    UIView *top = [[UIView alloc] init];
    [self.view addSubview:top];
    top.backgroundColor = kHexColor(@"#0848DF");
    
    [top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(45));
    }];
    
    UIImageView *bgImage = [[UIImageView alloc] init];
    
    self.bgImage = bgImage;
    bgImage.image = kImage(@"提背景");
    bgImage.contentMode = UIViewContentModeScaleToFill;
    bgImage.layer.cornerRadius=5;
    bgImage.layer.shadowOpacity = 0.22;// 阴影透明度
    bgImage.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    bgImage.layer.shadowRadius=3;// 阴影扩散的范围控制
    bgImage.layer.shadowOffset=CGSizeMake(1, 1);// 阴影的范围
    [self.view addSubview:bgImage];
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@90);
        
    }];
    
    UILabel *blance = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12];
    blance.text = [LangSwitcher switchLang:@"可用余额" key:nil];
    [bgImage addSubview:blance];
    [blance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImage.mas_top).offset(20);
        make.centerX.equalTo(bgImage.mas_centerX);
        
    }];
    UILabel *symbolBlance = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:24];
    [bgImage addSubview:symbolBlance];
    
    
    
    //余额
    symbolBlance.text = [NSString stringWithFormat:@"%.8f%@ ",[[CoinUtil convertToRealCoin:_currency.balance coin:_currency.symbol] floatValue],_currency.symbol];
    symbolblance = [CoinUtil convertToRealCoin:_currency.balance coin:_currency.symbol];
    
    self.symbolBlance = symbolBlance;
    [symbolBlance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blance.mas_bottom).offset(5);
        make.centerX.equalTo(bgImage.mas_centerX);
    }];
    
    CGFloat heightMargin = 50;
    //余额
    self.balanceTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, kHeight(103), kScreenWidth-30, heightMargin+20)
                                              leftTitle:[LangSwitcher switchLang:@"接收地址" key:nil]
                                             titleWidth:80
                                            placeholder:[LangSwitcher switchLang:@"请输入付币地址或扫码" key:nil]];
    
    self.balanceTF.textColor = kHexColor(@"#109ee9");
    if (kDevice_Is_iPhoneX) {
        self.balanceTF.font =FONT(11);
        
    }else{
        
        self.balanceTF.font =FONT(10);
        
    }
    [self.view addSubview:self.balanceTF];
    
    
    //更多
    UIImageView *rightArrowIV = [[UIImageView alloc] initWithImage:kImage(@"扫一扫-黑色")];
    rightArrowIV.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:rightArrowIV];
    rightArrowIV.userInteractionEnabled = YES;
    [rightArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.centerY.equalTo(self.balanceTF.mas_centerY);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
        
    }];
    
    UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [rightArrowIV addGestureRecognizer:ta];
    
    
    //谷歌验证码
    self.googleAuthTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.balanceTF.yy, kScreenWidth, heightMargin)
                                                 leftTitle:[LangSwitcher switchLang:@"谷歌验证码" key:nil]
                                                titleWidth:100
                                               placeholder:[LangSwitcher switchLang:@"请输入谷歌验证码" key:nil] ];
    
    self.googleAuthTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.view addSubview:self.googleAuthTF];
    
    //复制
    UIView *authView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 95, self.googleAuthTF.height)];
    
    UIButton *pasteBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"粘贴" key:nil]
                                        titleColor:kWhiteColor
                                   backgroundColor:kAppCustomMainColor
                                         titleFont:13.0
                                      cornerRadius:5];
    
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
    self.tranAmountTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.balanceTF.yy, kScreenWidth, heightMargin)
                                                 leftTitle:[LangSwitcher switchLang:@"转账数量" key:nil]
                                                titleWidth:80
                                               placeholder:[LangSwitcher switchLang:@"请填写付币数量" key:nil]
                         ];
    self.tranAmountTF.isSecurity = YES;
    self.tranAmountTF.delegate = self;
    [self.tranAmountTF setValue:kPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    self.tranAmountTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self.tranAmountTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.view addSubview:self.tranAmountTF];
    
    //矿工费
    self.minerFeeTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.tranAmountTF.yy + 10, kScreenWidth-30, heightMargin)
                                               leftTitle:[LangSwitcher switchLang:@"矿工费" key:nil]
                                              titleWidth:80
                                             placeholder:nil];
    
    self.minerFeeTF.enabled = NO;
    self.minerFeeTF.backgroundColor = [UIColor colorWithHexString:@"#fdfdfd"];
    
    self.minerFeeTF.font = [UIFont systemFontOfSize:11];
    
    UILabel *free = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:12];
    free.frame = CGRectMake(80, self.tranAmountTF.yy + 10, kScreenWidth-100, heightMargin);
    free.text = [LangSwitcher switchLang:@"矿工费将在可用余额中扣除" key:nil];
    free.numberOfLines = 0;
    //    [LangSwitcher switchLang:@"矿工费将在可用余额中扣除，余额不足将从转账金额中扣除"];
    [self.view addSubview:self.minerFeeTF];
    
    [self.view addSubview:free];
    [self.minerFeeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(self.tranAmountTF.mas_bottom).offset(10);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(heightMargin));
        
    }];
    
    UISlider *slider = [UISlider new];
    self.slider = slider;
    [self.view addSubview:slider];
    slider.maximumValue = 1.0;
    slider.minimumValue = 0;
    slider.thumbTintColor = kHexColor(@"#1B61F0");
    slider.minimumTrackTintColor = kHexColor(@"#1B61F0");
    slider.maximumTrackTintColor = kHexColor(@"#DDE6F9");
    slider.value = 0.5;
    [slider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(self.minerFeeTF.mas_bottom).offset(30);
        make.width.equalTo(@(kScreenWidth-30));
        make.height.equalTo(@(20));
    }];
    
    UILabel * solw = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#AAAAAA") font:12];
    solw.text = [LangSwitcher switchLang:@"慢" key:nil];
    UILabel * fast = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#AAAAAA") font:12];
    fast.text = [LangSwitcher switchLang:@"快" key:nil];
    UILabel * blanceFree = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
    self.blanceFree = blanceFree;
    blanceFree.text = [LangSwitcher switchLang:@"" key:nil];
    
    [self.view addSubview:solw];
    [self.view addSubview:blanceFree];
    
    [self.view addSubview:fast];
    
    [solw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(slider.mas_bottom).offset(20);
        
        
    }];
    [fast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.top.equalTo(slider.mas_bottom).offset(20);
        
        
    }];
    
    [blanceFree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(slider.mas_bottom).offset(20);
    }];
    
    //确认付币
    UIButton *confirmPayBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"确认转账" key:nil]
                                             titleColor:kWhiteColor
                                        backgroundColor:kHexColor(@"#108ee9")
                                              titleFont:16.0
                                           cornerRadius:5];
    
    [confirmPayBtn addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmPayBtn];
    [confirmPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.top.equalTo(self.minerFeeTF.mas_bottom).offset(150);
        make.right.equalTo(@(-15));
        make.height.equalTo(@45);
        
    }];
    self.confirmBtn = confirmPayBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"转账" key:nil];
    self.view.backgroundColor = kWhiteColor;
    //
    [self initSubviews];
    [self loadPwd];
    //矿工费
}

- (void)loadPwd{

//    TLDataBase *dataBase = [TLDataBase sharedManager];
//    //    NSString *word;
//    if ([dataBase.dataBase open]) {
//        NSString *sql = [NSString stringWithFormat:@"SELECT PwdKey from THAUser where userId = '%@'",[TLUser user].userId];
//        //        [sql appendString:[TLUser user].userId];
//        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
//        while ([set next])
//        {
//            self.word = [set stringForColumn:@"PwdKey"];
//
//        }
//        [set close];
//    }
//    [dataBase.dataBase close];
    
    self.word = [[NSUserDefaults standardUserDefaults] objectForKey:MNEMONICPASSWORD];

}

- (void)viewDidAppear:(BOOL)animated
{
    // 获取币type
    [self loadtype];
    //获取矿工费
    [self getgamProce];
    [super viewDidAppear:animated];
}

-(void)loadtype
{
//    TLDataBase *dataBase = [TLDataBase sharedManager];
//    NSString *type;
//
//    if ([dataBase.dataBase open]) {
//        NSString *sql = [NSString stringWithFormat:@"SELECT type from THALocal where symbol = '%@'",self.currency.symbol];
//        //        [sql appendString:[TLUser user].userId];
//        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
//        while ([set next])
//        {
//            type = [set stringForColumn:@"type"];
//
//        }
//        [set close];
//    }
//    [dataBase.dataBase close];
    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:COINARRAY];
    for (int i = 0; i < array.count; i ++) {
        if ([array[i][@"symbol"] isEqualToString:self.currency.symbol]) {
            self.currency.type = array[i][@"type"];
        }
    }
    
}

#pragma mark -- //获取 BTCUTXO
- (void)loadUtxoList
{
//    TLDataBase *dataBase = [TLDataBase sharedManager];
//    NSString *btcaddress;
//    NSString *btcprivate;
//
//    if ([dataBase.dataBase open]) {
//        NSString *sql = [NSString stringWithFormat:@"SELECT btcaddress,btcprivate from THAUser where userId = '%@'",[TLUser user].userId];
//        //        [sql appendString:[TLUser user].userId];
//        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
//        while ([set next])
//        {
//            btcaddress = [set stringForColumn:@"btcaddress"];
//            btcprivate = [set stringForColumn:@"btcprivate"];
//        }
//        [set close];
//    }
//    [dataBase.dataBase close];
//
//    self.btcAddress = btcaddress;
//    self.btcPrivate = btcprivate;

    TLNetworking *net = [TLNetworking new];
    net.code = @"802220";
    net.showView = self.view;
    net.parameters[@"address"] = self.currency.address;

    [net postWithSuccess:^(id responseObject) {
        
        self.utxis = [utxoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"utxoList"]];
        [self BTCpoundage];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);

        //        [self.tableView endRefreshHeader];
    }];
}
#pragma mark -- 获取btc手续费
-(void)BTCpoundage
{
    //
    TLNetworking *net = [TLNetworking new];
    
    net.showView = self.view;
    net.code = @"802223";
    [net postWithSuccess:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSNumber *slow = responseObject[@"data"][@"fastestFeeMin"];
        NSNumber *fast = responseObject[@"data"][@"fastestFeeMax"];
        
        int f = ([fast intValue] - [slow intValue])/2;
        f = f + [slow intValue];
        
        NSString *priceSlow = [NSString stringWithFormat:@"%@",slow];
        NSString *priceFast = [NSString stringWithFormat:@"%@",fast];
        
        self.priceSlow = priceSlow;
        self.priceFast = priceFast;
        
        self.slider.maximumValue = [self.priceFast floatValue];
        self.slider.minimumValue = [self.priceSlow floatValue];
        self.slider.value = ([self.priceFast floatValue] + [self.priceSlow floatValue])/2;
        
        NSString *price = [NSString stringWithFormat:@"%d",f];
        self.btcPrice = ([self.priceFast floatValue] + [self.priceSlow floatValue])/2;
        NSLog(@"%@low@,fast%@",priceSlow,priceFast);
        self.gamPrice = [price floatValue ] ;
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self valueChange:self.slider];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}



- (void)getgamProce
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __block  NSString *pricr;
        if ([self.currency.type isEqualToString:@"0"]) {

            if ([self.currency.symbol isEqualToString:@"BTC"] || [self.currency.symbol isEqualToString:@"USDT"]) {
                [self loadUtxoList];
            }
            else if ([self.currency.symbol isEqualToString:@"WAN"]) {
                //                    pricr = [MnemonicUtil getWanGasPrice];

                TLNetworking *net =[TLNetworking new];
                net.code = @"802358";
                net.showView = self.view;
                [net postWithSuccess:^(id responseObject) {
                    
                    pricr   = responseObject[@"data"][@"gasPrice"];
                    self.pricr = pricr;
                    self.tempPrice = pricr;

                    CGFloat p = [pricr doubleValue]/1000000000000000000;
                    p = p *21000;
                    NSLog(@"%.8f",p);
                    self.gamPrice = p;
                    [self valueChange:self.slider];

                } failure:^(NSError *error) {

                }];

            }else
            {
                //                    pricr = [MnemonicUtil getGasPrice];
                TLNetworking *net =[TLNetworking new];
                net.showView = self.view;
                net.code = @"802117";
                [net postWithSuccess:^(id responseObject) {
                    pricr  = responseObject[@"data"][@"gasPrice"];

                    self.pricr = pricr;
                    self.tempPrice = pricr;

                    CGFloat p = [pricr doubleValue]/1000000000000000000;
                    p = p *21000;
                    NSLog(@"%.8f",p);
                    self.gamPrice = p;
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                    [self valueChange:self.slider];
                } failure:^(NSError *error) {

                }];
            }

        }else{

            TLNetworking *net =[TLNetworking new];
            net.showView = self.view;
            net.code = @"802117";
            [net postWithSuccess:^(id responseObject) {
                pricr   = responseObject[@"data"][@"gasPrice"];
                self.tempPrice = pricr;

                self.pricr = pricr;
                CGFloat p = [pricr doubleValue]/1000000000000000000;
                p = p *21000;
                NSLog(@"%.8f",p);
                self.gamPrice = p;
                [self valueChange:self.slider];
            } failure:^(NSError *error) {

            }];
        }


//    });


}


- (void)textFieldDidChange:(UITextField *)textField{
    if ([self.currency.symbol isEqualToString:@"BTC"]) {
        self.blanceFree.text = [NSString stringWithFormat:@"%@sat/b(≈%.8fBTC)",[NSString stringWithFormat:@"%.1f",self.slider.value],[BTCPoundage enterTheumber:textField.text setFee:[NSString stringWithFormat:@"%.1f",self.slider.value] setUtxis:self.utxis]/100000000];
    }
    if ([self.currency.symbol isEqualToString:@"USDT"]) {
        self.blanceFree.text = [NSString stringWithFormat:@"%@sat/b(≈%.8fBTC)",[NSString stringWithFormat:@"%.1f",self.slider.value],[BTCPoundage usdtPoundage:textField.text setFee:[NSString stringWithFormat:@"%.1f",self.slider.value] setUtxis:self.utxis]/100000000];
    }
}

- (void)valueChange:(id)sender
{
    if ([sender isKindOfClass:[UISlider class]]) {
        UISlider * slider = sender;
        CGFloat value = slider.value;
        if ([self.currency.symbol isEqualToString:@"BTC"]) {
            self.blanceFree.text = [NSString stringWithFormat:@"%@sat/b(≈%.8fBTC)",[NSString stringWithFormat:@"%.1f",slider.value],[BTCPoundage enterTheumber:self.tranAmountTF.text setFee:[NSString stringWithFormat:@"%.1f",slider.value] setUtxis:self.utxis]/100000000];
            
            self.btcPrice = slider.value;
            return;
        }
        if ([self.currency.symbol isEqualToString:@"USDT"]) {
            self.blanceFree.text = [NSString stringWithFormat:@"%@sat/b(≈%.8fBTC)",[NSString stringWithFormat:@"%.1f",self.slider.value],[BTCPoundage usdtPoundage:self.tranAmountTF.text setFee:[NSString stringWithFormat:@"%.1f",self.slider.value] setUtxis:self.utxis]/100000000];
            return;
        }
        
        
        NSString *symbolStr;
        if ([self.currency.type isEqualToString:@"0"]) {
            symbolStr = self.currency.symbol;
        }else if ([self.currency.type isEqualToString:@"1"])
        {
            symbolStr = @"ETH";
        }else{
            symbolStr = @"WAN";
        }
        if (value > 0.5) {
            
            self.blanceFree.text = [NSString stringWithFormat:@"%.8f %@",self.gamPrice + self.gamPrice*(slider.value - 0.5),symbolStr];
            self.pricr = [NSString stringWithFormat:@"%.8f",[self.tempPrice longLongValue] + [self.tempPrice longLongValue]*(slider.value - 0.5)];
            
        }else{

            self.blanceFree.text = [NSString stringWithFormat:@"%.8f %@", self.gamPrice  - self.gamPrice* ( - slider.value + 0.5),symbolStr];

            self.pricr = [NSString stringWithFormat:@"%.8f",[self.tempPrice longLongValue] - [self.tempPrice longLongValue] * ( - slider.value + 0.5)];
        }

    }
}

- (FilterView *)coinAddressPicker {

    if (!_coinAddressPicker) {

        CoinWeakSelf;

        NSArray *textArr = @[
                             //                              [LangSwitcher switchLang:@"选择地址" key:nil],
                             [LangSwitcher switchLang:@"扫描二维码" key:nil],
                             [LangSwitcher switchLang:@"粘贴地址" key:nil]
                             ];

        _coinAddressPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];

        _coinAddressPicker.title = [LangSwitcher switchLang:@"接收地址" key:nil];

        _coinAddressPicker.selectBlock = ^(NSInteger index) {

            [weakSelf pickerEventWithIndex:index];
        };
        _coinAddressPicker.tagNames = textArr;

    }

    return _coinAddressPicker;
}


#pragma mark - 查看提现订单
- (void)clickRecord:(UIButton *)sender {
    
    TLCoinWithdrawOrderVC *withdrawOrderVC = [[TLCoinWithdrawOrderVC alloc] init];
    withdrawOrderVC.coin = self.currency.currency;
    [self.navigationController pushViewController:withdrawOrderVC animated:YES];

}

-(void)click
{
    QRCodeVC *qrCodeVC = [QRCodeVC new];
    CoinWeakSelf;
    qrCodeVC.scanSuccess = ^(NSString *result) {

        weakSelf.balanceTF.text = result;
        weakSelf.addressType = WalletAddressTypeScan;

    };

    [self.navigationController pushViewController:qrCodeVC animated:YES];

}

- (void)clickConfirm:(UIButton *)sender {

    [self.view endEditing:YES];

    if ([self.balanceTF.text isBlank]) {

        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入地址" key:nil] ];
        return ;
    }

    if ([self.currency.type isEqualToString:@"0"]) {
        if ([self.currency.symbol isEqualToString:@"BTC"] || [self.currency.symbol isEqualToString:@"USDT"]) {
            self.btcPrompt = @"";
            
            
            if ([self.balanceTF.text isEqualToString:self.btcAddress]) {
                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"转入和转出地址不能相同" key:nil]];

                return;
            }
            if ([self.tranAmountTF.text floatValue] >= [symbolblance floatValue]) {
                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"余额不足" key:nil]];
                return;
            }


            if ([AppConfig config].runEnv == 0) {
                BTCPublicKeyAddress *ADDRESS = [BTCPublicKeyAddress addressWithString:self.balanceTF.text];
                if (ADDRESS == nil) {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确地址" key:nil]];
                    return;
                }
            }
            else
            {
                BTCPublicKeyAddress *ADDRESS = [BTCPublicKeyAddressTestnet addressWithString:self.balanceTF.text];
                if (ADDRESS == nil) {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确地址" key:nil]];
                    return;
                }
            }
        }
    }
    CGFloat amount = [self.tranAmountTF.text doubleValue];

    if (amount <= 0 || [self.tranAmountTF.text isBlank]) {

        [TLAlert alertWithInfo:@"转账金额需大于0"];
        return ;
    }
    //      去除字符串空格
    self.balanceTF.text = [self.balanceTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];

//    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *Mnemonics = [[NSUserDefaults standardUserDefaults]objectForKey:MNEMONIC];
//    if ([dataBase.dataBase open]) {
//        NSString *sql = [NSString stringWithFormat:@"SELECT Mnemonics from THAUser where userId = '%@'",[TLUser user].userId];
//        //        [sql appendString:[TLUser user].userId];
//        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
//        while ([set next])
//        {
//            Mnemonics = [set stringForColumn:@"Mnemonics"];
//        }
//
//        [set close];
//    }
//    [dataBase.dataBase close];

    //
    CGFloat f =  [self.tranAmountTF.text floatValue];
    f = f *1000000000000000000;
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"线程1--->%d",[NSThread isMainThread]);


    NSString *gaspic =  [CoinUtil convertToSysCoin:self.tranAmountTF.text coin:self.currency.symbol];
    ;

    [TLAlert alertWithTitle:[LangSwitcher switchLang:@"请输入交易密码" key:nil]
                        msg:@""
                 confirmMsg:[LangSwitcher switchLang:@"确定" key:nil]
                  cancleMsg:[LangSwitcher switchLang:@"取消" key:nil]
                placeHolder:[LangSwitcher switchLang:@"请输入交易密码" key:nil]
                      maker:self cancle:^(UIAlertAction *action) {

                          return ;
                      } confirm:^(UIAlertAction *action, UITextField *textField)
    {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
          [SVProgressHUD show];
//        dispatch_after(0.5, dispatch_get_main_queue(), ^{
            if ([self.word isEqualToString:textField.text]) {
                NSString *result;
                NSLog(@"线程2--->%d",[NSThread isMainThread]);
                [SVProgressHUD show];
                
                
                if ([self.currency.type isEqualToString:@"0"]) {
                    //公链 ETH WAN BTC
                    if ([self.currency.symbol isEqualToString:@"ETH"]) {
                        
                        result =[MnemonicUtil sendTransactionWithMnemonicWallet:Mnemonics address:[self.balanceTF.text lowercaseString] amount:gaspic gaspic:[NSString stringWithFormat:@"%lld",[self.pricr longLongValue]] gasLimt:@"21000"];
                        
                        if ([result isEqualToString:@"请输入正确地址"]) {
                            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确地址" key:nil]];
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            return;
                        }
                        
                        
                    }else if ([self.currency.symbol isEqualToString:@"WAN"]){
                        
                        result =[MnemonicUtil sendWanTransactionWithMnemonicWallet:Mnemonics address:[self.balanceTF.text lowercaseString] amount:gaspic gaspic:[NSString stringWithFormat:@"%lld",[self.pricr longLongValue]] gasLimt:@"21000"];
                        if ([result isEqualToString:@"请输入正确地址"]) {
                            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确地址" key:nil]];
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            return;
                        }
                    }else if ([self.currency.symbol isEqualToString:@"BTC"]){
                        [self testSpendCoins:self.balanceTF.text :self.tranAmountTF.text :[NSString stringWithFormat:@"%.1f",self.btcPrice]];
                        return ;
                    }else if ([self.currency.symbol isEqualToString:@"USDT"])
                    {
                        
                        [self utxoTransfer];
                        return;
                    }
                }else{
                    
                    
                    CoinModel *coin = [CoinUtil getCoinModel:self.currency.symbol];
                    
                    
                    result = [MnemonicUtil sendEthTokenTransactionWithAddress:Mnemonics contractAddress:coin.contractAddress address:[self.balanceTF.text lowercaseString] amount:self.tranAmountTF.text gaspic:self.pricr gasLimt:@"210000"];
                    if ([result isEqualToString:@"请输入正确地址"]) {
                        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确地址" key:nil]];
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        return;
                    }
                    
                    
                }
                if ([result isEqualToString:@"1"]) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [TLAlert alertWithSucces:[LangSwitcher switchLang:@"广播成功" key:nil]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                }else
                {
                    NSLog(@"线程3--->%d",[NSThread isMainThread]);
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [TLAlert alertWithError:[LangSwitcher switchLang:@"广播失败" key:nil]];
                    
                }
            }else{
                [TLAlert alertWithError:[LangSwitcher switchLang:@"交易密码错误" key:nil]];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }
//        });
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


- (void)selectCoinAddress {

    [self.coinAddressPicker show];
}

//- (void)clickImage
//{
//    [self.WorkMoneyPicker show];
//
//}


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
                weakSelf.addressType = WalletAddressTypeScan;
                //                [weakSelf setGoogleAuth];

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

                self.addressType = WalletAddressTypeCopy;

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

    if ((self.addressType == WalletAddressTypeSelectAddress && [self.addressModel.status isEqualToString:kAddressCertified])) {

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


#pragma mark- 获取手续费
- (void)setWithdrawFee {

    CoinModel *currentCoin = [CoinUtil getCoinModel:self.currency.currency];
    self.withdrawFee = currentCoin.withdrawFeeString;
    self.blanceFree.text = [NSString stringWithFormat:@"%@ %@", [CoinUtil convertToRealCoin:self.withdrawFee coin:self.currency.currency], self.currency.currency];

}


#pragma mark -- btc转账
- (void) testSpendCoins:(NSString *)to : (NSString*)count :(NSString*)free {
    // For safety I'm not putting a private key in the source code, but copy-paste here from Keychain on each run.为了安全起见，我没有在源代码中放入私钥，而是在每次运行时从Keychain复制粘贴过来。
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *word;
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT Mnemonics from THAUser where userId = '%@'",[TLUser user].userId];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            word = [set stringForColumn:@"Mnemonics"];
            
        }
        [set close];
    }
    [dataBase.dataBase close];
    //    [self queryTotalAmount];
    
    
    NSArray *words = [word componentsSeparatedByString:@" "];
    
    BTCMnemonic *mnemonic =  [MnemonicUtil importMnemonic:words];
    BTCKeychain *keychain = [mnemonic keychain];
    
    if ([AppConfig config].runEnv == 0) {
        
        if (![_currency.address isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:BTCADDRESS]]) {
            keychain = [keychain derivedKeychainWithPath:@"m/44'/0'/0'/0/0"];
        }
        
        keychain.network = [BTCNetwork mainnet];
        
    }else{
        if (![_currency.address isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:BTCADDRESS]]) {
            keychain = [keychain derivedKeychainWithPath:@"m/44'/1'/0'/0/0"];
        }
        
        keychain.network = [BTCNetwork testnet];
        
    }
    BTCKey *key = keychain.key;
    self.key = key;
    NSData* privateKey = BTCDataFromHex(self.btcPrivate);
    NSLog(@"Private key: %@", privateKey);
    
    NSLog(@"Address: %@", key.privateKeyAddressTestnet);
    self.btcPrompt = @"";
    
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSError* error = nil;
    BTCTransaction* transaction;
    if ([AppConfig config].runEnv == 0) {
        transaction = [self transactionSpendingFromPrivateKey:privateKey
                                                           to:[BTCPublicKeyAddress addressWithString:to]
                                                       change:key.address // send change to the same address
                                                       amount:count
                                                          fee:free
                                                          api:0
                                                        error:&error];
    }else{
        transaction = [self transactionSpendingFromPrivateKey:privateKey
                                                           to:[BTCPublicKeyAddressTestnet addressWithString:to]
                                                       change:key.addressTestnet // send change to the same address
                                                       amount:count
                                                          fee:free
                                                          api:0
                                                        error:&error];
    }
    
    
    if (!transaction) {
        NSLog(@"Can't make a transaction: %@", error);
    }
    
    if (![self.btcPrompt isEqualToString:@""]) {
        [TLAlert alertWithInfo:self.btcPrompt];
        return;
    }
    
    //    if ([TLUser isBlankString:transaction] == YES) {
    //        return;
    //    }
    self.signTx = BTCHexFromData([transaction data]);
    [self validationSignTx:self.signTx];
    
}


// Simple method for now, fetching unspent coins on the fly //目前的方法很简单，即动态提取未使用的硬币


- (BTCTransaction*) transactionSpendingFromPrivateKey:(NSData*)privateKey
                                                   to:(BTCPublicKeyAddress*)destinationAddress
                                               change:(BTCPublicKeyAddress*)changeAddress
                                               amount:(NSString *)amount
                                                  fee:(NSString*)fee
                                                  api:(BTCAPI)btcApi
                                                error:(NSError**)errorOut
{
    // 1. Get a private key, destination address, change address and amount
    // 2. Get unspent outputs for that key (using both compressed and non-compressed pubkey)
    // 3. Take the smallest available outputs to combine into the inputs of new transaction
    // 4. Prepare the scripts with proper signatures for the inputs
    // 5. Broadcast the transaction
    
    /// 1。获取私钥、目标地址、更改地址和金额
    
    // 2。获取该键的未使用的输出(使用压缩和非压缩pubkey)
    
    // 3。将最小的可用输出合并到新事务的输入中
    
    // 4。为输入准备带有适当签名的脚本
    
    // 5。广播事务
    if (self.utxis.count == 0) {
        self.btcPrompt = [NSString stringWithFormat:@"BTC%@",[LangSwitcher switchLang:@"余额不足" key:nil]];
//        [TLAlert alertWithInfo:[NSString stringWithFormat:@"BTC%@",[LangSwitcher switchLang:@"余额不足" key:nil]]];
        return nil;
    }
    NSError* error = nil;
    NSArray* utxos = self.utxis;
    
    
    
    NSLog(@"UTXOs for %@: %@ %@", self.key.privateKeyAddressTestnet, utxos, error);
    
    if (!utxos) {
        *errorOut = error;
        return nil;
    }
    
    
    CoinModel *coin = [CoinUtil getCoinModel:@"BTC"];
    
    long long mount = [[CoinUtil convertToSysCoin:amount coin:coin.symbol] longLongValue];
    
    BTCAmount btcValue = mount;//转账金额
    BTCAmount sumIntputValue = 0;//Intput总额
    int sumIntputCount = 0;//Intput总个数
    BOOL isChange = NO;//是否需要找零
    BTCAmount changeValue = 0;//找零金额
    long long btcFree = 0;//手续费
    
    NSMutableArray *IntputUtsos = [NSMutableArray array];
    for (int i = 0; i < self.utxis.count; i ++) {
        utxoModel* txout = self.utxis[i];
        sumIntputCount ++;
        
        NSString *txoutCount = [CoinUtil convertToRealCoin:txout.count coin:@"BTC"];
        sumIntputValue = sumIntputValue + [[CoinUtil convertToSysCoin:txoutCount coin:@"BTC"] longLongValue];
        
        [IntputUtsos addObject:txout];
        
        btcFree = (148 * sumIntputCount + 34 * 1 + 10) * [fee floatValue];
        //       Intput总额 大于手续费+转账金额
        if (sumIntputValue >= (btcValue + btcFree)) {
            //       Intput总额 大于   手续费、找零手续费 + 转账金额
            if (sumIntputValue > (btcValue + (148 * sumIntputCount + 34 * 2 + 10) * [fee floatValue]))
            {
                btcFree = (148 * sumIntputCount + 34 * 2 + 10) * [fee floatValue];
                isChange = YES;
                changeValue = sumIntputValue - btcValue - (148 * sumIntputCount + 34 * 2 + 10) * [fee floatValue];
            }
            break;
        }
    }
    
    // We support spending just one output for now. 我们目前只支持支出一项产出。
    if (btcValue + btcFree > sumIntputValue) {
        self.btcPrompt = [LangSwitcher switchLang:@"余额不足" key:nil];
    }
    
    if (!IntputUtsos)
    {
        return nil;
    }
    
    // Create a new transaction
    BTCTransaction* tx = [[BTCTransaction alloc] init];
    
    BTCAmount spentCoins = 0;
    
    // Add all outputs as inputs
    for (utxoModel* txout in IntputUtsos) {
        BTCTransactionInput* txin = [[BTCTransactionInput alloc] init];
        txin.previousHash =  BTCHashFromID(txout.txid);
        txin.previousIndex = [txout.vout intValue];
        [tx addInput:txin];
        
        NSLog(@"txhash: http://blockchain.info/rawtx/%@", BTCHexFromData(txin.previousHash));
        NSLog(@"txhash: http://blockchain.info/rawtx/%@ (reversed)", BTCHexFromData(BTCReversedData([txout.scriptPubKey dataUsingEncoding:NSUTF8StringEncoding])));
        
        spentCoins +=  [[CoinUtil convertToSysCoin:txout.count coin:@"BTC"] longLongValue];
    }
    
    NSLog(@"Total satoshis to spend:       %lld", spentCoins);
    NSLog(@"Total satoshis to destination: %lld", mount);
    NSLog(@"Total satoshis to fee:         %lld", btcFree);
    NSLog(@"Total satoshis to change:      %lld", (spentCoins - (mount + btcFree)));
    
    // Add required outputs - payment and change
    BTCTransactionOutput* paymentOutput = [[BTCTransactionOutput alloc] initWithValue:mount address:destinationAddress];
    [tx addOutput:paymentOutput];
    
    if (isChange == YES) {
        BTCTransactionOutput *changeOutput = [[BTCTransactionOutput alloc] initWithValue:(changeValue) address:changeAddress];
        [tx addOutput:changeOutput];
    }
    // Idea: deterministically-randomly choose which output goes first to improve privacy.//想法:确定随机选择哪个输出优先用于提高隐私。
    
    
    
    
    // Sign all inputs. We now have both inputs and outputs defined, so we can sign the transaction. / /所有输入信号。现在我们已经定义了输入和输出，因此可以对事务进行签名。
    
    
    for (int i = 0; i < IntputUtsos.count; i++) {
        // Normally, we have to find proper keys to sign this txin, but in this 通常情况下，我们需要找到合适的钥匙来签这个txin，example we already know that we use a single private key.但是在这个例我们已经知道我们使用的是一个私钥。
        
        
        utxoModel* txout = IntputUtsos[i]; // output from a previous tx which is referenced by this txin. 此txin引用的前一个tx的输出。
        
        
        BTCTransactionInput* txin = tx.inputs[i];
        
        BTCScript* sigScript = [[BTCScript alloc] init];
        
        
        NSData* d1 = tx.data;
        
        BTCSignatureHashType hashtype = BTCSignatureHashTypeAll;
        BTCScript *sc = [[BTCScript alloc] initWithData:BTCDataFromHex(txout.scriptPubKey)];
        NSData* hash = [tx signatureHashForScript:sc inputIndex:i hashType:hashtype error:errorOut];
        
        NSData* d2 = tx.data;
        
        NSAssert([d1 isEqual:d2], @"Transaction must not change within signatureHashForScript!");
        
        // 134675e153a5df1b8e0e0f0c45db0822f8f681a2eb83a0f3492ea8f220d4d3e4
        NSLog(@"Hash for input %d: %@", i, BTCHexFromData(hash));
        NSLog(@"pubKey: %@", BTCHexFromData(self.key.publicKey));
        
        if (!hash) {
            return nil;
        }
        
        NSData* signatureForScript = [self.key signatureForHash:hash hashType:hashtype];
        [sigScript appendData:signatureForScript];
        [sigScript appendData:self.key.publicKey];
        
        NSData* sig = [signatureForScript subdataWithRange:NSMakeRange(0, signatureForScript.length - 1)]; // trim hashtype byte to check the signature.
        NSAssert([self.key isValidSignature:sig hash:hash], @"Signature must be valid");
        
        txin.signatureScript = sigScript;
    }
    
    //     Validate the signatures before returning for extra measure. 在返回额外度量之前验证签名。
    
    
    {
        BTCScriptMachine* sm = [[BTCScriptMachine alloc] initWithTransaction:tx inputIndex:0];
        NSError* error = nil;
        NSString *scriptPubKey = [[IntputUtsos objectAtIndex:0] scriptPubKey];
        BTCScript *script = [[BTCScript alloc] initWithData:BTCDataFromHex(scriptPubKey)];
        //        BTCScript *script = [[BTCScript alloc] initWithString:scriptPubKey];
        BOOL r = [sm verifyWithOutputScript:script error:&error];
        NSLog(@"Error: %@", error);
        NSAssert(r, @"should verify first output");
        
    }
    
    //     Transaction is signed now, return it. 交易现已签署，返回
    
    
    return tx;
}

-(void)utxoTransfer
{
    
    if (self.utxis.count == 0) {
        [TLAlert alertWithInfo:[NSString stringWithFormat:@"BTC%@",[LangSwitcher switchLang:@"余额不足" key:nil]]];
        return;
    }
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *word;
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT Mnemonics from THAUser where userId = '%@'",[TLUser user].userId];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            word = [set stringForColumn:@"Mnemonics"];
            
        }
        [set close];
    }
    [dataBase.dataBase close];
    //    [self queryTotalAmount];
    
    
    NSArray *words = [word componentsSeparatedByString:@" "];
    
    BTCMnemonic *mnemonic =  [MnemonicUtil importMnemonic:words];
    BTCKeychain *keychain = [mnemonic keychain];
    
    if ([AppConfig config].runEnv == 0) {
        if (![_currency.address isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:BTCADDRESS]]) {
            keychain = [keychain derivedKeychainWithPath:@"m/44'/0'/0'/0/0"];
        }
        
        keychain.network = [BTCNetwork mainnet];
        
    }else{
        if (![_currency.address isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:BTCADDRESS]]) {
            keychain = [keychain derivedKeychainWithPath:@"m/44'/1'/0'/0/0"];
        }
        
        keychain.network = [BTCNetwork testnet];
        
    }
    BTCKey *key = keychain.key;
    self.key = key;
    BTCTransaction* transaction;

    if ([AppConfig config].runEnv == 0) {
        transaction = [UsdtClient createSignedSimpleSend:key.address privateKey:key to:[BTCPublicKeyAddress addressWithString:self.balanceTF.text] currencyID:@"31" amount:self.tranAmountTF.text utxoList:self.utxis setFee:[NSString stringWithFormat:@"%.1f",self.btcPrice] btcValue:self.tranAmountTF.text];
    }else
    {
        transaction = [UsdtClient createSignedSimpleSend:key.addressTestnet privateKey:key to:[BTCPublicKeyAddressTestnet addressWithString:self.balanceTF.text] currencyID:@"2" amount:self.tranAmountTF.text utxoList:self.utxis setFee:[NSString stringWithFormat:@"%.1f",self.btcPrice] btcValue:self.tranAmountTF.text];
    }
    
    if (transaction == nil) {
        return;
    }
    
    self.signTx = BTCHexFromData([transaction data]);
    [self validationSignTx:self.signTx];
    
    
}


-(void)validationSignTx:(NSString *)signTx
{
    //    return;
    TLNetworking *net = [TLNetworking new];
    net.code = @"802222";
    net.showView = self.view;
    net.parameters[@"signTx"] = signTx;
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [net postWithSuccess:^(id responseObject) {
        NSLog(@"%@",responseObject);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [TLAlert alertWithSucces:@"广播成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

@end
