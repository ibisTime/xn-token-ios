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
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 73, SCREEN_WIDTH - 30, 1)];
    self.lineView.backgroundColor = kLineColor;
    [self addSubview:self.lineView];
    
    
    //币种名称
    self.presentImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 30, 30)];
    //    self.presentImage.image =kImage(@"bch");
    [self addSubview:self.presentImage];
    
    
    self.currencyNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:[UIColor blackColor]
                                                        font:0];
    self.currencyNameLbl.font = FONT(14);
    self.currencyNameLbl.frame = CGRectMake(self.presentImage.x - 10, self.presentImage.yy + 5.5, 50, 14);
    self.currencyNameLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.currencyNameLbl];
    
    
    self.tradeVolumeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kHexColor(@"#999999")
                                                       font:13.0];
    self.tradeVolumeLbl.frame = CGRectMake(self.presentImage.xx + 10 ,  18.5, 0, 13);
    [self addSubview:self.tradeVolumeLbl];
    
    
    //当前对应币种价格
    self.opppsitePriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kHexColor(@"#999999")
                                                         font:13.0];
    self.opppsitePriceLbl.textAlignment = NSTextAlignmentRight;
    self.opppsitePriceLbl.frame = CGRectMake(self.tradeVolumeLbl.xx + 10, 16.5, SCREEN_WIDTH - self.tradeVolumeLbl.xx - 22, 20);
    [self addSubview:self.opppsitePriceLbl];
    
    
    
    self.priceFluctBtn = [UIButton buttonWithTitle:@"-7.89%" titleColor:kHexColor(@"#999999") backgroundColor:kClearColor titleFont:13];
    self.priceFluctBtn.frame = CGRectMake(self.presentImage.xx + 10, 40, 0, 22);
    [self.priceFluctBtn sizeToFit];
    self.priceFluctBtn.frame = CGRectMake(self.presentImage.xx + 10, 40, self.priceFluctBtn.width + 10, 22);
    [self.priceFluctBtn SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:3 imagePositionBlock:^(UIButton *button) {
        [button setImage:kImage(@"下降") forState:(UIControlStateNormal)];
    }];
    [self addSubview:self.priceFluctBtn];
    
    //当前人民币价格
    self.rmbPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kHexColor(@"#999999")
                                                    font:13.0];
    self.rmbPriceLbl.frame = CGRectMake(self.priceFluctBtn.xx + 10, 44, SCREEN_WIDTH - 30 - self.priceFluctBtn.xx, 14);
    self.rmbPriceLbl.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:self.rmbPriceLbl];
    
    //24H交易量
    

    
    
    
    
    
    
    
    //布局
//    [self setSubviewLayout];
    
    
}

//- (void)setSubviewLayout {
//
//    [self.presentImage mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(@15);
//        make.left.equalTo(@15);
//        make.width.equalTo(@40);
//        make.height.equalTo(@40);
//
//    }];
//    //币种名称
//    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(@15);
//        make.left.equalTo(self.presentImage.mas_right).offset(15);
//        //        make.left.equalTo(@30);
//
//    }];
//    //一日交易量
//    [self.tradeVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_bottom).offset(-15);
//        //        make.top.equalTo(self.currencyNameLbl.mas_bottom).offset(20);
//        make.left.equalTo(self.presentImage.mas_right).offset(15);
//
//    }];
//
//    //rmb价格
//    [self.rmbPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.tradeVolumeLbl.mas_right).offset(10);
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.top.equalTo(self.tradeVolumeLbl.mas_top);
//    }];
//    //对应币种
//    [self.opppsitePriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.currencyNameLbl.mas_right).offset(10);
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.top.equalTo(self.currencyNameLbl.mas_top);
//    }];
//    //    self.rmbPriceLbl.backgroundColor = [UIColor redColor];
//
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_bottom);
//        make.left.equalTo(@15);
//        make.right.equalTo(@-15);
//        make.height.equalTo(@0.5);
//    }];
//    self.lineView.backgroundColor = kLineColor;
//}

#pragma mark - Setting
- (void)setPlatform:(CurrencyModel *)platform {
    _platform = platform;
    
    
    //    self.coinIV.image = kImage(_currency.getImgName);
    
    CoinModel *coin = [CoinUtil getCoinModel:platform.symbol];
    [self.presentImage sd_setImageWithURL:[NSURL URLWithString:[coin.pic1 convertImageUrl]]];
    if ([platform.address isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:BTCADDRESS]]) {
        self.currencyNameLbl.text = @"BTC(old version)";
    }else
    {
        self.currencyNameLbl.text = platform.symbol;
    }
    

//    NSString *eyes = [[NSUserDefaults standardUserDefaults] objectForKey:@"eyes"];
//    if ([eyes isEqualToString:@"1"]) {
//        if ([[TLUser user].localMoney isEqualToString:@"USD"]) {
//            self.tradeVolumeLbl.text = [NSString stringWithFormat:@"≈%.2fUSD",[platform.priceUSD doubleValue]];
//            self.rmbPriceLbl.text = @"%****USD";
//
//        }else if ([[TLUser user].localMoney isEqualToString:@"KRW"])
//        {
//            self.tradeVolumeLbl.text = [NSString stringWithFormat:@"≈%.2fKRW",[platform.priceKRW doubleValue]];
//            self.rmbPriceLbl.text = @"****KRW";
//
//        }
//        else{
//
//            self.tradeVolumeLbl.text = [NSString stringWithFormat:@"≈%.2fCNY",[platform.priceCNY doubleValue]];
//            self.rmbPriceLbl.text = @"****CNY";
//
//
//        }
////        NSString *text =  [CoinUtil convertToRealCoin:platform.balance coin:platform.symbol];
//
//        self.opppsitePriceLbl.text = @"****";
//
//
//
//    }else
//    {
        if ([[TLUser user].localMoney isEqualToString:@"USD"]) {
            self.tradeVolumeLbl.text = [NSString stringWithFormat:@"≈%.2f USD",[platform.priceUSD doubleValue]];
            self.rmbPriceLbl.text = [NSString stringWithFormat:@"%.2fUSD",[platform.amountUSD doubleValue]];
            
        }else if ([[TLUser user].localMoney isEqualToString:@"KRW"])
        {
            self.tradeVolumeLbl.text = [NSString stringWithFormat:@"≈%.2f KRW",[platform.priceKRW doubleValue]];
            self.rmbPriceLbl.text = [NSString stringWithFormat:@"%.2fKRW",[platform.amountKRW doubleValue]];
            
        }
        else{
            
            self.tradeVolumeLbl.text = [NSString stringWithFormat:@"≈%.2fCNY",[platform.priceCNY doubleValue]];
            self.rmbPriceLbl.text = [NSString stringWithFormat:@"%.2fCNY",[platform.amountCNY doubleValue]];
            
            
        }
        NSString *text =  [CoinUtil convertToRealCoin:platform.balance coin:platform.symbol];
        
        self.opppsitePriceLbl.text = [NSString stringWithFormat:@"%.8f", [text floatValue]];
        
//    }
    [self.tradeVolumeLbl sizeToFit];
    
}


#pragma mark - Setting



- (void)setPlatform1:(CurrencyModel *)platform1 {
    
    CurrencyModel *platform = platform1;
//    _platform1 = platform;
    
    NSLog(@"---------%@",platform);
    CoinModel *coin = [CoinUtil getCoinModel:platform.currency];
    
    [self.presentImage sd_setImageWithURL:[NSURL URLWithString:[coin.pic1 convertImageUrl]]];
    
    
    
    self.currencyNameLbl.text = platform.currency;
//    }
    
    
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
        
        NSString *text = [NSString stringWithFormat:@"%.8f %@",[ritAmount doubleValue],platform.currency];
        
        NSMutableAttributedString *fontAttributeNameStr = [[NSMutableAttributedString alloc]initWithString:text];
        // 2.添加属性
        [fontAttributeNameStr addAttribute:NSFontAttributeName value:HGboldfont(22) range:NSMakeRange(0, text.length - platform.currency.length)];
        [fontAttributeNameStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, text.length - platform.currency.length)];
        
        self.opppsitePriceLbl.attributedText = fontAttributeNameStr;

    }
    [self.tradeVolumeLbl sizeToFit];
    self.opppsitePriceLbl.frame = CGRectMake(self.tradeVolumeLbl.xx + 10, 15.5, SCREEN_WIDTH - self.tradeVolumeLbl.xx - 20, 22);
    
}


@end
