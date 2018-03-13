//
//  OrderArbitrationView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "OrderArbitrationView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "TLTextView.h"
#import "TLAlert.h"

#import "NSString+Check.h"

@interface OrderArbitrationView ()
//背景
@property (nonatomic, strong) UIView *bgView;
//按钮数组
@property (nonatomic, strong) NSMutableArray <UIButton *>*btnArr;
//仲裁原因
@property (nonatomic, strong) TLTextView *arbitrationTV;

@end

@implementation OrderArbitrationView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.btnArr = [NSMutableArray array];
    
    self.alpha = 0;
    
    self.backgroundColor = [UIColor colorWithUIColor:kBlackColor alpha:0.6];
    
    self.bgView = [[UIView alloc] init];
    
    self.bgView.backgroundColor = kWhiteColor;
    
    self.bgView.layer.cornerRadius = 10;
    self.bgView.clipsToBounds = YES;
    
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.top.equalTo(@(kHeight(105)));
        make.center.equalTo(@0);
        make.height.equalTo(@320);
        make.width.equalTo(@(kWidth(307)));
        
    }];
    //申请仲裁
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"下单确定")];
    
    [self.bgView addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@15);
        make.centerX.equalTo(@0);
        
    }];
    
    UILabel *confirmLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:18.0];
    
    confirmLbl.text = [LangSwitcher switchLang:@"申请仲裁" key:nil];
    
    [self.bgView addSubview:confirmLbl];
    [confirmLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(iconIV.mas_bottom).offset(11);
        make.centerX.equalTo(@0);
        
    }];
    
    //仲裁原因
    self.arbitrationTV = [[TLTextView alloc] initWithFrame:CGRectMake(0, 0, kWidth(307), 150)];
    
    self.arbitrationTV.placholder = [LangSwitcher switchLang:@"请填写申请仲裁的原因" key:nil];
    self.arbitrationTV.font = Font(14.0);
    
    self.arbitrationTV.layer.cornerRadius = 5;
    self.arbitrationTV.clipsToBounds = YES;
    self.arbitrationTV.layer.borderWidth = 0.5;
    self.arbitrationTV.layer.borderColor = kTextColor2.CGColor;
    
    [self.bgView addSubview:self.arbitrationTV];
    [self.arbitrationTV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@150);
        make.top.equalTo(confirmLbl.mas_bottom).offset(15);
        
    }];
    
    //确认申请
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确认申请"
                                          titleColor:kWhiteColor
                                     backgroundColor:kThemeColor
                                           titleFont:14.0
                                        cornerRadius:5];
    
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-kWidth(30)));
        make.top.equalTo(self.arbitrationTV.mas_bottom).offset(25);
        make.width.equalTo(@(kWidth(110)));
        make.height.equalTo(@35);
    }];
    
    //放弃申请
    UIButton *cancelBtn = [UIButton buttonWithTitle:@"放弃申请"
                                         titleColor:kWhiteColor
                                    backgroundColor:[UIColor colorWithHexString:@"#dedede"] titleFont:14.0 cornerRadius:5];
    
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kWidth(30)));
        make.top.equalTo(confirmBtn.mas_top);
        make.width.equalTo(@(kWidth(110)));
        make.height.equalTo(@35);
    }];
    
}

#pragma mark - Events

- (void)cancel {
    
    [self hide];
}

- (void)confirm {
    
    if (![self.arbitrationTV.text valid]) {
        
        [TLAlert alertWithInfo:@"请填写申请仲裁的原因"];
        return ;
    }
    
    if (self.arbitrationBlock) {
        
        self.arbitrationBlock(self.arbitrationTV.text);
    }
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.arbitrationTV resignFirstResponder];
}

@end
