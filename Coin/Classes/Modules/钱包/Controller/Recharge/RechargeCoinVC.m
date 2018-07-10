//
//  RechargeCoinVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "RechargeCoinVC.h"
#import "CoinHeader.h"

#import "UIButton+EnLargeEdge.h"
#import "NSString+CGSize.h"
#import "UILabel+Extension.h"
#import "UIBarButtonItem+convience.h"

#import "SGQRCodeGenerateManager.h"

#import "BillVC.h"

@interface RechargeCoinVC ()

@property (nonatomic, strong) UIView *topView;
//二维码
@property (nonatomic, strong) UIView *qrView;
//地址
@property (nonatomic, strong) UIView *addressView;

@end

@implementation RechargeCoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [LangSwitcher switchLang:@"收款" key:nil];
    //提示框
//    [self initTopView];
    //二维码
    [self initQRView];
    //地址
    [self initAddressView];
    //记录
    [self addRecodeItem];
    
}

#pragma mark - Init

- (void)initTopView {
    
    CGFloat topH = kScreenWidth > 375 ? kHeight(50): 50;
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, topH)];
    
    self.topView.backgroundColor = [UIColor colorWithHexString:@"#fdfbed"];
    
    [self.view addSubview:self.topView];
    
    UIButton *cancelBtn = [UIButton buttonWithImageName:@"取消"];
    
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelBtn setEnlargeEdge:15];
    
    [self.topView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.equalTo(@15);
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-15));
        
    }];
    
    UILabel *promptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kAppCustomMainColor font:12.0];
    NSString *address;
    if (self.currency.symbol) {
        address = self.currency.symbol;
    }else{
        address = self.currency.currency;
        
        
    }
    NSString *currency = address;

//    promptLbl.text = [NSString stringWithFormat:@"%@钱包地址禁止充值除%@之外的其他资产, 任何%@资产充值将不可找回",currency,currency,currency];
//    promptLbl.text = [LangSwitcher switchLang: promptLbl.text key:nil];
    promptLbl.frame = CGRectMake(0, 0, kScreenWidth, 50);
    
    promptLbl.numberOfLines = 0;
    
//    [self.topView addSubview:promptLbl];
//    [promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(@15);
//        make.right.equalTo(cancelBtn.mas_left).offset(-10);
//        make.height.equalTo(@50);
//        make.top.equalTo(@0);
//
//    }];
}

- (void)initQRView {
    
    self.qrView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topView.yy, kScreenWidth, 275)];
    
    self.qrView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:self.qrView];
//    [self.qrView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(self.topView.mas_bottom);
//        make.left.right.equalTo(@0);
//        make.height.equalTo(@275);
//
//    }];
    
    //二维码
    UIImageView *qrIV = [[UIImageView alloc] init];
    NSString *address ;
    if (self.currency.symbol) {
        address = self.currency.address;
    }else{
        address = self.currency.coinAddress;

        
    }
    
    qrIV.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:address imageViewWidth:140];
    
    [self.qrView addSubview:qrIV];
    [qrIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@56);
        make.centerX.equalTo(self.qrView.mas_centerX);
        make.width.height.equalTo(@140);
        
    }];
    
    NSString *text = [LangSwitcher switchLang:@"点击复制地址" key:nil];
    CGFloat btnW = [NSString getWidthWithString:text font:12.0];
    //复制
    UIButton *copyBtn = [UIButton buttonWithTitle:text titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:12.0];
    
    [copyBtn setEnlargeEdge:10];
    
    [copyBtn addTarget:self action:@selector(clickCopyAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.qrView addSubview:copyBtn];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(qrIV.mas_bottom).offset(25);
        make.centerX.equalTo(self.qrView.mas_centerX);
        make.width.equalTo(@(btnW));
        
    }];
    
    [copyBtn.titleLabel labelWithString:text
                                  title:[LangSwitcher switchLang:@" " key:nil]
                                   font:Font(12.0)
                                  color:kAppCustomMainColor];

}

- (void)initAddressView {
    
    self.addressView = [[UIView alloc] initWithFrame:CGRectMake(0, self.qrView.yy, kScreenWidth, 50)];
    self.addressView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.addressView];
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.qrView.mas_bottom);
    }];
    
    
    //点击复制
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCopy)];
    [self.addressView addGestureRecognizer:tapGR];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLineColor;
    [self.addressView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    
    UILabel *textlbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    textlbl.text = [LangSwitcher switchLang:@"地址" key:nil];
    [self.addressView addSubview:textlbl];
    [textlbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(self.addressView.mas_centerY);
//        make.top.equalTo(@0);
//        make.height.equalTo(@50);
        
    }];
    
    UILabel *addressLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    addressLbl.numberOfLines = 0;
    NSString *address ;
    if (self.currency.symbol) {
        address = self.currency.address;
    }else{
        address = self.currency.coinAddress;
        
        
    }
    addressLbl.text = [NSString stringWithFormat:@"%@", address];
    [self.addressView addSubview:addressLbl];
    [addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(textlbl.mas_right).offset(25);
        make.top.equalTo(@0);
        make.right.equalTo(@(-25));
        make.height.mas_greaterThanOrEqualTo(50);
        make.bottom.equalTo(self.addressView.mas_bottom);
//        make.height.equalTo(@50);
        
    }];
    
}

- (void)addRecodeItem {
    
//    [UIBarButtonItem addRightItemWithTitle:[LangSwitcher switchLang:@"记录" key:nil]
//                                titleColor:kTextColor
//                                     frame:CGRectMake(0, 0, 40, 44)
//                                        vc:self
//                                    action:@selector(lookBillRecord)];
//    [UIBarButtonItem adRightItemWithImageName:@"记录" frame:CGRectMake(0, 0, 40, 44) vc:self action:@selector(lookBillRecord)];
//    [UIBarButtonItem addRightItemWithImageName:@"记录" frame:CGRectMake(0, 0, 40, 44) vc:self action:@selector(lookBillRecord)];
}

#pragma mark - Events
- (void)clickCancel {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.qrView.y = 0;
        
        self.addressView.y = self.qrView.yy;
        
    }];
}

- (void)clickCopyAddress {
    
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSString *address ;
    if (self.currency.symbol) {
        address = self.currency.address;
    }else{
        address = self.currency.coinAddress;
        
        
    }
    pasteBoard.string = address;
    
    if (pasteBoard == nil) {
        
        [TLAlert alertWithError:@"复制失败, 请重新复制"];
        
    } else {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"复制成功" key:nil]];
    }
}

- (void)lookBillRecord {
    
    BillVC *billVC = [BillVC new];
    
    billVC.accountNumber = self.currency.accountNumber;
    
    billVC.billType = BillTypeRecharge;

    [self.navigationController pushViewController:billVC animated:YES];
}

- (void)clickCopy {
    
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSString *address ;
    if (self.currency.symbol) {
        address = self.currency.address;
    }else{
        address = self.currency.coinAddress;
        
        
    }
    pasteBoard.string = address;
    
    if (pasteBoard == nil) {
        
        [TLAlert alertWithError:@"复制失败, 请重新复制"];
        
    } else {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"复制成功" key:nil]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
