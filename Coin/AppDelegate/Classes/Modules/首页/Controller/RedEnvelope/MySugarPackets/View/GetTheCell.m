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
#import "NSString+Date.h"
#import "CoinUtil.h"
@implementation GetTheCell
{
    UIImageView *headImage;
    UILabel *nameLabel;
    UIImageView *typeimage;

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
//        nameLabel.text = @"来自  王小二";
        [self addSubview:nameLabel];

        typeimage = [[UIImageView alloc ] initWithFrame:CGRectMake(kWidth(120), 16, 20, 20)];
        typeimage.contentMode = UIViewContentModeScaleToFill;
        //        nameLabel.text = @"来自  王小二";
        [self addSubview:typeimage];
        timeLabel = [UILabel labelWithFrame:CGRectMake(63, 36, (SCREEN_WIDTH - 79)/2, 14) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(11) textColor:kTextBlack];
//        timeLabel.text = @"06-12 wfdsa";
        [self addSubview:timeLabel];

        sysmbolImage = [[UIImageView alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH - 120), 16, 36, 36)];
        [self addSubview:sysmbolImage];

        priceLabel = [UILabel labelWithFrame:CGRectMake(kScreenWidth - (SCREEN_WIDTH - 79)/3, 16, (SCREEN_WIDTH - 79)/4, 36) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(16) textColor:kTextColor];
//        priceLabel.text = @"来自  王小二";
        [self addSubview:priceLabel];

      


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
    nameLabel.text = [NSString stringWithFormat:@"%@",redPacketInfo[@"sendUserNickname"]];
    timeLabel.text = [getModel.createDatetime convertRedDate];
    if ([redPacketInfo[@"type"] isEqualToString:@"1"]) {
        //拼手气
        typeimage.image = kImage(@"拼手气红包 copy");
    }else{
        //普通
        typeimage.image = kImage(@" 普通红包");

       
    }
    [headImage sd_setImageWithURL:[NSURL URLWithString:[redPacketInfo[@"sendUserPhoto"] convertImageUrl ] ] placeholderImage:kImage(@"头像")];
    
    CoinModel *coin = [CoinUtil getCoinModel:redPacketInfo[@"symbol"]];
     [sysmbolImage sd_setImageWithURL:[NSURL URLWithString:[coin.pic1 convertImageUrl ] ] placeholderImage:kImage(@"头像")];
    priceLabel.text = [NSString stringWithFormat:@"%@ %@",getModel.count,[LangSwitcher switchLang:@"枚" key:nil]];
//    TheValueLabel.text = [NSString stringWithFormat:@"≈%@元",redPacketInfo[@"totalCountCNY"]];
}
@end
