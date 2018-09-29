//
//  PosBuyBalanceCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "PosBuyBalanceCell.h"

@implementation PosBuyBalanceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(25, 0, kScreenWidth - 140, 60) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:Font(13) textColor:kHexColor(@"#666666")];
        self.nameLabel = nameLabel;

        [self addSubview:nameLabel];


        UIButton *intoButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"转入资金" key:nil] titleColor:kHexColor(@"#0064FF") backgroundColor:kClearColor titleFont:13];
        self.intoButton = intoButton;
        intoButton.frame = CGRectMake(kScreenWidth - 100, 15, 85, 30);
        kViewBorderRadius(intoButton, 15, 1, kHexColor(@"#0064FF"));
        [self addSubview:intoButton];
    }
    return self;
}

-(void)setCurrencys:(CurrencyModel *)currencys
{
//    NSString *text = currencys.amountString;

    NSString *name = [LangSwitcher switchLang:@"可用余额:" key:nil];
//    currencys.currency];

    NSString *leftAmount = [CoinUtil convertToRealCoin:currencys.amountString coin:currencys.currency];
    NSString *rightAmount = [CoinUtil convertToRealCoin:currencys.frozenAmountString coin:currencys.currency];
    NSString *ritAmount = [leftAmount subNumber:rightAmount];
    NSString *str1 = [NSString stringWithFormat:@" %.2f ",[ritAmount doubleValue]];


    NSString *str = [NSString stringWithFormat:@"%@ %@ %@",[LangSwitcher switchLang:@"可用余额:" key:nil],str1,currencys.currency];

    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    UIFont *font = [UIFont systemFontOfSize:20];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(name.length,str1.length)];
    self.nameLabel.attributedText = attrString;

}

@end
