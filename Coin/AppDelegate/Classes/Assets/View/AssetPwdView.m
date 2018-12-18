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
//    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.45];
    
    //    view.alpha = 0.5;
//    [self addSubview:view1];
    UIView *whiteView = [UIView new];
    kViewRadius(whiteView, 6.5);
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
    if (self.isPay == YES) {
        sureLab.text = [LangSwitcher switchLang:@"请输入支付密码" key:nil];

    }else{
        sureLab.text = [LangSwitcher switchLang:@"请输入资金密码" key:nil];

    }
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
    
    UILabel *sure = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12];
    sure.text = [LangSwitcher switchLang:@"连续5次密码错误我们将暂时锁定您的账号" key:nil];
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setBackgroundColor:kClearColor forState:UIControlStateNormal];
    [sureButton setTitleColor:kTextColor3 forState:UIControlStateNormal];
    [whiteView addSubview:sureButton];
    [sureButton setTitle:[LangSwitcher switchLang:@"忘记密码?" key:nil] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(payMoney) forControlEvents:UIControlEventTouchUpInside];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(whiteView.mas_bottom).offset(-15);
        make.left.equalTo(whiteView.mas_left).offset(20);
        make.right.equalTo(whiteView.mas_right).offset(-20);
        make.height.equalTo(@20);

    }];
    
}


- (void)payMoney
{
    if (self.forgetBlock) {
        self.forgetBlock();
    }
    
    
}
- (void)hideSelf
{
    [self.password.textField resignFirstResponder];
    if (self.HiddenBlock) {
        self.HiddenBlock();
    }
//    self.hidden = YES;
//    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
