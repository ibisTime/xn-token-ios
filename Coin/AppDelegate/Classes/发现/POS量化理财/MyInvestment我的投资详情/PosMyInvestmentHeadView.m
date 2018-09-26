//
//  PosMyInvestmentHeadView.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "PosMyInvestmentHeadView.h"

@implementation PosMyInvestmentHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

//        UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 160 - 64 + kNavigationBarHeight)];
//        backImage.image = kImage(@"Rectangle 3");
//        [self addSubview:backImage];


        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 0.5, 18, 1, 54)];
        lineView.backgroundColor = kHexColor(@"#BAC1C8");
        [self addSubview:lineView];


        NSArray *priceArray = @[@"99.900(BTC)",@"900.00(BTC)"];
        for (int i = 0; i < 2; i ++) {
            UILabel *peiceLabel = [UILabel labelWithFrame:CGRectMake(0 + i %2 * SCREEN_WIDTH/2,  47, SCREEN_WIDTH/2, 30) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(30) textColor:kWhiteColor];
            NSString *str = priceArray[i];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
            [attrString addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(str.length - 5,5)];
            peiceLabel.attributedText = attrString;
            [peiceLabel sizeToFit];
            if (i == 0) {
                peiceLabel.frame = CGRectMake(SCREEN_WIDTH/4 - peiceLabel.frame.size.width/2,  40, peiceLabel.frame.size.width, 30);

                UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(peiceLabel.frame.origin.x, 15 , peiceLabel.frame.size.width, 18) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kWhiteColor];
                nameLabel.text = [LangSwitcher switchLang:@"投资总资产" key:nil];
                nameLabel.alpha = 0.6;
                [self addSubview:nameLabel];


            }else
            {
                peiceLabel.frame = CGRectMake(SCREEN_WIDTH/4*3 - peiceLabel.frame.size.width/2,  40, peiceLabel.frame.size.width, 30);

                UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(peiceLabel.frame.origin.x, 15 , peiceLabel.frame.size.width, 18) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kWhiteColor];
                nameLabel.text = [LangSwitcher switchLang:@"累计收益" key:nil];
                nameLabel.alpha = 0.6;
                [self addSubview:nameLabel];
            }

            [self addSubview:peiceLabel];
        }

    }
    return self;
}

@end
