//
//  DetailCell.m
//  Coin
//
//  Created by shaojianfei on 2018/9/14.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "DetailCell.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"
#import "NSString+Date.h"
#import "CoinUtil.h"
#import "TLUser.h"
@implementation DetailCell
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
        nameLabel = [UILabel labelWithFrame:CGRectMake(15, 16, (SCREEN_WIDTH - 79)/2, 20) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:[UIColor blackColor]];
        [self addSubview:nameLabel];
        
        timeLabel = [UILabel labelWithFrame:CGRectMake(15, 36, (SCREEN_WIDTH - 79)/2, 24) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(11) textColor:kTextBlack];
        [self addSubview:timeLabel];
        
        
        priceLabel = [UILabel labelWithFrame:CGRectMake(63 + (SCREEN_WIDTH - 79)/2, 10, (SCREEN_WIDTH - 79)/2, 36) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(16) textColor:kTextBlack];
        [self addSubview:priceLabel];
        sysmbolImage = [[UIImageView alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH - 100), 16, 36, 36)];
        [self addSubview:sysmbolImage];
        
        TheValueLabel = [UILabel labelWithFrame:CGRectMake(63 + (SCREEN_WIDTH - 79)/2, 16, (SCREEN_WIDTH - 79)/2 , 14) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(14) textColor:kTextColor2];
        [self addSubview:TheValueLabel];
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 65, SCREEN_WIDTH - 20, 1)];
        lineView.backgroundColor = kLineColor;
        [self addSubview:lineView];
        
    }
    return self;
}

-(void)setSendModel:(NSDictionary *)sendModel
{
    //    NSLog(@"%@",getModel);
    nameLabel.text = [NSString stringWithFormat:@"%@",[TLUser user].nickname];
    timeLabel.text = [sendModel[@"createDatetime"] convertRedDate] ;
    
    
    CoinModel *coin = [CoinUtil getCoinModel:sendModel[@"symbol"]];
 
    //    [headImage sd_setImageWithURL:[NSURL URLWithString:[sendModel.sendUserPhoto convertImageUrl]] placeholderImage:kImage(@"普通红包")];
//    priceLabel.text = [NSString stringWithFormat:@"%@ %@",sendModel[@"totalCount"],[LangSwitcher switchLang:@"枚" key:nil]];
    NSString *count = sendModel[@"count"];
    TheValueLabel.text = [NSString stringWithFormat:@"%@枚",@([count floatValue])];
}

@end
