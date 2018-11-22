//
//  WalletAddressCell.m
//  Coin
//
//  Created by shaojianfei on 2018/6/12.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "WalletAddressCell.h"


@interface  WalletAddressCell()
//币种图标
@property (nonatomic, strong) UIImageView *coinIV;
//币种名称
@property (nonatomic, strong) UILabel *currencyNameLbl;
//选择
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIView *whiteView;

@end
@implementation WalletAddressCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = kClearColor;
    
    CGFloat leftMargin = 15;
    
    //背景
    UIView *whiteView = [[UIView alloc] init];
    
    whiteView.backgroundColor = kWhiteColor;
    
    [self addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(0));
        make.top.bottom.equalTo(@0);
        make.right.equalTo(@(0));
        
    }];
    
    //币种图标
    self.coinIV = [[UIImageView alloc] init];
    self.coinIV.contentMode = UIViewContentModeScaleAspectFit;
    [whiteView addSubview:self.coinIV];
    [self.coinIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.top.equalTo(@10);
        make.width.equalTo(@(62));
        make.height.equalTo(@(62));
        
    }];
    
    //币种名称
    self.currencyNameLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kBlackColor font:14.0];
    
    [whiteView addSubview:self.currencyNameLbl];
    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.coinIV.mas_right).offset(16);
        make.centerY.equalTo(self.coinIV.mas_centerY);
        
    }];
    
    self.selectButton = [UIButton buttonWithImageName:@"更多-灰色" selectedImageName:@"更多-灰色"];
//    self.selectButton.selected = YES;
    [whiteView addSubview:self.selectButton];
    [self.selectButton addTarget:self action:@selector(ChoseClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@-15);
        make.centerY.equalTo(self.coinIV.mas_centerY);
        make.width.height.equalTo(@20);
        
    }];
    
    //    //币种金额
    //    self.amountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:24.0];
    //
    //    [whiteView addSubview:self.amountLbl];
    //    [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.left.equalTo(self.currencyNameLbl.mas_left);
    //        make.top.equalTo(self.currencyNameLbl.mas_bottom).offset(12);
    //
    //    }];
}
- (void)ChoseClick: (UIButton *)btn
{
    
    btn.selected =! btn.selected;
    _currency.IsSelected = btn.selected;
    
}

- (void)setCurrency:(CurrencyModel *)currency {
    
    _currency = currency;
    
    
    //    self.coinIV.image = kImage(_currency.getImgName);
    
        CoinModel *coin = [CoinUtil getCoinModel:currency.symbol];
    self.currencyNameLbl.text = [NSString stringWithFormat:@"%@  私钥",currency.symbol];
//    if ([currency.symbol isEqualToString:@"WAN"]) {
//        self.coinIV.image = [UIImage imageNamed:@"wan"];
//    }else if ([currency.symbol isEqualToString:@"ETH"])
//    {
//        self.coinIV.image = [UIImage imageNamed:@"eth"];
//    }
    self.selectButton.selected = currency.IsSelected;
    
        [self.coinIV sd_setImageWithURL:[NSURL URLWithString:[coin.pic1 convertImageUrl]]];
    
    //    NSString *leftAmount = [_currency.amountString subNumber:_currency.frozenAmountString];
    
    //
    
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
