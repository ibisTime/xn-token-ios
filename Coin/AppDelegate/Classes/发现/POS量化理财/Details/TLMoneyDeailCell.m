//
//  TLMoneyDeailCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLMoneyDeailCell.h"

@implementation TLMoneyDeailCell
{
    UIImageView *lineImage1;
    UIImageView *lineImage2;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {


        NSArray *nameArray = @[@"起购日",@"产品起息",@"产品结期"];
        for ( int i = 0; i < 3; i ++) {
            UILabel *numberLabel = [UILabel labelWithFrame:CGRectMake(i%3 * kScreenWidth/3 + kScreenWidth/3/2 - 10, 16, 20, 20) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:Font(11) textColor:kHexColor(@"#666666")];
            numberLabel.text = [NSString stringWithFormat:@"%d",i + 1];
            kViewBorderRadius(numberLabel, 10, 1, kHexColor(@"#666666"));
            numberLabel.tag = 222 + i;
            [self addSubview:numberLabel];

            UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(10 + i % 3 *kScreenWidth/3, 46, kScreenWidth/3 - 20, 13) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(12) textColor:kHexColor(@"#666666")];
            nameLabel.text = [LangSwitcher switchLang:nameArray[i] key:nil];
            nameLabel.tag = 333 + i;
            [self addSubview:nameLabel];


            UILabel *timeLabel = [UILabel labelWithFrame:CGRectMake(10 + i % 3 *kScreenWidth/3, 61, kScreenWidth/3 - 20, 12) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:Font(12) textColor:kHexColor(@"#666666")];
//            timeLabel.text = @"2018/9/24";
            timeLabel.tag = 111 + i;
            [self addSubview:timeLabel];

        }
        lineImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/6 + 25, 25, kScreenWidth/3 - 50, 2)];
        lineImage1.image = kImage(@"线 灰色");
        [self addSubview:lineImage1];

        lineImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/6 + 25 + kScreenWidth/3, 25, kScreenWidth/3 - 50, 2)];
        lineImage2.image = kImage(@"线 灰色");
        [self addSubview:lineImage2];




    }
    return self;
}

-(void)setMoneyModel:(TLtakeMoneyModel *)moneyModel
{

    UILabel *label22 = [self viewWithTag:222];
    UILabel *label23 = [self viewWithTag:223];
    UILabel *label24 = [self viewWithTag:224];
    UILabel *label33 = [self viewWithTag:333];
    UILabel *label34 = [self viewWithTag:334];
    UILabel *label35 = [self viewWithTag:335];
    UILabel *label11 = [self viewWithTag:111];
    UILabel *label12 = [self viewWithTag:112];
    UILabel *label13 = [self viewWithTag:113];
    label11.text = [NSString stringWithFormat:@"%@",[moneyModel.startDatetime convertDate]];
    label12.text = [NSString stringWithFormat:@"%@",[moneyModel.incomeDatetime convertDate]];
    label13.text = [NSString stringWithFormat:@"%@",[moneyModel.arriveDatetime convertDate]];

    if ([moneyModel.timeStatus isEqualToString:@"0"]) {
        kViewBorderRadius(label22, 10, 1, kHexColor(@"#666666"));
        kViewBorderRadius(label23, 10, 1, kHexColor(@"#666666"));
        kViewBorderRadius(label24, 10, 1, kHexColor(@"#666666"));
        label22.textColor = kHexColor(@"#666666");
        label23.textColor = kHexColor(@"#666666");
        label24.textColor = kHexColor(@"#666666");
        label33.textColor = kHexColor(@"#666666");
        label34.textColor = kHexColor(@"#666666");
        label35.textColor = kHexColor(@"#666666");
        label11.textColor = kHexColor(@"#666666");
        label12.textColor = kHexColor(@"#666666");
        label13.textColor = kHexColor(@"#666666");
        lineImage1.image = kImage(@"线 灰色");
        lineImage2.image = kImage(@"线 灰色");

    }else if ([moneyModel.timeStatus isEqualToString:@"1"])
    {
        kViewBorderRadius(label22, 10, 1, kHexColor(@"#0064FF"));
        kViewBorderRadius(label23, 10, 1, kHexColor(@"#666666"));
        kViewBorderRadius(label24, 10, 1, kHexColor(@"#666666"));
        label22.textColor = kHexColor(@"#0064FF");
        label23.textColor = kHexColor(@"#666666");
        label24.textColor = kHexColor(@"#666666");
        label33.textColor = kHexColor(@"#0064FF");
        label34.textColor = kHexColor(@"#666666");
        label35.textColor = kHexColor(@"#666666");
        label11.textColor = kHexColor(@"#0064FF");
        label12.textColor = kHexColor(@"#666666");
        label13.textColor = kHexColor(@"#666666");
        lineImage1.image = kImage(@"线 灰色");
        lineImage2.image = kImage(@"线 灰色");
    }else if ([moneyModel.timeStatus isEqualToString:@"2"])
    {
        kViewBorderRadius(label22, 10, 1, kHexColor(@"#0064FF"));
        kViewBorderRadius(label23, 10, 1, kHexColor(@"#0064FF"));
        kViewBorderRadius(label24, 10, 1, kHexColor(@"#666666"));
        label22.textColor = kHexColor(@"#0064FF");
        label23.textColor = kHexColor(@"#0064FF");
        label24.textColor = kHexColor(@"#666666");
        label33.textColor = kHexColor(@"#0064FF");
        label34.textColor = kHexColor(@"#0064FF");
        label35.textColor = kHexColor(@"#666666");
        label11.textColor = kHexColor(@"#0064FF");
        label12.textColor = kHexColor(@"#0064FF");
        label13.textColor = kHexColor(@"#666666");
        lineImage1.image = kImage(@"线 蓝色");
        lineImage2.image = kImage(@"线 灰色");
    }
    else if ([moneyModel.timeStatus isEqualToString:@"3"])
    {
        kViewBorderRadius(label22, 10, 1, kHexColor(@"#0064FF"));
        kViewBorderRadius(label23, 10, 1, kHexColor(@"#0064FF"));
        kViewBorderRadius(label24, 10, 1, kHexColor(@"#0064FF"));
        label22.textColor = kHexColor(@"#0064FF");
        label23.textColor = kHexColor(@"#0064FF");
        label24.textColor = kHexColor(@"#0064FF");
        label33.textColor = kHexColor(@"#0064FF");
        label34.textColor = kHexColor(@"#0064FF");
        label35.textColor = kHexColor(@"#0064FF");
        label11.textColor = kHexColor(@"#0064FF");
        label12.textColor = kHexColor(@"#0064FF");
        label13.textColor = kHexColor(@"#0064FF");
        lineImage1.image = kImage(@"线 蓝色");
        lineImage2.image = kImage(@"线 蓝色");
    }
}

@end
