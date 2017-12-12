//
//  QuotationCell.m
//  Coin
//
//  Created by 蔡卓越 on 2017/12/7.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "QuotationCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSString+Extension.h"

@interface QuotationCell ()

//币种名称
@property (nonnull, strong) UILabel *currencyNameLbl;
//24H交易量
@property (nonatomic, strong) UILabel *tradeVolumeLbl;
//当前美元价格
@property (nonatomic, strong) UILabel *usdPriceLbl;
//当前人民币价格
@property (nonatomic, strong) UILabel *rmbPriceLbl;
//涨跌情况
@property (nonatomic, strong) UIButton *priceFluctBtn;

@end

@implementation QuotationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //币种名称
    self.currencyNameLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kBlackColor font:18.0];
    
    [self addSubview:self.currencyNameLbl];
    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@15);
        make.left.equalTo(@15);
        
    }];
    
    //24H交易量
    self.tradeVolumeLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:12.0];
    
    [self addSubview:self.tradeVolumeLbl];
    [self.tradeVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.currencyNameLbl.mas_bottom).offset(11);
        make.left.equalTo(self.currencyNameLbl.mas_left);
        
    }];
    
    //涨跌情况
    self.priceFluctBtn = [UIButton buttonWithTitle:@"" titleColor:kWhiteColor backgroundColor:kClearColor titleFont:16.0 cornerRadius:5];
    
    [self addSubview:self.priceFluctBtn];
    [self.priceFluctBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
        make.height.equalTo(@37);
        
    }];
    
    //当前美元价格
    self.usdPriceLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kClearColor font:19.0];
    
    [self addSubview:self.usdPriceLbl];
    [self.usdPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.priceFluctBtn.mas_left).offset(-15);
        make.top.equalTo(self.currencyNameLbl.mas_top);
        
    }];
    
    //当前人民币价格
    self.rmbPriceLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
    
    [self addSubview:self.rmbPriceLbl];
    [self.rmbPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.priceFluctBtn.mas_left).offset(-15);
        make.top.equalTo(self.tradeVolumeLbl.mas_top);
        
    }];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(-0.5));
        make.height.equalTo(@0.5);
        
    }];
}

- (void)setQuotation:(CoinQuotationModel *)quotation {
    
    _quotation = quotation;
    
    //币种名称
    self.currencyNameLbl.text = quotation.symbol;
    
    //一日交易量
    CGFloat volume = [quotation.one_day_volume_cny doubleValue];

    NSString *volumeStr = @"";
    
    if (volume <= 10000) {
        
        volumeStr = quotation.total_supply;
        
    } else if (volume > 10000) {
        
        volumeStr = [NSString stringWithFormat:@"%@万", [quotation.one_day_volume_cny divNumber:@"10000" leaveNum:2]];
    }
    
    self.tradeVolumeLbl.text = [NSString stringWithFormat:@"量%@", volumeStr];
    
    //美元价格
    self.usdPriceLbl.text = [NSString stringWithFormat:@"$%@", quotation.price_usd];
    
    self.usdPriceLbl.textColor = quotation.bgColor;
    //人民币价格
    self.rmbPriceLbl.text = [NSString stringWithFormat:@"￥%@", quotation.price_cny];
    
    //涨跌情况
    NSString *priceFluctStr = quotation.percent_change_1h;
    CGFloat fluct = [priceFluctStr doubleValue];
    
    if (fluct >= 0) {
        
        priceFluctStr = [NSString stringWithFormat:@"+%@%%", quotation.percent_change_1h];
        
    } else {
        
        priceFluctStr = [NSString stringWithFormat:@"%@%%", quotation.percent_change_1h];

    }
    
    [self.priceFluctBtn setTitle:priceFluctStr forState:UIControlStateNormal];
    [self.priceFluctBtn setBackgroundColor:quotation.bgColor forState:UIControlStateNormal];
    
    CGFloat btnW = [NSString getWidthWithString:priceFluctStr font:16.0] + 15;
    [self.priceFluctBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(btnW > 75 ? btnW: 75));
        
    }];
}

@end
