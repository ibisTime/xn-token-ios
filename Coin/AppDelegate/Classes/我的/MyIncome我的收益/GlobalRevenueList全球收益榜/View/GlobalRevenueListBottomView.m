//
//  GlobalRevenueListBottomView.m
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "GlobalRevenueListBottomView.h"

@implementation GlobalRevenueListBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = kWhiteColor;
        UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        headImage.image = kImage(@"头像");
        [self addSubview:headImage];

        UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(70, 19.5, 0, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:kHexColor(@"#999999")];
        nameLabel.text = @"我的137****1878";
        [nameLabel sizeToFit];
        [self addSubview:nameLabel];

        UILabel *earningsLabel = [UILabel labelWithFrame:CGRectMake(nameLabel.xx + 10, 17, SCREEN_WIDTH - 25 - nameLabel.xx, 17) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(12) textColor:kHexColor(@"#999999")];
        earningsLabel.text = [LangSwitcher switchLang:@"预估收益" key:nil];
        [self addSubview:earningsLabel];

        UILabel *rankingLabel = [UILabel labelWithFrame:CGRectMake(70, 38, 0, 14) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#333333")];
        rankingLabel.text = @"排名100名以外，加油";
        [rankingLabel sizeToFit];
        [self addSubview:rankingLabel];

        UILabel *priceLabel = [UILabel labelWithFrame:CGRectMake(rankingLabel.xx + 10, 35, SCREEN_WIDTH - 25 - rankingLabel.xx, 20) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#999999")];
        priceLabel.text = @"0.0032 BTC";
        [self addSubview:priceLabel];

    }
    return self;
}

@end
