//
//  PosMyInvestmentDetailsCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "PosMyInvestmentDetailsCell.h"

@implementation PosMyInvestmentDetailsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        lineView.backgroundColor = kBackgroundColor;
        [self addSubview:lineView];

        UILabel *timeLabel = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH, 10, 0, 45) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(13) textColor:kHexColor(@"#999999")];
        timeLabel.text = @"2018/10/21到期";
        [timeLabel sizeToFit];
        timeLabel.frame = CGRectMake(SCREEN_WIDTH - 15 - timeLabel.frame.size.width, 10, timeLabel.frame.size.width, 45);
        [self addSubview:timeLabel];

        UIButton *nameButton = [UIButton buttonWithTitle:@"蓝潮基金ETH增长型5期蓝潮基金ETH增长型5期蓝潮基金ETH增长型5期" titleColor:kHexColor(@"#464646") backgroundColor:kClearColor titleFont:14];
        nameButton.frame = CGRectMake(15, 10, SCREEN_WIDTH - timeLabel.frame.size.width - 30 - 10, 45);
        [nameButton SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:4 imagePositionBlock:^(UIButton *button) {
            [nameButton setImage:kImage(@"已持有") forState:(UIControlStateNormal)];
        }];
        [self addSubview:nameButton];

        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(15, 55, kScreenWidth - 30, 1)];
        lineView1.backgroundColor = kLineColor;
        [self addSubview:lineView1];


        UILabel *numberLabel = [UILabel labelWithFrame:CGRectMake(25, 72, 0, 22) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(22) textColor:kHexColor(@"#FF6400")];
        numberLabel.text = @"9.4ETH";
        [numberLabel sizeToFit];
        [self addSubview:numberLabel];

        UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(25, 102, numberLabel.frame.size.width, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:kHexColor(@"#999999")];
        nameLabel.text = [LangSwitcher switchLang:@"预计收益" key:nil];
        [self addSubview:nameLabel];

        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(numberLabel.xx + 38, 75, 1, 39)];
        line.backgroundColor = kLineColor;
        
        [self addSubview:line];


        UILabel *shareLabel = [UILabel labelWithFrame:CGRectMake(line.xx + 22, 77, SCREEN_WIDTH -line.xx - 22 -15, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#464646")];
        NSString *shareStr1 = [LangSwitcher switchLang:@"持有份额" key:nil];
        NSString *shareStr2 = [NSString stringWithFormat:@"%@  760ETH",[LangSwitcher switchLang:@"持有份额" key:nil]];
        NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:shareStr2];
        [attriStr addAttribute:NSForegroundColorAttributeName value:kHexColor(@"#999999") range:NSMakeRange(0, shareStr1.length)];
        shareLabel.attributedText = attriStr;
        [self addSubview:shareLabel];




        UILabel *earningsLabel = [UILabel labelWithFrame:CGRectMake(line.xx + 22, 101, SCREEN_WIDTH -line.xx - 22 - 15, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#464646")];
        NSString *earningsLabel1 = [LangSwitcher switchLang:@"预期年化收益" key:nil];
        NSString *str = @"9.6%";
        NSString *earningsLabel2 = [NSString stringWithFormat:@"%@  %@",[LangSwitcher switchLang:@"持有份额" key:nil],str];
        NSMutableAttributedString * attriStr1 = [[NSMutableAttributedString alloc] initWithString:earningsLabel2];
        [attriStr1 addAttribute:NSForegroundColorAttributeName value:kHexColor(@"#999999") range:NSMakeRange(0, earningsLabel1.length)];
        earningsLabel.attributedText = attriStr1;
        [self addSubview:earningsLabel];


    }
    return self;
}

@end
