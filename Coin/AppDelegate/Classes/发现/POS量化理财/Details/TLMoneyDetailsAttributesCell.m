//
//  TLMoneyDetailsAttributesCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLMoneyDetailsAttributesCell.h"

@implementation TLMoneyDetailsAttributesCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLabel = [UILabel labelWithFrame:CGRectMake(15, 15, kScreenWidth - 30, 22) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(16) textColor:kHexColor(@"#464646")];
        titleLabel.text = [LangSwitcher switchLang:@"产品属性" key:nil];
        [self addSubview:titleLabel];


        NSArray *nameArray = @[@"认购币种：",@"收益方式：年化收益",@"产品总额度："];
        for (int i = 0; i < 3 ; i ++) {
            UIView *pointView = [[UIView alloc]initWithFrame:CGRectMake(15, 55 + i % 3 * 28,  4, 4)];
            kViewRadius(pointView, 2);
            pointView.backgroundColor = kHexColor(@"#464646");
            [self addSubview:pointView];


            UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(30, 47 + i%3 * 27, kScreenWidth - 45, 20) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:Font(14) textColor:kHexColor(@"#333333")];
            nameLabel.text = [LangSwitcher switchLang:nameArray[i] key:nil];
            nameLabel.tag = 2000+i;
            [self addSubview:nameLabel];
        }
    }
    return self;
}

-(void)setMoneyModel:(TLtakeMoneyModel *)moneyModel
{
    UILabel *label1 = [self viewWithTag:2000];
    UILabel *label2 = [self viewWithTag:2001];
    UILabel *label3 = [self viewWithTag:2002];
    label1.text = [NSString stringWithFormat:@"%@%@",[LangSwitcher switchLang:@"认购币种：" key:nil],moneyModel.symbol];
//    label2.text = [NSString stringWithFormat:@"认购币种：%@",moneyModel.symbol]

    NSString *amount = [CoinUtil convertToRealCoin:moneyModel.amount coin:moneyModel.symbol];
    if ([amount floatValue] > 10000) {
        label3.text = [NSString stringWithFormat:@"%@%.2f%@ %@",[LangSwitcher switchLang:@"产品总额度：" key:nil],[amount floatValue]/10000,[LangSwitcher switchLang:@"万" key:nil],moneyModel.symbol];
    }
    else
    {
        label3.text = [NSString stringWithFormat:@"%@%.2f %@",[LangSwitcher switchLang:@"产品总额度：" key:nil],[amount floatValue],moneyModel.symbol];
    }

}

@end
