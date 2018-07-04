//
//  GetTheCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "GetTheCell.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"
@implementation GetTheCell
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
//        nameLabel.text = @"来自  王小二";
        [self addSubview:nameLabel];

        timeLabel = [UILabel labelWithFrame:CGRectMake(63, 36, (SCREEN_WIDTH - 79)/2, 14) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(11) textColor:kTextBlack];
//        timeLabel.text = @"06-12 wfdsa";
        [self addSubview:timeLabel];


        priceLabel = [UILabel labelWithFrame:CGRectMake(63 + (SCREEN_WIDTH - 79)/2, 16, (SCREEN_WIDTH - 79)/2, 20) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(16) textColor:kPaleBlueColor];
//        priceLabel.text = @"来自  王小二";
        [self addSubview:priceLabel];

        TheValueLabel = [UILabel labelWithFrame:CGRectMake(63 + (SCREEN_WIDTH - 79)/2, 36, (SCREEN_WIDTH - 79)/2 , 14) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(11) textColor:RGB(173, 186, 192)];
//        TheValueLabel.text = @"06-12 wfdsa";
        [self addSubview:TheValueLabel];


        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 65, SCREEN_WIDTH - 20, 1)];
        lineView.backgroundColor = kLineColor;
        [self addSubview:lineView];

    }
    return self;
}

-(void)setGetModel:(GetTheModel *)getModel
{
    NSLog(@"%@",getModel);
    NSDictionary *redPacketInfo = getModel.redPacketInfo;
    nameLabel.text = [NSString stringWithFormat:@"来自 %@",redPacketInfo[@"sendUserNickname"]];
    timeLabel.text = getModel.createDatetime;

    [headImage sd_setImageWithURL:[NSURL URLWithString:[redPacketInfo[@"sendUserPhoto"] convertImageUrl ]]];
    priceLabel.text = [NSString stringWithFormat:@"%@ %@",redPacketInfo[@"receivedNum"],redPacketInfo[@"symbol"]];
    TheValueLabel.text = [NSString stringWithFormat:@"价值%@元",redPacketInfo[@"totalCountCNY"]];
}
@end
