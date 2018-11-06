//
//  DetailCell.m
//  Coin
//
//  Created by shaojianfei on 2018/9/14.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "DetailCell.h"

@implementation DetailCell
{
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *TheValueLabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {


        nameLabel = [UILabel labelWithFrame:CGRectMake(15, 15, (SCREEN_WIDTH - 79)/2, 20) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:[UIColor blackColor]];
        [self addSubview:nameLabel];
        
        timeLabel = [UILabel labelWithFrame:CGRectMake(15, 35, (SCREEN_WIDTH)/2 - 15, 20) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(11) textColor:kTextBlack];
        [self addSubview:timeLabel];
        
//
        TheValueLabel = [UILabel labelWithFrame:CGRectMake( (SCREEN_WIDTH)/2, 15, SCREEN_WIDTH/2 - 15 , 20) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(14) textColor:kTextColor2];
        [self addSubview:TheValueLabel];

        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 69, SCREEN_WIDTH - 20, 1)];
        lineView.backgroundColor = kLineColor;
        [self addSubview:lineView];
        
    }
    return self;
}

-(void)setSendModel:(NSDictionary *)sendModel
{
    //    NSLog(@"%@",getModel);
    nameLabel.text = [NSString stringWithFormat:@"%@",sendModel[@"userNickname"]];
    timeLabel.text = [sendModel[@"createDatetime"] convertRedDate];
    
    
//    CoinModel *coin = [CoinUtil getCoinModel:sendModel[@"symbol"]];

    //    [headImage sd_setImageWithURL:[NSURL URLWithString:[sendModel.sendUserPhoto convertImageUrl]] placeholderImage:kImage(@"普通红包")];
//    priceLabel.text = [NSString stringWithFormat:@"%@ %@",sendModel[@"totalCount"],[LangSwitcher switchLang:@"枚" key:nil]];
    NSString *count = sendModel[@"count"];
    TheValueLabel.text = [NSString stringWithFormat:@"%@枚",@([count floatValue])];
}

@end
