//
//  SendCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/7/3.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "SendCell.h"

@implementation SendCell
{
    UIImageView *headImage;
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *priceLabel;
    UILabel *TheValueLabel;
    UIImageView *sysmbolImage;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
        [self addSubview:headImage];
        headImage.layer.cornerRadius = 17;
        headImage.clipsToBounds = YES;
        nameLabel = [UILabel labelWithFrame:CGRectMake(63, 18, (SCREEN_WIDTH - 79)/2, 20) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:[UIColor blackColor]];
        [self addSubview:nameLabel];

        timeLabel = [UILabel labelWithFrame:CGRectMake(63, 38, (SCREEN_WIDTH - 79)/2, 14) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(11) textColor:kTextBlack];
        [self addSubview:timeLabel];


        priceLabel = [UILabel labelWithFrame:CGRectMake(0, 18, 0, 20) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(14) textColor:kTextBlack];
        [self addSubview:priceLabel];

        sysmbolImage = [[UIImageView alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH - 110), 15, 40, 40)];
        [self addSubview:sysmbolImage];

        TheValueLabel = [UILabel labelWithFrame:CGRectMake(63 + (SCREEN_WIDTH - 79)/2, 38, (SCREEN_WIDTH - 79)/2 , 14) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(11) textColor:kTextColor2];
        [self addSubview:TheValueLabel];


        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 69, SCREEN_WIDTH - 20, 1)];
        lineView.backgroundColor = kLineColor;
        [self addSubview:lineView];

    }
    return self;
}

-(void)setSendModel:(SendModel *)sendModel
{
//    NSLog(@"%@",getModel);
    nameLabel.text = [NSString stringWithFormat:@"%@",[LangSwitcher switchLang:@"我自己" key:nil]];
    timeLabel.text = [sendModel.createDateTime convertRedDate] ;

    if ([sendModel.type isEqualToString:@"1"]) {
        //拼手气
        headImage.image = kImage(@"拼手气红包 copy");
    }else{
        //普通
        headImage.image = kImage(@"普通红包-1");
        
        
    }
    
    CoinModel *coin = [CoinUtil getCoinModel:sendModel.symbol];
    [sysmbolImage sd_setImageWithURL:[NSURL URLWithString:[coin.pic1 convertImageUrl ] ] placeholderImage:kImage(@"头像")];

    if (self.isClose == YES) {
          priceLabel.text = [NSString stringWithFormat:@"**** %@",[LangSwitcher switchLang:@"枚" key:nil]];
    }else{
          priceLabel.text = [NSString stringWithFormat:@"%@ %@",sendModel.totalCount,[LangSwitcher switchLang:@"枚" key:nil]];
    }
    [priceLabel sizeToFit];
    priceLabel.frame = CGRectMake(kScreenWidth - priceLabel.frame.size.width - 15, 18, priceLabel.frame.size.width, 20);

    sysmbolImage.frame = CGRectMake(SCREEN_WIDTH - priceLabel.frame.size.width - 15 - 10 - 40, 15, 40, 40);
  
    TheValueLabel.text = [NSString stringWithFormat:@"%@/%@个",sendModel.receivedNum,sendModel.sendNum];
    [TheValueLabel sizeToFit];
    TheValueLabel.frame = CGRectMake(SCREEN_WIDTH - TheValueLabel.frame.size.width - 15, 38, TheValueLabel.frame.size.width , 14);
}
@end
