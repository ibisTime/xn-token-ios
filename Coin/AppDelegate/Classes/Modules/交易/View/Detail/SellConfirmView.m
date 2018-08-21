//
//  SellConfirmView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "SellConfirmView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface SellConfirmView ()

//背景
@property (nonatomic, strong) UIView *bgView;
//出售价格
@property (nonatomic, strong) UILabel *priceLbl;
//出售金额
@property (nonatomic, strong) UILabel *amountLbl;
//出售数量
@property (nonatomic, strong) UILabel *numLbl;

@property (nonatomic, strong) UILabel *promptLbl;

@end

@implementation SellConfirmView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    CoinWeakSelf;
    
    self.alpha = 0;
    
    self.backgroundColor = [UIColor colorWithUIColor:kBlackColor alpha:0.6];
    
    self.bgView = [[UIView alloc] init];
    
    self.bgView.backgroundColor = kWhiteColor;
    
    self.bgView.layer.cornerRadius = 10;
    self.bgView.clipsToBounds = YES;
    
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(@0);
        make.height.equalTo(@310);
        make.width.equalTo(@(kWidth(307)));
        
    }];
    
    //下单确定
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"下单确定")];
    
    [self.bgView addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@15);
        make.centerX.equalTo(@0);
        
    }];
    
    UILabel *confirmLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:18.0];
    
    confirmLbl.text = @"下单确定";
    
    [self.bgView addSubview:confirmLbl];
    [confirmLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(iconIV.mas_bottom).offset(11);
        make.centerX.equalTo(@0);
        
    }];
    
    NSArray *textArr = @[@"出售价格", @"出售金额", @"出售数量"];
    
    __block UILabel *lastLbl = confirmLbl;
    
    [textArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:12.0];
        
        textLbl.text = textArr[idx];
        [self.bgView addSubview:textLbl];
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(kWidth(30)));
            make.top.equalTo(lastLbl.mas_bottom).offset(16);
            
        }];
        
        lastLbl = textLbl;
    }];
    
    //出售价格
    self.priceLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:12.0];
    
    self.priceLbl.textAlignment = NSTextAlignmentRight;
    
    [self.bgView addSubview:self.priceLbl];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-kWidth(30)));
        make.top.equalTo(confirmLbl.mas_bottom).offset(16);
        
    }];
    
    //出售金额
    self.amountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:12.0];
    
    self.amountLbl.textAlignment = NSTextAlignmentRight;
    
    [self.bgView addSubview:self.amountLbl];
    [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-kWidth(30)));
        make.top.equalTo(self.priceLbl.mas_bottom).offset(16);
        
    }];
    //出售数量
    self.numLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:12.0];
    
    self.numLbl.textAlignment = NSTextAlignmentRight;
    
    [self.bgView addSubview:self.numLbl];
    [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-kWidth(30)));
        make.top.equalTo(self.amountLbl.mas_bottom).offset(16);
        
    }];
    
    //提示
    
    self.promptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kThemeColor font:11.0];
    
    self.promptLbl.text = @"提醒: 请确认价格再下单, 下单后此交易的ETH将托管锁定, 请放心出售";
    
    self.promptLbl.numberOfLines = 0;
    
    [self.bgView addSubview:self.promptLbl];
    [self.promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lastLbl.mas_bottom).offset(27);
        make.left.equalTo(@50);
        make.right.equalTo(@(-kWidth(30)));
        
    }];
    
    UIImageView *promptIV = [[UIImageView alloc] initWithImage:kImage(@"提示")];
    
    [self.bgView addSubview:promptIV];
    [promptIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.promptLbl.mas_centerY);
        make.left.equalTo(@(kWidth(30)));
        
    }];
    
    //确认出售
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确认出售" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:14.0 cornerRadius:5];
    
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-kWidth(30)));
        make.top.equalTo(self.promptLbl.mas_bottom).offset(35);
        make.width.equalTo(@(kWidth(110)));
        make.height.equalTo(@35);
    }];
    
    //放弃出售
    UIButton *cancelBtn = [UIButton buttonWithTitle:@"放弃出售" titleColor:kWhiteColor backgroundColor:[UIColor colorWithHexString:@"#dedede"] titleFont:14.0 cornerRadius:5];
    
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kWidth(30)));
        make.top.equalTo(self.promptLbl.mas_bottom).offset(35);
        make.width.equalTo(@(kWidth(110)));
        make.height.equalTo(@35);
    }];
}

#pragma mark - Setting
- (void)setPriceModel:(OrderPriceModel *)priceModel {
    
    _priceModel = priceModel;
    
    self.priceLbl.text = [NSString stringWithFormat:@"%@ CNY", priceModel.price];
    
    self.amountLbl.text = [NSString stringWithFormat:@"%@ CNY", priceModel.amount];
    
    self.numLbl.text = [NSString stringWithFormat:@"%@ %@", priceModel.num, priceModel.coin];
    
    self.promptLbl.text = [NSString stringWithFormat:@"提醒: 请确认价格再下单, 下单后此交易的%@将托管锁定, 请放心购买",priceModel.coin];
    
}

#pragma mark - Events
- (void)confirm {
    
    if (self.confirmBlock) {
        
        self.confirmBlock();
    }
    
    [self hide];
}

- (void)cancel {
    
    [self hide];
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

@end
