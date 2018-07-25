//
//  AssetPwdView.m
//  Coin
//
//  Created by shaojianfei on 2018/7/25.
//  Copyright © 2018年 chengdai. All rights reserved.
//
#import "AppColorMacro.h"
#import "TLUIHeader.h"
#import "CoinModel.h"
#import "CoinUtil.h"
#import "NSString+Extension.h"
#import "TLUser.h"
#import "TLNetworking.h"
#import "TLAlert.h"
#import "UIImageView+WebCache.h"

#import "NSString+Date.h"
#import "NSString+Check.h"
#import "CurrencyModel.h"
#import "AssetPwdView.h"
#import "TTPasswordView.h"
@interface   AssetPwdView()

@property (nonatomic ,strong) UIView *view1;


@end
@implementation AssetPwdView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //
        [self initSubvies];
        //汇率
        [self layout];
    }
    return self;
}

- (void)layout
{
    
    
}

- (void)initSubvies
{
    
    
    
//    UIView * view1 = [UIView new];
//    self.view1 = view1;
//    view1.frame =CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    view1.backgroundColor =
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.45];
    
    //    view.alpha = 0.5;
//    [self addSubview:view1];
    UIView *whiteView = [UIView new];
    
    [self addSubview:whiteView];
    
    whiteView.frame = CGRectMake(24, kHeight(194), kScreenWidth - 48, kHeight(240));
    
    whiteView.backgroundColor = kWhiteColor;
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setBackgroundImage:kImage(@"红包 删除") forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).offset(10);
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.width.height.equalTo(@22.5);
    }];
    
    UILabel *sureLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:20];
    sureLab.text = [LangSwitcher switchLang:@"请输入支付密码" key:nil];
    [whiteView addSubview:sureLab];
    [sureLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).offset(50);
        make.centerX.equalTo(whiteView.mas_centerX);
    }];
    
    self.password = [[TTPasswordView alloc] initWithFrame:CGRectZero];
    self.password.textField.keyboardType=UIKeyboardTypePhonePad;
    self.password.elementCount = 6;
    self.password.textField.secureTextEntry=YES;
    self.password.textField.enabled = NO;
    self.password.elementColor=kLineColor;
    [whiteView addSubview:self.password];
    CoinWeakSelf
    self.password.passwordBlock = ^(NSString *password) {
        if (password.length==6) {
            //i
            if (weakSelf.passwordBlock) {
                weakSelf.passwordBlock(password);
            }
        }
    };
    
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureLab.mas_bottom).offset(30);
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.left.equalTo(whiteView.mas_left).offset(15);
        make.height.equalTo(@56);
    }];
//    UILabel *money = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#A75E02") font:17];
//    CoinModel *coin = [CoinUtil getCoinModel:plat.currency];
//
//    NSString *leftAmount = [CoinUtil convertToRealCoin:plat.amountString coin:coin.symbol];
//    NSString *rightAmount = [CoinUtil convertToRealCoin:plat.frozenAmountString coin:coin.symbol];
//    NSString *ritAmount = [leftAmount subNumber:rightAmount];
//    money.text = [NSString stringWithFormat:@"%@%@",_count,plat.currency];
//    [whiteView addSubview:money];
//    [money mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(sureLab.mas_bottom).offset(16);
//        make.centerX.equalTo(whiteView.mas_centerX);
//    }];
//
//    UIView *buttonView =[UIView new];
//    buttonView.backgroundColor = kWhiteColor;
//    buttonView.layer.borderWidth = 0.5;
//    buttonView.layer.borderColor = kLineColor.CGColor;
//    //    buttonView.layer.cornerRadius = 5.0;
//    //    buttonView.clipsToBounds = YES;
//    [whiteView addSubview:buttonView];
//
//    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(money.mas_bottom).offset(16);
//        make.left.equalTo(whiteView.mas_left).offset(25);
//        make.right.equalTo(whiteView.mas_right).offset(-25);
//        make.height.equalTo(@48);
//    }];
//
//    UILabel *blanceMoney = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:15];
//    blanceMoney.text = [LangSwitcher switchLang:@"账户余额" key:nil];
//    [buttonView addSubview:blanceMoney];
//    [blanceMoney mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(buttonView.mas_top).offset(13);
//        make.left.equalTo(buttonView.mas_left).offset(10);
//
//    }];
//
//    UILabel *blance = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15];
//    blance.text = [LangSwitcher switchLang:[NSString stringWithFormat:@"%.3f%@",[ritAmount floatValue],plat.currency] key:nil];
//    [buttonView addSubview:blance];
//    [blance mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(buttonView.mas_top).offset(13);
//        make.left.equalTo(blanceMoney.mas_right).offset(16);
//
//    }];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setBackgroundColor:kClearColor forState:UIControlStateNormal];
    [sureButton setTitleColor:kTextColor3 forState:UIControlStateNormal];
    [whiteView addSubview:sureButton];
    [sureButton setTitle:[LangSwitcher switchLang:@"忘记密码？" key:nil] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(payMoney) forControlEvents:UIControlEventTouchUpInside];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(whiteView.mas_bottom).offset(-30);
        make.left.equalTo(whiteView.mas_left).offset(20);
        make.right.equalTo(whiteView.mas_right).offset(-20);
        make.height.equalTo(@20);
        
    }];
    
}

- (void)hideSelf
{
    if (self.HiddenBlock) {
        self.HiddenBlock();
    }
    self.hidden = YES;
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
