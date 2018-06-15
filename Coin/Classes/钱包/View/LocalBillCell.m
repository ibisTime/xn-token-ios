//
//  LocalBillCell.m
//  Coin
//
//  Created by shaojianfei on 2018/6/15.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "LocalBillCell.h"
#import "AppColorMacro.h"
#import "TLUIHeader.h"
#import "NSString+Date.h"
#import "NSString+Extension.h"
#import "UILabel+Extension.h"
#import "CoinUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface  LocalBillCell()

@property (nonatomic, strong) UIImageView *iconIV;

@property (nonatomic,strong) UILabel *moneyLbl;

@property (nonatomic,strong) UILabel *detailLbl;

@property (nonatomic, strong) UILabel *dayLbl;

@property (nonatomic,strong) UILabel *timeLbl;
@end


@implementation LocalBillCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat left = 15;
        CGFloat timeW = 100;
        
        //
        self.dayLbl = [UILabel labelWithFrame:CGRectMake(left,15, 40, 20) textAligment:NSTextAlignmentLeft
                              backgroundColor:[UIColor clearColor]
                                         font:Font(15.0)
                                    textColor:kTextColor];
        [self addSubview:self.dayLbl];
        
        [self.dayLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY).offset(-10);
            make.width.equalTo(@40);
            make.height.equalTo(@20);
        }];
        
        self.timeLbl = [UILabel labelWithFrame:CGRectMake(left,15, 40, 20) textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:Font(12.0)
                                     textColor:kTextColor2];
        [self addSubview:self.timeLbl];
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY).offset(10);
            make.width.equalTo(@40);
            make.height.equalTo(@20);
        }];
        
        self.iconIV = [[UIImageView alloc] init];
        self.iconIV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.iconIV];
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(@0);
            make.width.height.equalTo(@36);
            make.left.equalTo(self.timeLbl.mas_right).offset(15);
            
        }];
        
        //钱
        self.moneyLbl = [UILabel labelWithFrame:CGRectMake(left, 15, kScreenWidth - left - timeW - 15, 20) textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:Font(17.0)
                                      textColor:kTextColor];
        self.moneyLbl.height = [Font(17.0) lineHeight];
        [self addSubview:self.moneyLbl];
        [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.iconIV.mas_right).offset(15);
            make.right.equalTo(@(-15));
            make.top.equalTo(@(12.5));
            
        }];
        
        //右箭头
        UIImageView *rightArrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
        
        [self addSubview:rightArrowIV];
        [rightArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@(6.5));
        }];
        
        //备注
        self.detailLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:Font(14)
                                       textColor:kTextColor2];
        self.detailLbl.numberOfLines = 0;
        self.detailLbl.height = [FONT(14) lineHeight];
        [self addSubview:self.detailLbl];
        
        [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-12.5);
            make.left.equalTo(self.iconIV.mas_right).offset(15);
            make.right.equalTo(rightArrowIV.mas_left).offset(-15);
            
        }];
        
        UIView *line = [[UIView alloc] init];
        
        line.backgroundColor = kLineColor;
        
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(@(0.5));
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
    
}

- (void)setBillModel:(BillModel *)billModel {
    
    _billModel = billModel;
    
    //
    
    NSString *moneyStr = @"";
    
    NSString *countStr = [CoinUtil convertToRealCoin:_billModel.value
                                                coin:self.currencyModel.symbol];
    //    [_billModel.transAmountString convertToSimpleRealCoin];
    CGFloat money = [countStr doubleValue];
    
    //    if (money > 0) {
    //
    //        moneyStr = [NSString stringWithFormat:@"+%@ %@",countStr , billModel.currency];
    //
    //
    //        self.iconIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"账单-充币-%@",billModel.currency]];
    //
    //    } else if (money <= 0) {
    //
    //        moneyStr = [NSString stringWithFormat:@"%@ %@", countStr, billModel.currency];
    //
    //        self.iconIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"账单-提币-%@",billModel.currency]];
    //
    //    }
    
    CoinModel *coin = [CoinUtil getCoinModel:self.currencyModel.symbol];
    if ([billModel.direction isEqualToString:@"1"]) {
        
        moneyStr = [NSString stringWithFormat:@"+%@ %@",countStr , self.currencyModel.symbol];
        
        
    } else
    {
        
        moneyStr = [NSString stringWithFormat:@"-%@ %@", countStr, self.currencyModel.symbol];
        
        
    }
    if ([self.currencyModel.symbol isEqualToString:@"ETH"]) {
        self.iconIV.image = kImage(@"eth");
    }else if ([self.currencyModel.symbol isEqualToString:@"WAN"])
    {
        self.iconIV.image  = kImage(@"wan");
        
    }else{
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:[coin.pic1 convertImageUrl]]];

    }

    self.dayLbl.text = [_billModel.transDatetime convertDateWithFormat:@"dd日"];
    self.timeLbl.text = [_billModel.transDatetime convertDateWithFormat:@"HH:mm"];
    
    self.moneyLbl.text = moneyStr;
    if ([billModel.direction isEqualToString:@"0"]) {
        self.detailLbl.text = [LangSwitcher switchLang:[NSString stringWithFormat:@"%@ 转账",self.currencyModel.symbol] key:nil]; ;

    }else
    {
         self.detailLbl.text = [LangSwitcher switchLang:[NSString stringWithFormat:@"%@  收款",self.currencyModel.symbol] key:nil]; ;
        
    }
//    self.detailLbl.text = [LangSwitcher switchLang:_billModel.bizNote key:nil]; ;
    
    [self layoutSubviews];
    
    NSInteger num = [self.detailLbl getLinesArrayOfStringInLabel];
    
    _billModel.dHeightValue = num == 1 ? 0: self.detailLbl.height - 10;
    
}

@end
