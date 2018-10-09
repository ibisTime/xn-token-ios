//
//  MoneyAndTreasureHeadView.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/29.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "MoneyAndTreasureHeadView.h"

@implementation MoneyAndTreasureHeadView
{
    NSDictionary *dic;
}
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


        UIButton *eyesButton = [UIButton buttonWithTitle:@"BTC" titleColor:kHexColor(@"#FFFFFF") backgroundColor:kClearColor titleFont:30];
        eyesButton.frame = CGRectMake(15, kNavigationBarHeight + 29, kScreenWidth - 30, 42);
        [eyesButton SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:15 imagePositionBlock:^(UIButton *button) {
            [button setImage:kImage(@"张眼") forState:(UIControlStateNormal)];
            [button setImage:kImage(@"闭眼-白") forState:(UIControlStateSelected)];
        }];

        NSString *eyesWhetherhide = [[NSUserDefaults standardUserDefaults] objectForKey:@"eyesWhetherhide"];
        if ([eyesWhetherhide isEqualToString:@"闭眼"]) {
            eyesButton.selected = YES;
        }else
        {
            eyesButton.selected = NO;
        }

        [eyesButton addTarget:self action:@selector(eyesButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        self.eyesButton = eyesButton;
        [self addSubview:eyesButton];
    }
    return self;
}

-(void)eyesButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [[NSUserDefaults standardUserDefaults]setObject:@"闭眼" forKey:@"eyesWhetherhide"];
    }else
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"张眼" forKey:@"eyesWhetherhide"];
    }

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSString *str = [numberFormatter stringFromNumber:dic[@"totalInvest"]];
    NSString *totalInvest = [CoinUtil convertToRealCoin:str coin:@"BTC"];
    //    self.eyesButton.backgroundColor = [UIColor redColor];
    NSString *eyesWhetherhide = [[NSUserDefaults standardUserDefaults] objectForKey:@"eyesWhetherhide"];
    if ([eyesWhetherhide isEqualToString:@"闭眼"]) {
        [self.eyesButton setTitle:@"**** BTC" forState:(UIControlStateNormal)];
    }else
    {

        [self.eyesButton setTitle:[NSString stringWithFormat:@"≈ %.1f BTC",[totalInvest floatValue]] forState:(UIControlStateNormal)];
    }

    [self.eyesButton SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:15 imagePositionBlock:^(UIButton *button) {
        [button setImage:kImage(@"张眼") forState:(UIControlStateNormal)];
        [button setImage:kImage(@"闭眼-白") forState:(UIControlStateSelected)];
    }];
}

-(void)setDataDic:(NSDictionary *)dataDic
{
    dic = dataDic;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSString *str = [numberFormatter stringFromNumber:dataDic[@"totalInvest"]];
    NSString *totalInvest = [CoinUtil convertToRealCoin:str coin:@"BTC"];
    //    self.eyesButton.backgroundColor = [UIColor redColor];

    NSString *eyesWhetherhide = [[NSUserDefaults standardUserDefaults] objectForKey:@"eyesWhetherhide"];
    if ([eyesWhetherhide isEqualToString:@"闭眼"]) {
        [self.eyesButton setTitle:@"**** BTC" forState:(UIControlStateNormal)];
    }else
    {

        if ([totalInvest floatValue] > 10000) {
            [self.eyesButton setTitle:[NSString stringWithFormat:@"≈ %.2f%@ BTC",[totalInvest floatValue]/10000,[LangSwitcher switchLang:@"万" key:nil]] forState:(UIControlStateNormal)];
        }else
        {
            [self.eyesButton setTitle:[NSString stringWithFormat:@"≈ %.2f BTC",[totalInvest floatValue]] forState:(UIControlStateNormal)];
        }
    }

    [self.eyesButton SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:15 imagePositionBlock:^(UIButton *button) {
        [button setImage:kImage(@"张眼") forState:(UIControlStateNormal)];
        [button setImage:kImage(@"闭眼-白") forState:(UIControlStateSelected)];
    }];


}

@end
