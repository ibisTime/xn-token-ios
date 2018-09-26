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
        NSString *name = [LangSwitcher switchLang:@"可用余额:" key:nil];
        NSString *str = [NSString stringWithFormat:@"%@ 3000.00 ETC",[LangSwitcher switchLang:@"可用余额:" key:nil]];

        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        UIFont *font = [UIFont systemFontOfSize:20];
        [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(name.length,8)];
        nameLabel.attributedText = attrString;
        [self addSubview:nameLabel];


        UIButton *intoButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"转入资金" key:nil] titleColor:kHexColor(@"#0064FF") backgroundColor:kClearColor titleFont:13];
        intoButton.frame = CGRectMake(kScreenWidth - 100, 15, 85, 30);
        kViewBorderRadius(intoButton, 15, 1, kHexColor(@"#0064FF"));
        [self addSubview:intoButton];
    }
    return self;
}

@end
