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

#import <SDWebImage/UIImageView+WebCache.h>

@interface BillCell ()

@property (nonatomic, strong) UIImageView *iconIV;

@property (nonatomic,strong) UILabel *moneyLbl;

@property (nonatomic,strong) UILabel *detailLbl;

@property (nonatomic, strong) UILabel *dayLbl;

//@property (nonatomic,strong) UILabel *timeLbl;
@property (nonatomic,strong) UILabel *introduceLab;

@end

@implementation BillCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
        self.iconIV.contentMode = UIViewContentModeScaleAspectFill;
        self.iconIV.layer.cornerRadius = 15;
        self.iconIV.clipsToBounds = YES;
        [self addSubview:self.iconIV];
//        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.equalTo(self.mas_top).offset(20);
//            make.left.equalTo(self.mas_left).offset(15);
//            make.width.height.equalTo(@30);
//        }];
        
        //备注
        self.detailLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:Font(13)
                                       textColor:kTextBlack];
        self.detailLbl.numberOfLines = 0;
//        self.detailLbl.height = [FONT(14) lineHeight];
        [self addSubview:self.detailLbl];
        
//        [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.mas_top).offset(17);
//            make.left.equalTo(self.iconIV.mas_right).offset(15);
//            make.right.equalTo(self.mas_right).offset(-100);
//
//        }];
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
            make.top.equalTo(self.detailLbl.mas_bottom).offset(4);
            
        }];
        
        self.timeLbl = [UILabel labelWithFrame:CGRectMake(left,15, 40, 20) textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:Font(12.0)
                                     textColor:kTextColor2];
        [self addSubview:self.timeLbl];
        

        
        
        
        //钱
        self.moneyLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:Font(16.0)
                                      textColor:kTextColor];
        self.moneyLbl.frame = CGRectMake(SCREEN_WIDTH - 115, 15, 100, 15);
//        self.moneyLbl.height = [Font(17.0) lineHeight];
        [self addSubview:self.moneyLbl];
//        [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.right.equalTo(self.mas_right).offset(-15);
//            make.top.equalTo(@(16));
//
//        }];
//        self.introduceLab = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft
//                                    backgroundColor:[UIColor clearColor]
//                                               font:Font(11)
//                                          textColor:kTextColor3];
//        self.introduceLab.numberOfLines = 0;
//        self.introduceLab.height = [FONT(14) lineHeight];
//        [self addSubview:self.introduceLab];
//
//        [self.introduceLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.dayLbl.mas_bottom).offset(4);
//            make.left.equalTo(self.iconIV.mas_right).offset(15);
//
//            //            make.right.equalTo(rightArrowIV.mas_left).offset(-15);
//
//        }];
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
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@(1));
            make.top.equalTo(self.timeLbl.mas_bottom).offset(15);
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
    CGFloat money = [countStr doubleValue];


    CoinModel *coin = [CoinUtil getCoinModel:billModel.currency];
    if (money > 0) {
        
        moneyStr = [NSString stringWithFormat:@"+%@ %@",countStr , billModel.currency];
        self.moneyLbl.textColor = kHexColor(@"#47D047");

        self.iconIV.image = kImage(@"转出");

//        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:[coin.pic2 convertImageUrl]]];

    } else if (money <= 0) {
        self.moneyLbl.textColor = kHexColor(@"#FE4F4F");

        moneyStr = [NSString stringWithFormat:@"%@ %@", countStr, billModel.currency];

        self.iconIV.image = kImage(@"转入");

    }
    self.moneyLbl.text = moneyStr;

    
    [self.moneyLbl sizeToFit];
    self.moneyLbl.frame = CGRectMake(SCREEN_WIDTH - 15 - self.moneyLbl.frame.size.width, 15, self.moneyLbl.frame.size.width, 15);
    
    self.detailLbl.text = [LangSwitcher switchLang:_billModel.bizNote key:nil];
    self.detailLbl.frame = CGRectMake(60, 15, SCREEN_WIDTH - 60 - 22 - self.moneyLbl.frame.size.width, 0);
//    self.detailLbl.backgroundColor = [UIColor redColor];
    [self.detailLbl sizeToFit];

//    self.dayLbl.text = [_billModel.createDatetime convertDateWithFormat:[NSString stringWithFormat:@"dd%@",[LangSwitcher switchLang:[NSString stringWithFormat:@"日"] key:nil]]];
    self.timeLbl.text = [_billModel.createDatetime convertRedDate];

    
    
    
//    [self layoutSubviews];
    
    NSInteger num = [self.detailLbl getLinesArrayOfStringInLabel];
    _billModel.dHeightValue = num == 1 ? 0: self.detailLbl.height - 10;
    self.timeLbl.frame = CGRectMake(self.detailLbl.frame.origin.x, self.detailLbl.yy, SCREEN_WIDTH - 80, 15);

}

@end
