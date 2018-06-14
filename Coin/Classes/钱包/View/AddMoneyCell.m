//
//  AddMoneyCell.m
//  Coin
//
//  Created by shaojianfei on 2018/6/7.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "AddMoneyCell.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "NSString+Extension.h"
#import "UIButton+EnLargeEdge.h"
#import "CoinUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AddMoneyCell()

//币种图标
@property (nonatomic, strong) UIImageView *coinIV;
//币种名称
@property (nonatomic, strong) UILabel *currencyNameLbl;
//选择
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIView *whiteView;

@end
@implementation AddMoneyCell
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
        
        make.left.equalTo(@(0));
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
    
    self.selectButton = [UIButton buttonWithImageName:@"未选中" selectedImageName:@"选中资产"];
    self.selectButton.selected = YES;
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
    
//    CoinModel *coin = [CoinUtil getCoinModel:currency.currency];
    self.currencyNameLbl.text = [NSString stringWithFormat:@"%@",currency.symbol];
    if ([currency.symbol isEqualToString:@"WAN"]) {
        self.coinIV.image = [UIImage imageNamed:@"wan"];
    }else if ([currency.symbol isEqualToString:@"ETH"])
    {
        self.coinIV.image = [UIImage imageNamed:@"eth"];
    }
    NSArray *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"localArray"];
    if (a.count == 1) {
        for (NSMutableDictionary*Dictionary in a) {
            
            NSString *symbol = [Dictionary objectForKey:@"symbol"];
            if (symbol == currency.symbol) {
                self.selectButton.selected = YES;

            }else
            {
                self.selectButton.selected = NO;

                
            }
            
        }
        
    }else if(a.count == 2)
    {
        {
            for (NSMutableDictionary*Dictionary in a) {
                
                NSString *symbol = [Dictionary objectForKey:@"symbol"];
                if (symbol == currency.symbol) {
                    self.selectButton.selected = YES;
                    
                }else
                {
                    self.selectButton.selected = YES;
                    
                    
                }
                
            }
            
        }
        
    }else
    {
        self.selectButton.selected = currency.IsSelected;

        
    }
   
   

//    [self.coinIV sd_setImageWithURL:[NSURL URLWithString:[coin.pic1 convertImageUrl]]];
    
//    NSString *leftAmount = [_currency.amountString subNumber:_currency.frozenAmountString];
    
    //
  
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
