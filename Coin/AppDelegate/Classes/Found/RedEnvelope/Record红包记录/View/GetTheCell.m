//
//  GetTheCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "GetTheCell.h"

@implementation GetTheCell
{
    UIImageView *headImage;
    UILabel *nameLabel;
    UIButton *typeimage;

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
        headImage.layer.cornerRadius = 20;
        headImage.clipsToBounds = YES;


        nameLabel = [UILabel labelWithFrame:CGRectMake(65, 18, 0, 20) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:[UIColor blackColor]];
        [self addSubview:nameLabel];

        typeimage = [[UIButton alloc ] init];
        typeimage.titleLabel.font = FONT(11);

        typeimage.layer.borderColor = [UIColor redColor].CGColor;
        typeimage.layer.borderWidth = 1.0;

        [self addSubview:typeimage];


        timeLabel = [UILabel labelWithFrame:CGRectMake(65, 38, 0, 14) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(11) textColor:kTextBlack];
//        timeLabel.text = @"06-12 wfdsa";
        [self addSubview:timeLabel];



        sysmbolImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 130), 17, 36, 36)];
        [self addSubview:sysmbolImage];

        priceLabel = [UILabel labelWithFrame:CGRectMake(kScreenWidth - (SCREEN_WIDTH - 79)/3, 17, (SCREEN_WIDTH - 79)/4, 36) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(16) textColor:kTextColor];
//        priceLabel.text = @"来自  王小二";
        [self addSubview:priceLabel];

      


        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 69, SCREEN_WIDTH - 20, 1)];
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
    [nameLabel sizeToFit];
    nameLabel.frame = CGRectMake(65, 18, nameLabel.frame.size.width, 20);

    timeLabel.text = [getModel.createDatetime convertRedDate];
    [timeLabel sizeToFit];
    timeLabel.frame = CGRectMake(65, 38, timeLabel.frame.size.width, 14);

    typeimage.frame = CGRectMake(nameLabel.xx + 4, 18, 20, 20);

    if ([redPacketInfo[@"type"] isEqualToString:@"1"]) {
        //拼手气
        [typeimage setTitle:[LangSwitcher switchLang:@"拼" key:nil] forState:UIControlStateNormal];
        [typeimage setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [typeimage setBackgroundColor:[UIColor redColor] forState:UIControlStateNormal];

    }
    else
    {
        //普通
        [typeimage setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [typeimage setBackgroundColor:kWhiteColor forState:UIControlStateNormal];
        [typeimage setTitle:[LangSwitcher switchLang:@"普" key:nil] forState:UIControlStateNormal];

    }



    [headImage sd_setImageWithURL:[NSURL URLWithString:[redPacketInfo[@"sendUserPhoto"] convertImageUrl ] ] placeholderImage:kImage(@"头像")];
    
    CoinModel *coin = [CoinUtil getCoinModel:redPacketInfo[@"symbol"]];


    if (self.isClose == YES) {
        priceLabel.text = [NSString stringWithFormat:@"**** %@",[LangSwitcher switchLang:@"枚" key:nil]];
    }else{

        priceLabel.text = [NSString stringWithFormat:@"%@ %@",[CoinUtil mult1:getModel.count mult2:@"1" scale:4],[LangSwitcher switchLang:@"枚" key:nil]];
    }

    [priceLabel sizeToFit];
    priceLabel.frame = CGRectMake(kScreenWidth - priceLabel.frame.size.width - 15, 17, priceLabel.frame.size.width, 36);

    [sysmbolImage sd_setImageWithURL:[NSURL URLWithString:[coin.pic1 convertImageUrl ]] placeholderImage:kImage(@"")];
//    if (priceLabel.width < ) {
//        <#statements#>
//    }
    sysmbolImage.frame = CGRectMake(SCREEN_WIDTH - priceLabel.frame.size.width - 15 - 5 - 36, 17, 36, 36);



}
@end
