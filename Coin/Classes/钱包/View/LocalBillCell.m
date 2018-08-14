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
#import "NSString+Check.h"
@interface  LocalBillCell()

@property (nonatomic, strong) UIImageView *iconIV;

@property (nonatomic,strong) UILabel *moneyLbl;

@property (nonatomic,strong) UILabel *detailLbl;

@property (nonatomic, strong) UILabel *dayLbl;

@property (nonatomic,strong) UILabel *timeLbl;
@property (nonatomic,strong) UILabel *introduceLab;

@end


@implementation LocalBillCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconIV = [[UIImageView alloc] init];
        self.iconIV.contentMode = UIViewContentModeScaleAspectFill;
        self.iconIV.layer.cornerRadius = 15;
        self.iconIV.clipsToBounds = YES;
        [self addSubview:self.iconIV];
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top).offset(20);
            make.left.equalTo(self.mas_left).offset(15);

            make.width.height.equalTo(@30);
            
        }];
        
        //备注
        self.detailLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:Font(14)
                                       textColor:kTextBlack];
        self.detailLbl.numberOfLines = 0;
//        self.detailLbl.height = [FONT(14) lineHeight];
        [self addSubview:self.detailLbl];
        
        [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(17);
            make.left.equalTo(self.iconIV.mas_right).offset(15);
            make.width.equalTo(@(kScreenWidth -130));
            //            make.right.equalTo(rightArrowIV.mas_left).offset(-15);
            
        }];
        CGFloat left = 15;
        CGFloat timeW = 100;
        
        //
        self.dayLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                              backgroundColor:[UIColor clearColor]
                                         font:Font(11.0)
                                    textColor:kTextColor];
        [self addSubview:self.dayLbl];
        
        [self.dayLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.iconIV.mas_right).offset(15);
            make.top.equalTo(self.detailLbl.mas_bottom).offset(2);
          
        }];
        
        self.timeLbl = [UILabel labelWithFrame:CGRectMake(left,15, 40, 20) textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:Font(12.0)
                                     textColor:kTextColor2];
        [self addSubview:self.timeLbl];
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dayLbl.mas_top);

            make.left.equalTo(self.dayLbl.mas_right).offset(3);
           
        }];
        
       
       
        //钱
        self.moneyLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:Font(17.0)
                                      textColor:kTextColor];
        self.moneyLbl.height = [Font(17.0) lineHeight];
        [self addSubview:self.moneyLbl];
        [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(@(18.5));
            
        }];
        self.introduceLab = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:Font(12)
                                       textColor:kTextColor3];
        self.introduceLab.numberOfLines = 0;
//        self.introduceLab.height = [FONT(14) lineHeight];
        [self addSubview:self.introduceLab];
        
        [self.introduceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dayLbl.mas_bottom).offset(3);
            make.left.equalTo(self.iconIV.mas_right).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);

            
            //            make.right.equalTo(rightArrowIV.mas_left).offset(-15);
            
        }];
        //右箭头
//        UIImageView *rightArrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
//
//        [self addSubview:rightArrowIV];
//        [rightArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.right.equalTo(self.mas_right).offset(-15);
//            make.centerY.equalTo(self.mas_centerY);
//            make.width.equalTo(@(6.5));
//        }];
//
       
        
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
    
   
    //    [_billModel.transAmountString convertToSimpleRealCoin];
//    CGFloat money = [countStr doubleValue];
    
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
        self.moneyLbl.textColor = kHexColor(@"#47D047");
        if (![_billModel.value valid]) {
            self.moneyLbl.text = [NSString stringWithFormat:@"%@",[LangSwitcher switchLang:@"即将到账" key:nil]];

        }else{
            NSString *countStr = [CoinUtil convertToRealCoin:_billModel.value
                                                        coin:self.currencyModel.symbol];
            self.moneyLbl.text = [NSString stringWithFormat:@"+%@ %@",countStr , self.currencyModel.symbol];

        }
        
        self.introduceLab.text = [NSString stringWithFormat:@"%@-%@",[LangSwitcher switchLang:@"收款-外部地址" key:nil],billModel.from];
        if ([self.currencyModel.symbol isEqualToString:@"BTC"]) {
            self.introduceLab.text = [NSString stringWithFormat:@"%@-%@",[LangSwitcher switchLang:@"收款-交易Hash" key:nil],billModel.txHash];

        }
        
    } else
    {
        self.moneyLbl.textColor = kHexColor(@"#FE4F4F");
        if (![_billModel.value valid]) {
            self.moneyLbl.text = [NSString stringWithFormat:@"%@",[LangSwitcher switchLang:@"即将到账" key:nil]];
            
        }else{
            NSString *countStr = [CoinUtil convertToRealCoin:_billModel.value
                                                        coin:self.currencyModel.symbol];
            self.moneyLbl.text = [NSString stringWithFormat:@"-%@ %@", countStr, self.currencyModel.symbol];

        }
         self.introduceLab.text = [NSString stringWithFormat:@"%@-%@",[LangSwitcher switchLang:@"转账-外部地址" key:nil],billModel.to];
        if ([self.currencyModel.symbol isEqualToString:@"BTC"]) {
            self.introduceLab.text = [NSString stringWithFormat:@"%@-%@",[LangSwitcher switchLang:@"转账-交易Hash" key:nil],billModel.txHash];
            
        }
        
    }
//    if ([self.currencyModel.symbol isEqualToString:@"ETH"]) {
//        self.iconIV.image = kImage(@"eth");
//    }else if ([self.currencyModel.symbol isEqualToString:@"WAN"])
//    {
//        self.iconIV.image  = kImage(@"wan");
//        
//    }else{
//        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:[coin.pic1 convertImageUrl]]];
//
//    }

    self.dayLbl.text = [_billModel.transDatetime convertDateWithFormat:@"dd日"];
    self.timeLbl.text = [_billModel.transDatetime convertDateWithFormat:@"HH:mm"];
    
    if ([billModel.direction isEqualToString:@"0"]) {
        self.detailLbl.text = [LangSwitcher switchLang:[NSString stringWithFormat:@"转账"] key:nil]; ;
        self.iconIV.image = kImage(@"转账");


    }else
    {
         self.detailLbl.text = [LangSwitcher switchLang:[NSString stringWithFormat:@"收款"] key:nil]; ;
        self.iconIV.image  = kImage(@"收款");

    }
//    self.detailLbl.text = [LangSwitcher switchLang:_billModel.bizNote key:nil]; ;
    
    [self layoutSubviews];
    
    NSInteger num = [self.detailLbl getLinesArrayOfStringInLabel];
    
    _billModel.dHeightValue = num == 1 ? 0: self.detailLbl.height - 10;
    
}

@end
