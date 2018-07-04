//
//  SendCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/7/3.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "SendCell.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"
@implementation SendCell
{
    UIImageView *headImage;
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *priceLabel;
    UILabel *TheValueLabel;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headImage = [[UIImageView alloc]initWithFrame:CGRectMake(14, 16, 34, 34)];
        [self addSubview:headImage];

        nameLabel = [UILabel labelWithFrame:CGRectMake(63, 16, (SCREEN_WIDTH - 79)/2, 20) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:[UIColor blackColor]];
        [self addSubview:nameLabel];

        timeLabel = [UILabel labelWithFrame:CGRectMake(63, 36, (SCREEN_WIDTH - 79)/2, 14) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(11) textColor:kTextBlack];
        [self addSubview:timeLabel];


        priceLabel = [UILabel labelWithFrame:CGRectMake(63 + (SCREEN_WIDTH - 79)/2, 16, (SCREEN_WIDTH - 79)/2, 20) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(16) textColor:kPaleBlueColor];
        [self addSubview:priceLabel];

        TheValueLabel = [UILabel labelWithFrame:CGRectMake(63 + (SCREEN_WIDTH - 79)/2, 36, (SCREEN_WIDTH - 79)/2 , 14) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(11) textColor:RGB(173, 186, 192)];
        [self addSubview:TheValueLabel];


        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 65, SCREEN_WIDTH - 20, 1)];
        lineView.backgroundColor = kLineColor;
        [self addSubview:lineView];

    }
    return self;
}

-(void)setSendModel:(SendModel *)sendModel
{
//    NSLog(@"%@",getModel);
    nameLabel.text = [NSString stringWithFormat:@"来自 %@",sendModel.sendUserNickname];
    timeLabel.text = sendModel.createDateTime;

    [headImage sd_setImageWithURL:[NSURL URLWithString:[sendModel.sendUserPhoto convertImageUrl]]];
    priceLabel.text = [NSString stringWithFormat:@"%@ %@",sendModel.totalCount,sendModel.symbol];
    TheValueLabel.text = [NSString stringWithFormat:@"价值%@元",sendModel.totalCountCNY];
}
@end
