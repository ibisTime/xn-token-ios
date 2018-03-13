//
//  RateDescCell.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "RateDescCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "NSNumber+Extension.h"

@interface RateDescCell ()
//汇率
@property (nonatomic, strong) UILabel *rateLbl;
//左边国旗
@property (nonatomic, strong) UIImageView *leftFlag;
//右边国旗
@property (nonatomic, strong) UIImageView *rightFlag;
//
@property (nonatomic, strong) UILabel *textLbl;

@end

@implementation RateDescCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //汇率
    self.rateLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:18.0];
    
    self.rateLbl.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.rateLbl];
    [self.rateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(@(44));
        
    }];
    
    //左边国旗
    self.leftFlag = [[UIImageView alloc] init];
    
    [self addSubview:self.leftFlag];
    [self.leftFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.rateLbl.mas_left).offset(-10);
        make.centerY.equalTo(self.rateLbl.mas_centerY);
        
    }];
    
    //右边国旗
    self.rightFlag = [[UIImageView alloc] init];
    
    [self addSubview:self.rightFlag];
    [self.rightFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.rateLbl.mas_right).offset(10);
        make.centerY.equalTo(self.rateLbl.mas_centerY);
        
    }];
    
//    //右箭头
//    UIImageView *rightArrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
//
//    [self addSubview:rightArrowIV];
//    [rightArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.centerY.equalTo(self.rateLbl.mas_centerY);
//
//    }];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.rateLbl.mas_bottom).offset(44);
        
    }];
    //计算规则
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    textLbl.numberOfLines = 0;
    textLbl.text = @"计算规则: 采用银行柜台汇率过去14天的平均值作为汇率参考值，在每一个交割结算日，若改平均值与系统当前汇率偏高超过0.2，则会采用新的14天平均值作为系统汇率。";
    textLbl.text = [LangSwitcher switchLang:textLbl.text key:nil];
    [self addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(line.mas_top).offset(17);
        make.left.equalTo(@(15));
        make.right.equalTo(@(-15));
    
    }];
    
    self.textLbl = textLbl;
    
}

- (void)setRateModel:(RateModel *)rateModel {
    
    _rateModel = rateModel;
    
//    if ([rateModel.referCurrency isEqualToString:@"CNY"]) {
//
//    }
    
    NSString *money = [rateModel.currency isEqualToString:@"USD"] ? @"$1": @"HK$1";
    
    NSString *imgStr = [rateModel.currency isEqualToString:@"USD"] ? @"美国国旗": @"香港旗帜";
    
    self.leftFlag.image = kImage(imgStr);
    
    self.rateLbl.text = [NSString stringWithFormat:@"%@≈￥%@", money, [rateModel.rate convertToRealMoneyWithNum:4]];
    
    self.rightFlag.image = kImage(@"中国国旗");
    
    [self layoutSubviews];
    
    rateModel.cellHeight = self.textLbl.yy;
    
}

@end
