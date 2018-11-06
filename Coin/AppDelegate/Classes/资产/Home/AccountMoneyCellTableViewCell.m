//
//  AccountMoneyCellTableViewCell.m
//  Coin
//
//  Created by shaojianfei on 2018/6/11.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "AccountMoneyCellTableViewCell.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSNumber+Extension.h"
#import "NSString+Extension.h"
#import "UIButton+EnLargeEdge.h"
#import "UILable+convience.h"
#import "AppColorMacro.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TLUser.h"

@interface AccountMoneyCellTableViewCell()

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
@implementation AccountMoneyCellTableViewCell

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
                                                        font:14.0];
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
                                                         font:14.0];
    self.opppsitePriceLbl.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.opppsitePriceLbl];
    
    //当前人民币价格
    self.rmbPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kHexColor(@"#999999")
                                                    font:12.0];
    self.opppsitePriceLbl.textAlignment = NSTextAlignmentRight;
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
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        
    }];
    //币种名称
    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@15);
        make.left.equalTo(self.presentImage.mas_right).offset(15);
        //        make.left.equalTo(@30);
        
    }];
    //一日交易量
    [self.tradeVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        //        make.top.equalTo(self.currencyNameLbl.mas_bottom).offset(20);
        make.left.equalTo(self.presentImage.mas_right).offset(15);
        
    }];
    
    //rmb价格
    [self.rmbPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tradeVolumeLbl.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.tradeVolumeLbl.mas_top);
    }];
    //对应币种
    [self.opppsitePriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.currencyNameLbl.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.currencyNameLbl.mas_top);
    }];
    //    self.rmbPriceLbl.backgroundColor = [UIColor redColor];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(@0.5);
    }];
    self.lineView.backgroundColor = kLineColor;
}

#pragma mark - Setting
- (void)setPlatform:(CurrencyModel *)platform {
    _platform = platform;
    
    
    //    self.coinIV.image = kImage(_currency.getImgName);
    
    CoinModel *coin = [CoinUtil getCoinModel:platform.symbol];
    
    [self.presentImage sd_setImageWithURL:[NSURL URLWithString:[coin.pic1 convertImageUrl]]];

    self.currencyNameLbl.text = platform.symbol;

    NSString *eyes = [[NSUserDefaults standardUserDefaults] objectForKey:@"eyes"];
    if ([eyes isEqualToString:@"1"]) {
        if ([[TLUser user].localMoney isEqualToString:@"USD"]) {
            self.tradeVolumeLbl.text = [NSString stringWithFormat:@"≈%.2f USD",[platform.priceUSD doubleValue]];
            self.rmbPriceLbl.text = @"%**** USD";
            
        }else if ([[TLUser user].localMoney isEqualToString:@"KRW"])
        {
            self.tradeVolumeLbl.text = [NSString stringWithFormat:@"≈%.2f KRW",[platform.priceKRW doubleValue]];
            self.rmbPriceLbl.text = @"**** KRW";
            
        }
        else{
            
            self.tradeVolumeLbl.text = [NSString stringWithFormat:@"≈%.2f CNY",[platform.priceCNY doubleValue]];
            self.rmbPriceLbl.text = @"**** CNY";
            
            
        }
//        NSString *text =  [CoinUtil convertToRealCoin:platform.balance coin:platform.symbol];
        
        self.opppsitePriceLbl.text = @"****";
        


    }else
    {
        if ([[TLUser user].localMoney isEqualToString:@"USD"]) {
            self.tradeVolumeLbl.text = [NSString stringWithFormat:@"≈%.2f USD",[platform.priceUSD doubleValue]];
            self.rmbPriceLbl.text = [NSString stringWithFormat:@"%.2f USD",[platform.amountUSD doubleValue]];
            
        }else if ([[TLUser user].localMoney isEqualToString:@"KRW"])
        {
            self.tradeVolumeLbl.text = [NSString stringWithFormat:@"≈%.2f KRW",[platform.priceKRW doubleValue]];
            self.rmbPriceLbl.text = [NSString stringWithFormat:@"%.2f KRW",[platform.amountKRW doubleValue]];
            
        }
        else{
            
            self.tradeVolumeLbl.text = [NSString stringWithFormat:@"≈%.2f CNY",[platform.priceCNY doubleValue]];
            self.rmbPriceLbl.text = [NSString stringWithFormat:@"%.2f CNY",[platform.amountCNY doubleValue]];
            
            
        }
        NSString *text =  [CoinUtil convertToRealCoin:platform.balance coin:platform.symbol];
        
        self.opppsitePriceLbl.text = [NSString stringWithFormat:@"%.8f", [text floatValue]];
        

        
    }
    
}


#pragma mark - Setting



- (void)setPlatform1:(CurrencyModel *)platform1 {
    
    CurrencyModel *platform = platform1;
//    _platform1 = platform;
    
    NSLog(@"---------%@",platform);
    CoinModel *coin = [CoinUtil getCoinModel:platform.currency];
    
    [self.presentImage sd_setImageWithURL:[NSURL URLWithString:[coin.pic1 convertImageUrl]]];
    
    self.currencyNameLbl.text = platform.currency;
    
    NSString *leftAmount = [CoinUtil convertToRealCoin:platform.amountString coin:platform.currency];
    NSString *rightAmount = [CoinUtil convertToRealCoin:platform.frozenAmountString coin:platform.currency];
    NSString *ritAmount = [leftAmount subNumber:rightAmount];
    
    
    NSString *eyes = [[NSUserDefaults standardUserDefaults] objectForKey:@"eyes"];
    if ([eyes isEqualToString:@"1"]) {
        if ([[TLUser user].localMoney isEqualToString:@"USD"]) {
            self.tradeVolumeLbl.text = [NSString stringWithFormat:@"≈%.2f USD",[platform.priceUSD doubleValue]];
            self.rmbPriceLbl.text = @"**** USD";
            
        } else if ([[TLUser user].localMoney isEqualToString:@"KRW"])
        {
            self.tradeVolumeLbl.text = [NSString stringWithFormat:@"≈%.2f KRW",[platform.priceKRW doubleValue]];
            self.rmbPriceLbl.text = @"%**** KRW";
            
        }
        else{
            self.tradeVolumeLbl.text = [NSString stringWithFormat:@"≈%.2f CNY",[platform.priceCNY doubleValue]];
            self.rmbPriceLbl.text = @"**** CNY";
        }
        self.opppsitePriceLbl.text = @"****";
    }else
    {
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
    
    
}

@end
