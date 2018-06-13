//
//  WalletHeaderView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "WalletHeaderView.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface WalletHeaderView ()
//背景
@property (nonatomic, strong) UIImageView *bgIV;

//汇率
@property (nonatomic, strong) UILabel *rateAmountLbl;
//左边国旗
@property (nonatomic, strong) UIImageView *leftFlag;
//右边国旗
@property (nonatomic, strong) UIImageView *rightFlag;
@property (nonatomic, strong) UILabel *textLbl;
@end

@implementation WalletHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //
        [self initSubvies];
        //汇率
        [self initRateView];
        
    }
    return self;
}

#pragma mark - Init
- (void)initSubvies {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgIV = [[UIImageView alloc] init];
    
    bgIV.image = kImage(@"资产背景");
    bgIV.contentMode = UIViewContentModeScaleToFill;
    
    [self addSubview:bgIV];
    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@(150 + kStatusBarHeight));
        
    }];
    
    self.bgIV = bgIV;
    
    //text
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:18.0];
    
    textLbl.text = [LangSwitcher switchLang:@"我的资产" key:nil];
    self.textLbl = textLbl;
    [self addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(13 + kStatusBarHeight);
        
    }];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton = addButton;
    [addButton setBackgroundImage:kImage(@"添加") forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addCurrent) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    [equivalentBtn setImage:kImage(@"总资产") forState:UIControlStateNormal];
    
    [self addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.textLbl.mas_centerY);
        make.width.height.equalTo(@17);
        
    }];
    //总资产折合CNY
    UIButton *equivalentBtn = [UIButton buttonWithTitle:
                               [LangSwitcher switchLang:@"我的资产(CNY)" key:nil]
                            
                                             titleColor:kWhiteColor backgroundColor:kClearColor titleFont:12.0];
    
    
//    [equivalentBtn setImage:kImage(@"总资产") forState:UIControlStateNormal];
    
    [self addSubview:equivalentBtn];
    [equivalentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(textLbl.mas_bottom).offset(15);
        make.centerX.equalTo(self.mas_centerX);
        make.width.greaterThanOrEqualTo(@115);
        
    }];
    
    [equivalentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    
    //总资产
    self.cnyAmountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:35.0];
    
    [self addSubview:self.cnyAmountLbl];
    [self.cnyAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(equivalentBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        
    }];
    
    //美元
//    self.usdAmountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:15.0];
//    
//    self.usdAmountLbl.textAlignment = NSTextAlignmentCenter;
//
//    [self addSubview:self.usdAmountLbl];
//    [self.usdAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.cnyAmountLbl.mas_bottom).offset(12);
//        make.left.equalTo(@0);
//        make.width.equalTo(@(kScreenWidth/2.0));
//
//    }];
//    
//    //港元
//    self.hkdAmountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:15.0];
//    
//    self.hkdAmountLbl.textAlignment = NSTextAlignmentCenter;
//    
//    [self addSubview:self.hkdAmountLbl];
//    [self.hkdAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.cnyAmountLbl.mas_bottom).offset(12);
//        make.left.equalTo(self.usdAmountLbl.mas_right);
//        make.width.equalTo(@(kScreenWidth/2.0));
//        
//    }];
    
}

- (void)addCurrent
{
    
    if (_addBlock) {
        _addBlock();
    }
    
    
}

- (void)initRateView {
    //白色背景
    UIView *whiteView = [[UIView alloc] init];
    
    whiteView.backgroundColor = kWhiteColor;
    self.whiteView = whiteView;
    [self addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.top.equalTo(self.bgIV.mas_bottom);
        make.height.equalTo(@50);
        
    }];
    
    //点击手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRate:)];
    
    [whiteView addGestureRecognizer:tapGR];
    
    //左边国旗
    self.leftFlag = [[UIImageView alloc] init];
    
    [whiteView addSubview:self.leftFlag];
    [self.leftFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(whiteView.mas_centerY);
        
    }];
    
    //汇率
    self.rateAmountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    [whiteView addSubview:self.rateAmountLbl];
    [self.rateAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.leftFlag.mas_right).offset(10);
        make.centerY.equalTo(whiteView.mas_centerY);
        
    }];
    //右边国旗
    self.rightFlag = [[UIImageView alloc] init];
    
    [whiteView addSubview:self.rightFlag];
    [self.rightFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.rateAmountLbl.mas_right).offset(10);
        make.centerY.equalTo(whiteView.mas_centerY);
        
    }];
    
    //右箭头
    UIImageView *rightArrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    [whiteView addSubview:rightArrowIV];
    [rightArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.centerY.equalTo(whiteView.mas_centerY);
        make.width.equalTo(@(6.5));

    }];
}

#pragma mark - Setting
- (void)setUsdRate:(NSString *)usdRate {
    
    _usdRate = usdRate;
    
    self.leftFlag.image = kImage(@"公告");
    
    self.rateAmountLbl.text = @"区块链迎来新时代!";
    
//    self.rightFlag.image = kImage(@"中国国旗");
    
}

- (void)setHkdRate:(NSString *)hkdRate {
    
    _hkdRate = hkdRate;
    
}

#pragma mark - Events
- (void)clickRate:(UITapGestureRecognizer *)tapGR {
    
    if (_headerBlock) {
        
        _headerBlock();
    }
}

@end
