//
//  StrategyCell.m
//  Coin
//
//  Created by 郑勤宝 on 2018/12/4.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "StrategyCell.h"

@implementation StrategyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(25, 0, SCREEN_WIDTH - 32.5 - 10 - 25, 40) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#000000")];
        nameLabel.text = @"攻略攻略攻略攻略攻略攻略攻略攻略攻略攻略攻略攻略攻略攻略攻略攻略";
        [self addSubview:nameLabel];
        
        UIImageView *youImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 32.5, 12.5, 7.5, 15)];
        youImage.image = kImage(@"更多拷贝");
        [self addSubview:youImage];
        
        
        UIView *lineView= [[UIView alloc]initWithFrame:CGRectMake(15, 39, SCREEN_WIDTH - 30, 1)];
        lineView.backgroundColor = kLineColor;
        [self addSubview:lineView];
        
    }
    return self;
}


@end
