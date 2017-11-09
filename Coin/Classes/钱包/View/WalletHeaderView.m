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
//总资产
@property (nonatomic, strong) UILabel *amountLbl;

@end

@implementation WalletHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //
        [self initSubvies];
        
    }
    return self;
}

#pragma mark - Init
- (void)initSubvies {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgIV = [[UIImageView alloc] init];
    
    bgIV.image = kImage(@"我的-背景");
    bgIV.contentMode = UIViewContentModeScaleToFill;
    
    [self addSubview:bgIV];
    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@(160 + kStatusBarHeight));
        
    }];
    
    self.bgIV = bgIV;
    
    //text
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:18.0];
    
    textLbl.text = @"我的资产";
    
    [self addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(13 + kStatusBarHeight);
        
    }];
    
    //总资产折合CNY
    UIButton *equivalentBtn = [UIButton buttonWithTitle:@"总资产折合CNY" titleColor:kWhiteColor backgroundColor:kClearColor titleFont:12.0];
    
    
    [equivalentBtn setImage:kImage(@"总资产") forState:UIControlStateNormal];
    
    [self addSubview:equivalentBtn];
    [equivalentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(textLbl.mas_bottom).offset(21);
        make.centerX.equalTo(self.mas_centerX);
        
    }];
    
    //总资产
    self.amountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:15.0];
    
    [self addSubview:self.amountLbl];
    [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(equivalentBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        
    }];
    
}

@end
