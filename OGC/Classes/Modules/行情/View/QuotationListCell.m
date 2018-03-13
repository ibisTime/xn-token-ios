//
//  QuotationListCell.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "QuotationListCell.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "UILabel+Extension.h"

@interface QuotationListCell ()

//交易站点
@property (nonatomic, strong) UILabel *siteNameLbl;
//交易量
@property (nonatomic, strong) UILabel *tradeNumLbl;
//美元
@property (nonatomic, strong) UILabel *usdNumLbl;
//人民币
@property (nonatomic, strong) UILabel *cnyNumLbl;

@end

@implementation QuotationListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //交易站点
    self.siteNameLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kThemeColor font:18.0];
    
    [self addSubview:self.siteNameLbl];
    [self.siteNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@13);
        
    }];
    
    //交易量
    self.tradeNumLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    
    [self addSubview:self.tradeNumLbl];
    [self.tradeNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.siteNameLbl.mas_left);
        make.top.equalTo(self.siteNameLbl.mas_bottom).offset(11);
        
    }];
    
    //美元
    self.usdNumLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:18.0];
    
    self.usdNumLbl.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:self.usdNumLbl];
    [self.usdNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(@13);
        
    }];
    
    //人民币
    self.cnyNumLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:12.0];
    
    self.cnyNumLbl.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:self.cnyNumLbl];
    [self.cnyNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.usdNumLbl.mas_right);
        make.top.equalTo(self.usdNumLbl.mas_bottom).offset(11);
        
    }];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
}

- (void)setQuotation:(QuotationModel *)quotation {
    
    _quotation = quotation;
    
    self.siteNameLbl.text = quotation.origin;
    
    
    self.tradeNumLbl.text = [NSString stringWithFormat:@"交易量 %@",quotation.volume];
    
    NSString *cny = [NSString stringWithFormat:@"%.4lf CNY", [quotation.mid doubleValue]];

    [self.cnyNumLbl labelWithString:cny title:@"CNY" font:Font(12.0) color:kTextColor];

    NSString *usd = @"7463.00 USD";
    
    [self.usdNumLbl labelWithString:usd title:@"USD" font:Font(12.0) color:kTextColor];
}
@end
