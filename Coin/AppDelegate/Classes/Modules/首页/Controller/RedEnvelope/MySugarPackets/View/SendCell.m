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
#import "NSString+Date.h"
#import "CoinUtil.h"
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
        headImage = [[UIImageView alloc]initWithFrame:CGRectMake(14, 16, 34, 34)];
        [self addSubview:headImage];
        headImage.layer.cornerRadius = 17;
        headImage.clipsToBounds = YES;
        nameLabel = [UILabel labelWithFrame:CGRectMake(63, 16, (SCREEN_WIDTH - 79)/2, 20) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:[UIColor blackColor]];
        [self addSubview:nameLabel];

        timeLabel = [UILabel labelWithFrame:CGRectMake(63, 36, (SCREEN_WIDTH - 79)/2, 24) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(11) textColor:kTextBlack];
        [self addSubview:timeLabel];


        priceLabel = [UILabel labelWithFrame:CGRectMake(63 + (SCREEN_WIDTH - 79)/2, 10, (SCREEN_WIDTH - 79)/2, 36) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(16) textColor:kTextBlack];
        [self addSubview:priceLabel];
        sysmbolImage = [[UIImageView alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH - 100), 16, 36, 36)];
        [self addSubview:sysmbolImage];

        TheValueLabel = [UILabel labelWithFrame:CGRectMake(63 + (SCREEN_WIDTH - 79)/2, 46, (SCREEN_WIDTH - 79)/2 , 14) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(11) textColor:kTextColor2];
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
    //    [headImage sd_setImageWithURL:[NSURL URLWithString:[sendModel.sendUserPhoto convertImageUrl]] placeholderImage:kImage(@"普通红包")];
    if (self.isClose == YES) {
          priceLabel.text = [NSString stringWithFormat:@"**** %@",[LangSwitcher switchLang:@"枚" key:nil]];
    }else{
          priceLabel.text = [NSString stringWithFormat:@"%@ %@",sendModel.receivedCount,[LangSwitcher switchLang:@"枚" key:nil]];
    }
  
    TheValueLabel.text = [NSString stringWithFormat:@"%@/%@个",sendModel.receivedNum,sendModel.sendNum];
}
@end
