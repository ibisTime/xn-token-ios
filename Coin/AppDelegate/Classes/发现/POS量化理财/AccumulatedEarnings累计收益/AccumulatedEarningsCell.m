//
//  AccumulatedEarningsCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/27.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "AccumulatedEarningsCell.h"

@implementation AccumulatedEarningsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(15, 15, 0, 20) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(15) textColor:kHexColor(@"#464646")];
        nameLabel.text = @"蓝潮基金ETH增长型3期蓝潮基金ETH增长型3期蓝潮基金ETH增长型3期蓝潮基金ETH增长型3期蓝潮基金ETH增长型3期蓝潮基金ETH增长型3期蓝潮基金ETH增长型3期";
        [self addSubview:nameLabel];

        UILabel *priceLabel = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH, 17.5, 0, 15) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(15) textColor:kHexColor(@"#FF8000")];
        priceLabel.text = @"+ 0.0009 BTC";
        [priceLabel sizeToFit];
        [self addSubview:priceLabel];

        priceLabel.frame = CGRectMake(SCREEN_WIDTH - 15 - priceLabel.frame.size.width, 17.5, priceLabel.frame.size.width, 15);
        nameLabel.frame = CGRectMake(15, 15, SCREEN_WIDTH - 30 - 10 - priceLabel.frame.size.width, 20);


        UILabel *timeLabel = [UILabel labelWithFrame:CGRectMake(15, 41, SCREEN_WIDTH/2 - 15, 20) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:Font(12) textColor:kHexColor(@"#999999")];
        timeLabel.text = @"2018/9/17";
        [self addSubview:timeLabel];


        UILabel *balanceLabel = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2, 41, SCREEN_WIDTH/2 - 15, 20) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:Font(12) textColor:kHexColor(@"#464646")];
        balanceLabel.text = @"余额:9.03BTC";
        [self addSubview:balanceLabel];

        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 78, SCREEN_WIDTH - 30, 0.5)];
        lineView.backgroundColor = kLineColor;
        [self addSubview:lineView];
    }
    return self;
}

@end
