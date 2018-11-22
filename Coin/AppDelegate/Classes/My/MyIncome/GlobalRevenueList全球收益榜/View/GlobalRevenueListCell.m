//
//  GlobalRevenueListCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "GlobalRevenueListCell.h"

@implementation GlobalRevenueListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _numberLabel = [UILabel labelWithFrame:CGRectMake(0, 20, 50, 20) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#999999")];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_numberLabel];


        _accountLabel = [UILabel labelWithFrame:CGRectMake(50, 22, 0, 14) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#333333")];
        [_accountLabel sizeToFit];
        [self addSubview:_accountLabel];


        _nameLabel = [UILabel labelWithFrame:CGRectMake(_accountLabel.xx + 10, 11, SCREEN_WIDTH - _accountLabel.xx - 25, 17) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(12) textColor:kHexColor(@"#999999")];
        _nameLabel.text = [LangSwitcher switchLang:@"预估收益" key:nil];
        [self addSubview:_nameLabel];


        _priceLabel = [UILabel labelWithFrame:CGRectMake(_accountLabel.xx + 10, 28, SCREEN_WIDTH - _accountLabel.xx - 25, 20) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#333333")];
        [self addSubview:_priceLabel];

        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(50, 59, SCREEN_WIDTH - 50 - 15 , 1)];
        lineView.backgroundColor = kLineColor;
        [self addSubview:lineView];

    }
    return self;
}

-(void)setTopModel:(MyIncomeTopModel *)topModel
{
    _numberLabel.text = [NSString stringWithFormat:@"%ld",topModel.rank];
    _accountLabel.text = topModel.mobile;
    _accountLabel.frame = CGRectMake(50, 22, 0, 14);
    [_accountLabel sizeToFit];

    NSString *incomeTotal = [CoinUtil convertToRealCoin2:topModel.incomeTotal setScale:4  coin:@"BTC"];

    _priceLabel.text = [NSString stringWithFormat:@"%@ BTC",incomeTotal];

    _nameLabel.frame = CGRectMake(_accountLabel.xx + 10, 11, SCREEN_WIDTH - _accountLabel.xx - 25, 17);
    _priceLabel.frame = CGRectMake(_accountLabel.xx + 10, 28, SCREEN_WIDTH - _accountLabel.xx - 25, 20);
}

@end
