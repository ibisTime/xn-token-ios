//
//  BillCell.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BillCell.h"
#import "AppColorMacro.h"
#import "TLUIHeader.h"
#import "NSString+Date.h"
#import "NSString+Extension.h"
#import "UILabel+Extension.h"
#import "CoinUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BillCell ()

@property (nonatomic, strong) UIImageView *iconIV;

@property (nonatomic,strong) UILabel *moneyLbl;

@property (nonatomic,strong) UILabel *detailLbl;

@property (nonatomic, strong) UILabel *dayLbl;

@property (nonatomic,strong) UILabel *timeLbl;
@property (nonatomic,strong) UILabel *introduceLab;

@end

@implementation BillCell

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
        self.detailLbl.height = [FONT(14) lineHeight];
        [self addSubview:self.detailLbl];
        
        [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(17);
            make.left.equalTo(self.iconIV.mas_right).offset(15);
            make.right.equalTo(self.mas_right).offset(-100);
            
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
                                               font:Font(11)
                                          textColor:kTextColor3];
        self.introduceLab.numberOfLines = 0;
        self.introduceLab.height = [FONT(14) lineHeight];
        [self addSubview:self.introduceLab];
        
        [self.introduceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dayLbl.mas_bottom).offset(3);
            make.left.equalTo(self.iconIV.mas_right).offset(15);
            
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

    NSString *countStr = [CoinUtil convertToRealCoin:_billModel.transAmountString
                                                coin:billModel.currency];
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

    CoinModel *coin = [CoinUtil getCoinModel:billModel.currency];
    if (money > 0) {
        
        moneyStr = [NSString stringWithFormat:@"+%@ %@",countStr , billModel.currency];
        self.moneyLbl.textColor = kHexColor(@"#47D047");

        self.iconIV.image = kImage(@"收款");

//        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:[coin.pic2 convertImageUrl]]];

    } else if (money <= 0) {
        self.moneyLbl.textColor = kHexColor(@"#FE4F4F");

        moneyStr = [NSString stringWithFormat:@"%@ %@", countStr, billModel.currency];

        self.iconIV.image = kImage(@"转账");

    }


//    self.dayLbl.text = [_billModel.createDatetime convertDateWithFormat:[NSString stringWithFormat:@"dd%@",[LangSwitcher switchLang:[NSString stringWithFormat:@"日"] key:nil]]];
    self.timeLbl.text = [_billModel.createDatetime convertRedDate];

    self.moneyLbl.text = moneyStr;

    self.detailLbl.text = [LangSwitcher switchLang:_billModel.bizNote key:nil]; ;
    
    [self layoutSubviews];
    
    NSInteger num = [self.detailLbl getLinesArrayOfStringInLabel];
    
    _billModel.dHeightValue = num == 1 ? 0: self.detailLbl.height - 10;
    
}

@end
