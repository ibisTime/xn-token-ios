//
//  TLMoneyDeailCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLMoneyDeailCell.h"

@implementation TLMoneyDeailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {


        NSArray *nameArray = @[@"起购日",@"产品起息",@"产品结期"];
        for ( int i = 0; i < 3; i ++) {
            UILabel *numberLabel = [UILabel labelWithFrame:CGRectMake(i%3 * kScreenWidth/3 + kScreenWidth/3/2 - 10, 16, 20, 20) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:Font(11) textColor:kHexColor(@"#0064FF")];
            numberLabel.text = [NSString stringWithFormat:@"%d",i + 1];
            kViewBorderRadius(numberLabel, 10, 1, kHexColor(@"#0064FF"));
            [self addSubview:numberLabel];

            UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(10 + i % 3 *kScreenWidth/3, 46, kScreenWidth/3 - 20, 12) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(12) textColor:kHexColor(@"#0064FF")];
            nameLabel.text = [LangSwitcher switchLang:nameArray[i] key:nil];
            [self addSubview:nameLabel];


            UILabel *timeLabel = [UILabel labelWithFrame:CGRectMake(10 + i % 3 *kScreenWidth/3, 61, kScreenWidth/3 - 20, 12) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:Font(12) textColor:kHexColor(@"#0064FF")];
            timeLabel.text = @"2018/9/24";
            [self addSubview:timeLabel];

        }


        UIImageView *lineImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/6 + 25, 25, kScreenWidth/3 - 50, 2)];
        lineImage1.image = kImage(@"Group 连串点 4px 1 Copy 7");
        [self addSubview:lineImage1];

        UIImageView *lineImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/6 + 25 + kScreenWidth/3, 25, kScreenWidth/3 - 50, 2)];
        lineImage2.image = kImage(@"Group 连串点 4px 1 Copy 7");
        [self addSubview:lineImage2];




    }
    return self;
}

@end
