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
        self.timeLabel = timeLabel;
        timeLabel.text = @"";

        [self addSubview:timeLabel];

        UIButton *nameButton = [UIButton buttonWithTitle:@"" titleColor:kHexColor(@"#464646") backgroundColor:kClearColor titleFont:14];
        self.nameButton = nameButton;
        nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:nameButton];

        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(15, 55, kScreenWidth - 30, 1)];
        lineView1.backgroundColor = kLineColor;
        [self addSubview:lineView1];


        UILabel *numberLabel = [UILabel labelWithFrame:CGRectMake(25, 72, 0, 22) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(22) textColor:kHexColor(@"#FF6400")];
        numberLabel.text = @"9.4ETH";
        self.numberLabel = numberLabel;

        [self addSubview:numberLabel];

        UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(25, 102, numberLabel.frame.size.width, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:kHexColor(@"#999999")];
        self.nameLabel = nameLabel;
        nameLabel.text = [LangSwitcher switchLang:@"预计收益" key:nil];
        [self addSubview:nameLabel];

        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(numberLabel.xx + 38, 75, 1, 39)];
        line.backgroundColor = kLineColor;
        self.line = line;
        [self addSubview:line];


        UILabel *shareLabel = [UILabel labelWithFrame:CGRectMake(line.xx + 22, 77, SCREEN_WIDTH -line.xx - 22 -15, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#464646")];
        self.shareLabel = shareLabel;

        [self addSubview:shareLabel];




        UILabel *earningsLabel = [UILabel labelWithFrame:CGRectMake(line.xx + 22, 101, SCREEN_WIDTH -line.xx - 22 - 15, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#464646")];
        self.earningsLabel = earningsLabel;

        [self addSubview:earningsLabel];


    }
    return self;
}

-(void)setModel:(PosMyInvestmentModel *)model
{

    self.timeLabel.text= [NSString stringWithFormat:@"%@%@",[model.productInfo[@"arriveDatetime"] convertDate],[LangSwitcher switchLang:@"到期" key:nil]];
    [self.timeLabel sizeToFit];
    self.timeLabel.frame = CGRectMake(SCREEN_WIDTH - 15 - self.timeLabel.frame.size.width, 10, self.timeLabel.frame.size.width, 45);
    switch ([LangSwitcher currentLangType]) {
        case LangTypeEnglish:
            [self.nameButton setTitle:model.productInfo[@"nameEn"] forState:(UIControlStateNormal)];
            break;
        case LangTypeKorean:
            [self.nameButton setTitle:model.productInfo[@"nameKo"] forState:(UIControlStateNormal)];

            break;
        case LangTypeSimple:
            [self.nameButton setTitle:model.productInfo[@"nameZhCn"] forState:(UIControlStateNormal)];
            break;

        default:
            break;
    }
    self.nameButton.frame = CGRectMake(15, 10, SCREEN_WIDTH - self.timeLabel.frame.size.width - 30 - 10, 45);
    if ([model.status integerValue] == 1) {
        [self.nameButton SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:4 imagePositionBlock:^(UIButton *button) {
            [button setImage:kImage(@"已持有") forState:(UIControlStateNormal)];
        }];
    }

    NSString *expectIncome = [CoinUtil convertToRealCoin:model.expectIncome coin:model.productInfo[@"symbol"]];

    if ([expectIncome floatValue] > 10000) {
        self.numberLabel.text = [NSString stringWithFormat:@"%.1f万%@",[expectIncome floatValue]/10000,model.productInfo[@"symbol"]];
    }else
    {
        self.numberLabel.text = [NSString stringWithFormat:@"%.1f%@",[expectIncome floatValue],model.productInfo[@"symbol"]];
    }

    [self.numberLabel sizeToFit];
    self.nameLabel.frame = CGRectMake(25, 102, self.numberLabel.frame.size.width, 12);
    self.line.frame = CGRectMake(self.numberLabel.xx + 38, 75, 1, 39);
    self.shareLabel.frame = CGRectMake(self.line.xx + 22, 77, SCREEN_WIDTH - self.line.xx - 22 -15, 12);
    self.earningsLabel.frame =  CGRectMake(self.line.xx + 22, 101, SCREEN_WIDTH -self.line.xx - 22 - 15, 12);


    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSString *avmountStr = [numberFormatter stringFromNumber:model.productInfo[@"saleAmount"]];
    NSString *avmount = [CoinUtil convertToRealCoin:avmountStr coin:model.productInfo[@"symbol"]];
    NSString *shareStr1 = [LangSwitcher switchLang:@"持有份额" key:nil];
    NSString *shareStr2 = [NSString stringWithFormat:@"%@  %.1f%@",[LangSwitcher switchLang:@"持有份额" key:nil],[avmount floatValue],model.productInfo[@"symbol"]];
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:shareStr2];
    [attriStr addAttribute:NSForegroundColorAttributeName value:kHexColor(@"#999999") range:NSMakeRange(0, shareStr1.length)];
    self.shareLabel.attributedText = attriStr;

    NSString *earningsLabel1 = [LangSwitcher switchLang:@"预期年化收益" key:nil];

    NSString *str = [NSString stringWithFormat:@"%.2f%%",[model.productInfo[@"expectYield"] floatValue]*100];
    NSString *earningsLabel2 = [NSString stringWithFormat:@"%@  %@",[LangSwitcher switchLang:@"预期年化收益" key:nil],str];
    NSMutableAttributedString * attriStr1 = [[NSMutableAttributedString alloc] initWithString:earningsLabel2];
    [attriStr1 addAttribute:NSForegroundColorAttributeName value:kHexColor(@"#999999") range:NSMakeRange(0, earningsLabel1.length)];
    self.earningsLabel.attributedText = attriStr1;

}

@end
