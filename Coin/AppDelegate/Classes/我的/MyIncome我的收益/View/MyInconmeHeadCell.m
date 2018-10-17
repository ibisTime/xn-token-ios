//
//  MyInconmeHeadCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "MyInconmeHeadCell.h"

@implementation MyInconmeHeadCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 0.5, 18, 1, 54)];
        lineView.backgroundColor = kHexColor(@"#BAC1C8");
        [self addSubview:lineView];

        self.backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.backButton.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 160 - 64);
        [self addSubview:self.backButton];

        for (int i = 0; i < 2; i ++) {
            UILabel *peiceLabel = [UILabel labelWithFrame:CGRectMake(0 + i %2 * SCREEN_WIDTH/2,  47, SCREEN_WIDTH/2, 30) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(30) textColor:kWhiteColor];

            peiceLabel.tag = 1212 + i;

            if (i == 0) {
                peiceLabel.frame = CGRectMake(SCREEN_WIDTH/4 - peiceLabel.frame.size.width/2,  40, peiceLabel.frame.size.width, 30);

                UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(0, 0 , 0, 0) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(13) textColor:kWhiteColor];
                nameLabel.text = [LangSwitcher switchLang:@"昨日收益" key:nil];
                self.nameLabel = nameLabel;
                nameLabel.alpha = 0.6;
                [self addSubview:nameLabel];


            }else
            {
                peiceLabel.frame = CGRectMake(SCREEN_WIDTH/4*3 - peiceLabel.frame.size.width/2,  40, peiceLabel.frame.size.width, 30);

                UIButton *earningsButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"获得总收益" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:13];
                self.earningsButton = earningsButton;
                earningsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                earningsButton.alpha = 0.6;
                [self addSubview:earningsButton];


            }

            [self addSubview:peiceLabel];
        }
    }
    return self;
}

-(void)setModel:(MyIncomeModel *)model
{
//    NSLog(@"%@",dataDic);
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    NSString *incomeYesterday = [CoinUtil convertToRealCoin:model.incomeYesterday coin:@"BTC"];

    NSString *incomeYesterday = [CoinUtil convertToRealCoin2:model.incomeYesterday setScale:4  coin:@"BTC"];



    UILabel *label1 = [self viewWithTag:1212];

    NSString *label1Str = [NSString stringWithFormat:@"≈%@(BTC)",incomeYesterday];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:label1Str];
    [attrString addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(label1Str.length - 5,5)];
    label1.attributedText = attrString;

    [label1 sizeToFit];

    if (label1.frame.size.width > SCREEN_WIDTH/2 - 20) {
        label1.frame = CGRectMake(10,  40, SCREEN_WIDTH/2 - 20, 30);
    }else
    {
        label1.frame = CGRectMake(SCREEN_WIDTH/4 - label1.frame.size.width/2,  40, label1.frame.size.width, 30);
    }


    self.nameLabel.frame = CGRectMake(label1.frame.origin.x, 15 , SCREEN_WIDTH/2 - label1.frame.origin.x - 10, 18);



    NSString *incomeTotal = [CoinUtil convertToRealCoin2:model.incomeTotal setScale:4  coin:@"BTC"];
    UILabel *label2 = [self viewWithTag:1213];
    NSString *label2Str = [NSString stringWithFormat:@"≈%@(BTC)",incomeTotal];
    NSMutableAttributedString *attrString1 = [[NSMutableAttributedString alloc] initWithString:label2Str];
    [attrString1 addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(label2Str.length - 5,5)];
    label2.attributedText = attrString1;
    [label2 sizeToFit];
    if (label2.frame.size.width > SCREEN_WIDTH/2 - 20) {
        label2.frame = CGRectMake(10 + SCREEN_WIDTH/2,  40, SCREEN_WIDTH/2 - 20, 30);
    }else
    {
        label2.frame = CGRectMake(SCREEN_WIDTH/4*3 - label2.frame.size.width/2,  40, label2.frame.size.width, 30);
    }
    self.earningsButton.frame = CGRectMake(label2.frame.origin.x, 15 , SCREEN_WIDTH - label2.frame.origin.x - 10, 18);
}


@end
