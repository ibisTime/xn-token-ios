//
//  TLMoneyDetailsHeadView.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLMoneyDetailsHeadView.h"

@implementation TLMoneyDetailsHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {


        UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 235 - 64 + kNavigationBarHeight)];
        self.backImage = backImage;
        backImage.image = kImage(@"bijiabao");
        [self addSubview:backImage];


        UIImageView *backImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 235 - 64 + kNavigationBarHeight - 68, kScreenWidth, 68)];
        backImage1.image = kImage(@"Rectangle 11");
        backImage1.alpha = 0.5;
        [self addSubview:backImage1];


        UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(0, kNavigationBarHeight + 10, kScreenWidth, 20) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:Font(14) textColor:kHexColor(@"#FFFFFF")];
        nameLabel.text = [LangSwitcher switchLang:@"预期年化收益率" key:nil];
        [self addSubview:nameLabel];

        UILabel *priceLabel =[UILabel labelWithFrame:CGRectMake(15, kNavigationBarHeight + 25, kScreenWidth - 30, 60) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:Font(45) textColor:kHexColor(@"#FFFFFF")];
        self.priceLabel = priceLabel;
        [self addSubview:priceLabel];

        NSArray *nameArray = @[@"认购期限",@"剩余额度",@"起购额度"];
        for (int i = 0; i < 3 ; i++) {
            UILabel *numberLabel = [UILabel labelWithFrame:CGRectMake(10 + i % 3 * kScreenWidth/3, 235 - 64 + kNavigationBarHeight - 68 + 12, kScreenWidth/3 - 20, 22) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:Font(16) textColor:kHexColor(@"#FFFFFF")];
            numberLabel.tag = 1000 + i;
//            numberLabel.text = @"300 ETH";
            [self addSubview:numberLabel];

            UILabel *contactLabel = [UILabel labelWithFrame:CGRectMake(10 + i % 3 * kScreenWidth/3, 235 - 64 + kNavigationBarHeight - 68 + 36, kScreenWidth/3 - 20, 17) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:Font(12) textColor:kHexColor(@"#FFFFFF")];
            contactLabel.text = [LangSwitcher switchLang:nameArray[i] key:nil];
            contactLabel.alpha = 0.7;

            [self addSubview:contactLabel];
        }
    }

    return self;
}

-(void)setMoneyModel:(TLtakeMoneyModel *)moneyModel
{

    NSString *str = [NSString stringWithFormat:@"+%.4f%%",[moneyModel.expectYield floatValue]*100];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    UIFont *font = [UIFont systemFontOfSize:20];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(str.length - 6,6)];
    self.priceLabel.attributedText = attrString;

    UILabel *label1 = [self viewWithTag:1000];
    UILabel *label2 = [self viewWithTag:1001];
    UILabel *label3 = [self viewWithTag:1002];
    label1.text = [NSString stringWithFormat:@"%@%@",moneyModel.limitDays,[LangSwitcher switchLang:@"天" key:nil]];

    NSString *avilAmount = [CoinUtil convertToRealCoin:moneyModel.avilAmount coin:moneyModel.symbol];
    if ([avilAmount floatValue] > 10000) {
        label2.text = [NSString stringWithFormat:@"%.2f万 %@",[avilAmount floatValue]/10000,moneyModel.symbol];
    }
    else
    {
        label2.text = [NSString stringWithFormat:@"%.2f %@",[avilAmount floatValue],moneyModel.symbol];
    }

    NSString *minAmount = [CoinUtil convertToRealCoin:moneyModel.minAmount coin:moneyModel.symbol];

    if ([minAmount floatValue] > 10000) {
        label3.text = [NSString stringWithFormat:@"%.2f万 %@",[minAmount floatValue]/10000,moneyModel.symbol];
    }
    else
    {
        label3.text = [NSString stringWithFormat:@"%.2f %@",[minAmount floatValue],moneyModel.symbol];
    }




}

@end
