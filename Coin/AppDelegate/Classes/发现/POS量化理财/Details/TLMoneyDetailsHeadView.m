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
        NSString *str = @"+12.0000%";
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        UIFont *font = [UIFont systemFontOfSize:18];
        [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(str.length - 6,6)];
        priceLabel.attributedText = attrString;
        [self addSubview:priceLabel];

        NSArray *nameArray = @[@"认购期限",@"剩余额度",@"起购额度"];
        for (int i = 0; i < 3 ; i++) {
            UILabel *numberLabel = [UILabel labelWithFrame:CGRectMake(10 + i % 3 * kScreenWidth/3, 235 - 64 + kNavigationBarHeight - 68 + 12, kScreenWidth/3 - 20, 22) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:Font(16) textColor:kHexColor(@"#FFFFFF")];
            numberLabel.text = @"300 ETH";
            [self addSubview:numberLabel];

            UILabel *contactLabel = [UILabel labelWithFrame:CGRectMake(10 + i % 3 * kScreenWidth/3, 235 - 64 + kNavigationBarHeight - 68 + 36, kScreenWidth/3 - 20, 17) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:Font(12) textColor:kHexColor(@"#FFFFFF")];
            contactLabel.text = [LangSwitcher switchLang:nameArray[i] key:nil];
            contactLabel.alpha = 0.7;
            [self addSubview:contactLabel];
        }
    }

    return self;
}

@end
