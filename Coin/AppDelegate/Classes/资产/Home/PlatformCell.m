//
//  PlatformCell.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlatformCell.h"
#import "TLUser.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSNumber+Extension.h"
#import "NSString+Extension.h"
#import "UIButton+EnLargeEdge.h"
#import "UILable+convience.h"
#import "AppColorMacro.h"
#import "Masonry.h"
#import "CoinUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface PlatformCell()
//币种名称
@property (nonnull, strong) UILabel *currencyNameLbl;
//24H交易量
@property (nonatomic, strong) UILabel *tradeVolumeLbl;
//当前对应币种
@property (nonatomic, strong) UILabel *opppsitePriceLbl;
//当前人民币价格
@property (nonatomic, strong) UILabel *rmbPriceLbl;
//涨跌情况
@property (nonatomic, strong) UIButton *priceFluctBtn;
@property (nonatomic, strong) UIImageView *presentImage;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation PlatformCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //币种名称
    self.presentImage = [[UIImageView alloc] init];
//    self.presentImage.image =kImage(@"bch");
    [self addSubview:self.presentImage];
    
    self.currencyNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kBlackColor
                                                       font:17.0];
    [self addSubview:self.currencyNameLbl];
    //24H交易量
    self.tradeVolumeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kHexColor(@"#999999")
                                                       font:12.0];
    
    [self addSubview:self.tradeVolumeLbl];
    //涨跌情况
//    self.priceFluctBtn = [UIButton buttonWithTitle:@""
//                                        titleColor:kWhiteColor
//                                   backgroundColor:kClearColor
//                                         titleFont:17.0 cornerRadius:5];
//
//    [self addSubview:self.priceFluctBtn];
    
    //当前对应币种价格
    self.opppsitePriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kHexColor(@"#484848")
                                                         font:17.0];
    
    [self addSubview:self.opppsitePriceLbl];
    
    //当前人民币价格
    self.rmbPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kHexColor(@"#999999")
                                                    font:12.0];
    
    [self addSubview:self.rmbPriceLbl];


    self.lineView = [UIView new];
    self.lineView.backgroundColor = kLineColor;
    [self addSubview:self.lineView];
    //布局
    [self setSubviewLayout];


}

- (void)setSubviewLayout {
    
    [self.presentImage mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(@15);
        make.left.equalTo(@15);
        make.width.equalTo(@49);
        make.height.equalTo(@49);

    }];
    //币种名称
    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@15);
        make.left.equalTo(self.presentImage.mas_right).offset(20);
//        make.left.equalTo(@30);

    }];
    //一日交易量
    [self.tradeVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.currencyNameLbl.mas_bottom).offset(20);
        make.left.equalTo(self.presentImage.mas_right).offset(20);

    }];
//    //涨幅
//    [self.priceFluctBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(@(-15));
//        make.centerY.equalTo(@0);
//        make.height.equalTo(@37);
//    }];
    //rmb价格
    [self.rmbPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.tradeVolumeLbl.mas_top);
    }];
    //对应币种
    [self.opppsitePriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.currencyNameLbl.mas_top);
    }];


    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
}

#pragma mark - Setting
- (void)setPlatform:(CurrencyModel *)platform {
    _platform = platform;
    
    NSLog(@"---------%@",platform);    
    CoinModel *coin = [CoinUtil getCoinModel:platform.currency];
    
    [self.presentImage sd_setImageWithURL:[NSURL URLWithString:[coin.pic1 convertImageUrl]]];

   self.currencyNameLbl.text = platform.currency;
    
     NSString *leftAmount = [CoinUtil convertToRealCoin:platform.amountString coin:platform.currency];
    NSString *rightAmount = [CoinUtil convertToRealCoin:platform.frozenAmountString coin:platform.currency];
    NSString *ritAmount = [leftAmount subNumber:rightAmount];

    if ([[TLUser user].localMoney isEqualToString:@"USD"]) {
        self.tradeVolumeLbl.text = [NSString stringWithFormat:@"≈%.2f USD",[platform.priceUSD doubleValue]];
        self.rmbPriceLbl.text = [NSString stringWithFormat:@"%.2f USD",[platform.amountUSD doubleValue]];

    } else if ([[TLUser user].localMoney isEqualToString:@"KRW"])
    {
        self.tradeVolumeLbl.text = [NSString stringWithFormat:@"≈%.2f KRW",[platform.priceKRW doubleValue]];
        self.rmbPriceLbl.text = [NSString stringWithFormat:@"%.2f KRW",[platform.amountKRW doubleValue]];
        
    }
    else{
        self.tradeVolumeLbl.text = [NSString stringWithFormat:@"≈%.2f CNY",[platform.priceCNY doubleValue]];
        self.rmbPriceLbl.text = [NSString stringWithFormat:@"%.2f CNY",[platform.amountCNY doubleValue]];

    }
    self.opppsitePriceLbl.text = [NSString stringWithFormat:@"%.8f",[ritAmount doubleValue]];
}

@end
