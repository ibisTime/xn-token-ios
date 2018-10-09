//
//  MyInconmeCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "MyInconmeCell.h"

@implementation MyInconmeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _numberLabel = [UILabel labelWithFrame:CGRectMake(15, 20, 50, 20) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#999999")];
        [self addSubview:_numberLabel];


        _accountLabel = [UILabel labelWithFrame:CGRectMake(66, 23, 0, 14) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#333333")];
        _accountLabel.text = @"7571**@hotmail.com";
//        _accountLabel.backgroundColor = [UIColor redColor];
        [_accountLabel sizeToFit];
        [self addSubview:_accountLabel];


        _nameLabel = [UILabel labelWithFrame:CGRectMake(_accountLabel.xx + 10, 11, SCREEN_WIDTH - _accountLabel.xx - 25, 17) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(12) textColor:kHexColor(@"#999999")];
        _nameLabel.text = @"预估收益";
        [self addSubview:_nameLabel];


        _priceLabel = [UILabel labelWithFrame:CGRectMake(_accountLabel.xx + 10, 28, SCREEN_WIDTH - _accountLabel.xx - 25, 20) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#333333")];
        _priceLabel.text = @"31.0001 BTC";
        [self addSubview:_priceLabel];

        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(66, 59, SCREEN_WIDTH - 66 - 15 , 1)];
        lineView.backgroundColor = kLineColor;
        [self addSubview:lineView];

    }
    return self;
}

@end
