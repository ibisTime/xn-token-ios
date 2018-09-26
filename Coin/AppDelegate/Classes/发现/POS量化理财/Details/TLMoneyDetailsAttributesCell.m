//
//  TLMoneyDetailsAttributesCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLMoneyDetailsAttributesCell.h"

@implementation TLMoneyDetailsAttributesCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLabel = [UILabel labelWithFrame:CGRectMake(15, 15, kScreenWidth - 30, 22) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(16) textColor:kHexColor(@"#464646")];
        titleLabel.text = [LangSwitcher switchLang:@"产品属性" key:nil];
        [self addSubview:titleLabel];


        NSArray *nameArray = @[@"认购币种：ETH",@"收益方式：年化收益",@"产品总额度：300ETH"];
        for (int i = 0; i < 3 ; i ++) {
            UIView *pointView = [[UIView alloc]initWithFrame:CGRectMake(15, 55 + i % 3 * 28,  4, 4)];
            kViewRadius(pointView, 2);
            pointView.backgroundColor = kHexColor(@"#464646");
            [self addSubview:pointView];


            UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(30, 47 + i%3 * 27, kScreenWidth - 45, 20) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:Font(14) textColor:kHexColor(@"#333333")];
            nameLabel.text = [LangSwitcher switchLang:nameArray[i] key:nil];
            [self addSubview:nameLabel];
        }
    }
    return self;
}

@end
