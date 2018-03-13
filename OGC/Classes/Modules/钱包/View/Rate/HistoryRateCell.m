//
//  HistoryRateCell.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/30.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "HistoryRateCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "NSString+Date.h"
#import "NSNumber+Extension.h"

@interface HistoryRateCell ()

//汇率
@property (nonatomic, strong) UILabel *rateLbl;
//日期
@property (nonatomic, strong) UILabel *dateLbl;

@end

@implementation HistoryRateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //日期
    self.dateLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16.0];
    
    self.dateLbl.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.dateLbl];
    [self.dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX).offset(-(kScreenWidth/4.0));
        make.centerY.equalTo(@0);
        
    }];
    
    //汇率
    self.rateLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16.0];
    
    self.rateLbl.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.rateLbl];
    [self.rateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX).offset((kScreenWidth/4.0));
        make.centerY.equalTo(@0);

    }];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.right.equalTo(@(0));
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@(-0.5));
        
    }];
    
}

- (void)setRateModel:(HistoryRateModel *)rateModel {
    
    _rateModel = rateModel;
    
    self.dateLbl.text = [rateModel.updateDatetime convertDate];
    
    self.rateLbl.text = [rateModel.rate convertToRealMoneyWithNum:4];
}

@end
