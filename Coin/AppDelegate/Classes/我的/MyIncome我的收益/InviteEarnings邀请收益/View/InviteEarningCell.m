//
//  InviteEarningCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "InviteEarningCell.h"

@implementation InviteEarningCell
{
    CAGradientLayer *layer;
    UILabel *stateLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        layer = [CAGradientLayer new];

        layer.startPoint = CGPointMake(0, 0);
        layer.masksToBounds = YES;
        layer.cornerRadius = 2;
        layer.endPoint = CGPointMake(1, 1);
        [self.layer addSublayer:layer];

        stateLabel = [UILabel labelWithFrame:CGRectMake(15, 22, 30, 16) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(10) textColor:kWhiteColor];

        [self addSubview:stateLabel];

        self.mobile = [UILabel labelWithFrame:CGRectMake(stateLabel.xx + 6, 0, (SCREEN_WIDTH - stateLabel.xx - 6 - 10 - 15)/2, 60) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(15) textColor:kHexColor(@"#333333")];
        [self addSubview:self.mobile];

        self.priceLabel = [UILabel labelWithFrame:CGRectMake(self.mobile.xx + 10, 0, (SCREEN_WIDTH - stateLabel.xx - 6 - 10 - 15)/2, 60) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(15) textColor:kHexColor(@"#333333")];
        [self addSubview:self.priceLabel];

        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 59, SCREEN_WIDTH - 30, 1)];
        lineView.backgroundColor = kLineColor;
        [self addSubview:lineView];


    }
    return self;
}

-(void)setModel:(InviteEarningsModel *)model
{
    self.mobile.text = model.bizNote;
    NSString *transAmountString = [CoinUtil convertToRealCoin:model.transAmountString coin:model.currency];
    if ([transAmountString floatValue] >= 0) {
        self.priceLabel.text = [NSString stringWithFormat:@"+%@ %@",transAmountString,model.currency];
    }else
    {
        self.priceLabel.text = [NSString stringWithFormat:@"%@ %@",transAmountString,model.currency];
    }
}

-(void)setRow:(NSInteger)row
{
    layer.frame = CGRectMake(15, 22, 30, 16);
    if (row == 0) {
        layer.colors=@[(__bridge id)kHexColor(@"#FFC832").CGColor,(__bridge id)kHexColor(@"#FF6400").CGColor];
        stateLabel.text = [LangSwitcher switchLang:@"量化" key:nil];
    }else if (row == 1)
    {
        layer.colors=@[(__bridge id)kHexColor(@"#FF2A68").CGColor,(__bridge id)kHexColor(@"#FF5E3A").CGColor];
        stateLabel.text = [LangSwitcher switchLang:@"抽奖" key:nil];

    }else
    {
        layer.colors=@[(__bridge id)kHexColor(@"#0848DF").CGColor,(__bridge id)kHexColor(@"#3389FF").CGColor];
        stateLabel.text = [LangSwitcher switchLang:@"邀请" key:nil];
    }
}

@end
