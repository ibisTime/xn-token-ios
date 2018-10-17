//
//  AccumulatedEarningsCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/27.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "AccumulatedEarningsCell.h"

@implementation AccumulatedEarningsCell
{
    UILabel *nameLabel;
    UILabel *priceLabel;
    UILabel *timeLabel;
    UILabel *balanceLabel;

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        nameLabel = [UILabel labelWithFrame:CGRectMake(15, 15, 0, 20) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(15) textColor:kHexColor(@"#464646")];
        nameLabel.text = @"";
        [self addSubview:nameLabel];

        priceLabel = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH, 17.5, 0, 15) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(15) textColor:kHexColor(@"#FF8000")];
        priceLabel.text = @"";

        [self addSubview:priceLabel];




        timeLabel = [UILabel labelWithFrame:CGRectMake(15, 45, 0, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:Font(12) textColor:kHexColor(@"#999999")];
        [self addSubview:timeLabel];


        balanceLabel = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2, 41, SCREEN_WIDTH/2 - 15, 20) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:Font(12) textColor:kHexColor(@"#464646")];
        [self addSubview:balanceLabel];

        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 78, SCREEN_WIDTH - 30, 0.5)];
        lineView.backgroundColor = kLineColor;
        [self addSubview:lineView];
    }
    return self;
}


-(void)setModel:(AccumulatedEarningsModel *)model
{
    nameLabel.text = [NSString stringWithFormat:@"%@",model.productName];
    NSString *transAmountString = [CoinUtil convertToRealCoin1:model.transAmountString coin:model.currency];

    if ([transAmountString floatValue] >= 0) {
        priceLabel.text = [NSString stringWithFormat:@"+%@ %@",transAmountString,model.currency];
        priceLabel.textColor = kHexColor(@"#FF8000");
    }else
    {
        priceLabel.text = [NSString stringWithFormat:@"%@ %@",transAmountString,model.currency];
        priceLabel.textColor = kHexColor(@"#46AAAF");
    }
    [priceLabel sizeToFit];
    priceLabel.frame = CGRectMake(SCREEN_WIDTH - 15 - priceLabel.frame.size.width, 17.5, priceLabel.frame.size.width, 15);
    nameLabel.frame = CGRectMake(15, 15, SCREEN_WIDTH - 30 - 10 - priceLabel.frame.size.width, 20);

    timeLabel.text = [model.createDatetime convertDate];
    [timeLabel sizeToFit];

    NSString *postAmountString = [CoinUtil convertToRealCoin1:model.postAmountString coin:model.currency];

    balanceLabel.text = [NSString stringWithFormat:@"%@:%@%@",[LangSwitcher switchLang:@"余额" key:nil],postAmountString,model.currency];
    balanceLabel.frame = CGRectMake(timeLabel.xx + 10, 41,SCREEN_WIDTH -  timeLabel.xx - 10 - 15, 20);
}

@end
