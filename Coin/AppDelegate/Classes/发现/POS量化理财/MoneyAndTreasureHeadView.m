//
//  MoneyAndTreasureHeadView.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "MoneyAndTreasureHeadView.h"

@implementation MoneyAndTreasureHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 160 - 64 + kNavigationBarHeight)];
        backImage.image = kImage(@"bijiabao");
        [self addSubview:backImage];


        UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(0, kNavigationBarHeight + 10, kScreenWidth, 20) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:Font(14) textColor:kHexColor(@"#FFFFFF")];
        nameLabel.text = [LangSwitcher switchLang:@"投资总额" key:nil];
        [self addSubview:nameLabel];


        UIButton *eyesButton = [UIButton buttonWithTitle:@"≈ 0.000023 BTC" titleColor:kHexColor(@"#FFFFFF") backgroundColor:kClearColor titleFont:30];
        eyesButton.frame = CGRectMake(15, kNavigationBarHeight + 29, kScreenWidth - 30, 42);
        [eyesButton SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:15 imagePositionBlock:^(UIButton *button) {
            [button setImage:kImage(@"眼睛") forState:(UIControlStateNormal)];
        }];
        [self addSubview:eyesButton];




    }
    return self;
}

@end
