//
//  WallAccountHeadView.m
//  Coin
//
//  Created by shaojianfei on 2018/6/6.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "WallAccountHeadView.h"
#import <Masonry.h>
#import "UILable+convience.h"
#import "AppColorMacro.h"
#import "UILabel+Extension.h"
#import "NSString+Extension.h"

#import "LangSwitcher.h"
#import "CoinUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface WallAccountHeadView()
@property (nonatomic ,strong) UIImageView *bgIV;
@property (nonatomic ,strong) UILabel *textLbl;
@property (nonatomic ,strong) UILabel *currentLbl;
@property (nonatomic ,strong) UILabel *amountLbl;

@end
@implementation WallAccountHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //
        [self initSubvies];
        
    }
    return self;
}
- (void)initSubvies
{
    
    UIImageView *bgIV = [[UIImageView alloc] init];
    self.bgIV = bgIV;
    bgIV.contentMode = UIViewContentModeScaleToFill;
    
    [self addSubview:bgIV];
    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(@16);
        make.width.height.equalTo(@49);
        
    }];
    
    self.bgIV = bgIV;
    
    //text
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kBlackColor font:17.0];
    
//    textLbl.text = [LangSwitcher switchLang:@"我的资产" key:nil];
    self.textLbl = textLbl;
    [self addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.bgIV.mas_bottom).offset(10);
        
    }];
    
    UILabel *currentLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kBlackColor font:15.0];
    
    //    textLbl.text = [LangSwitcher switchLang:@"我的资产" key:nil];
    self.currentLbl = currentLbl;
    [self addSubview:currentLbl];
    [currentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_right).offset(10);
        make.top.equalTo(self.textLbl.mas_top).offset(0);
        
    }];
    UILabel *amountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#108ee9") font:12.0];
    
    //    textLbl.text = [LangSwitcher switchLang:@"我的资产" key:nil];
    self.amountLbl = amountLbl;
    [self addSubview:amountLbl];
    [amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.textLbl.mas_bottom).offset(18);
        
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);

        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.height.equalTo(@4);
    }];
}

-(void)setCurrency:(CurrencyModel *)currency
{
    _currency = currency;
    CoinModel *coin = [CoinUtil getCoinModel:currency.currency];
    
    [self.bgIV sd_setImageWithURL:[NSURL URLWithString:[coin.icon convertImageUrl]]];
    self.currentLbl.text = currency.currency;
    NSString *leftAmount = [currency.amountString subNumber:currency.frozenAmountString];
    
    self.textLbl.text = [NSString stringWithFormat:@"%.4f CNY",[[CoinUtil convertToRealCoin:leftAmount coin:currency.currency] doubleValue]];
    NSString *rightAmount = [currency.inAmountString subNumber:currency.addAmountString];
    
    //对应币种价格
    self.amountLbl.text = [NSString stringWithFormat:@"≈%.2fCNY", [[CoinUtil convertToRealCoin:rightAmount coin:currency.currency] doubleValue]];
    
    //人民币价格
//    self.rmbPriceLbl.text = [NSString stringWithFormat:@"≈%.2f CNY",[[CoinUtil convertToRealCoin:leftAmount coin:platform.currency] doubleValue]];
}
@end
