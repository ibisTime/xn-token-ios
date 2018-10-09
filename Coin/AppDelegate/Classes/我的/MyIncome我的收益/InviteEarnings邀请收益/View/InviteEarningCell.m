//
//  InviteEarningCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "InviteEarningCell.h"

@implementation InviteEarningCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *mobile = [UILabel labelWithFrame:CGRectMake(15, 0, SCREEN_WIDTH/2 - 15, 60) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(15) textColor:kHexColor(@"#333333")];
        mobile.text = @"6hh****s@hotmai.com";
        [self addSubview:mobile];

        UILabel *priceLabel = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2 - 15, 60) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(15) textColor:kHexColor(@"#333333")];
        priceLabel.text = @"+29.0088 BTC";
        [self addSubview:priceLabel];

        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 59, SCREEN_WIDTH - 30, 1)];
        lineView.backgroundColor = kLineColor;
        [self addSubview:lineView];


    }
    return self;
}

@end
