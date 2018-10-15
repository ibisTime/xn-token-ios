//
//  GlobalRevenueListHeadCell.m
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "GlobalRevenueListHeadCell.h"

@implementation GlobalRevenueListHeadCell
{
    UIImageView *onePhotoImage;
    UILabel *onePriceLabel;
    UILabel *oneMobileLabel;

    UIImageView *twePhotoImage;
    UILabel *tweMobileLabel;
    UILabel *twePriceLabel;

    UIImageView *therePhotoImage;
    UILabel *thereMobileLabel;
    UILabel *therePriceLabel;


}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400 - 64 + kNavigationBarHeight)];
        backImage.image = kImage(@"全球收益榜背景");
        [self addSubview:backImage];

        [self oneCustomView];
        [self tweCustomView];
        [self thereCustomView];



    }
    return self;
}

-(void)oneCustomView
{
    onePhotoImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40 + 3, 108 - 64 + kNavigationBarHeight + 13, 74, 74)];
    onePhotoImage.image = kImage(@"头像");
    kViewRadius(onePhotoImage , 74/2);
    [self addSubview:onePhotoImage];

    UIImageView *oneImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, 108 - 64 + kNavigationBarHeight, 80, 90 + 12.5)];
    oneImage.image = kImage(@"第一名");
    [self addSubview:oneImage];


    UILabel *oneNameLabel = [UILabel labelWithFrame:CGRectMake(kWidth(115) + 5, 292 - 64 + kNavigationBarHeight , kWidth(148) - 10, 17) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(11) textColor:kHexColor(@"#FFFFFF")];
    oneNameLabel.alpha = 0.6;
    oneNameLabel.text = [NSString stringWithFormat:@"%@(BTC)",[LangSwitcher switchLang:@"预估收益" key:nil]];
    [self addSubview:oneNameLabel];

    onePriceLabel = [UILabel labelWithFrame:CGRectMake(kWidth(115) + 5, 292 - 64 + kNavigationBarHeight + 18, kWidth(148) - 10, 28) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(20) textColor:kHexColor(@"#FFFFFF")];
    onePriceLabel.text = @"≈0.0";
    [self addSubview:onePriceLabel];


    UIButton *oneShareButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"他的分享" key:nil] titleColor:kHexColor(@"#FFFFFF") backgroundColor:RGB(10, 84, 200) titleFont:11];
    oneShareButton.frame = CGRectMake(SCREEN_WIDTH/2 - kWidth(35), 292 - 64 + kNavigationBarHeight + 55, kWidth(100) - kWidth(30), 22);
    kViewRadius(oneShareButton, 11);
    oneShareButton.alpha = 0.6;
    [self addSubview:oneShareButton];


    oneMobileLabel = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2 - kWidth(73), 222 - 64 + kNavigationBarHeight, kWidth(73) * 2, 17) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(12) textColor:kHexColor(@"#FFFFFF")];
    oneMobileLabel.text = @"";
    [self addSubview:oneMobileLabel];
}

-(void)tweCustomView
{

    twePhotoImage = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(65) - 30 + 3, 163 - 64 + kNavigationBarHeight + 3, 54, 54)];
    twePhotoImage.image = kImage(@"头像");
    [self addSubview:twePhotoImage];


    UIImageView *tweImage = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(65) - 30, 163 - 64 + kNavigationBarHeight, 60, 60 + 12.5)];
    tweImage.image = kImage(@"第二名");
    [self addSubview:tweImage];

    tweMobileLabel = [UILabel labelWithFrame:CGRectMake(kWidth(15), 246 - 64 + kNavigationBarHeight, kWidth(100) , 17) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(12) textColor:kHexColor(@"#FFFFFF")];
    tweMobileLabel.text = @"";
    [self addSubview:tweMobileLabel];


    UILabel *tweNameLabel = [UILabel labelWithFrame:CGRectMake(kWidth(15) + 5, 309 - 64 + kNavigationBarHeight, kWidth(100) - 10, 17) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(11) textColor:kHexColor(@"#FFFFFF")];
    tweNameLabel.alpha = 0.6;
    tweNameLabel.text = [NSString stringWithFormat:@"%@(BTC)",[LangSwitcher switchLang:@"预估收益" key:nil]];
    [self addSubview:tweNameLabel];

    twePriceLabel = [UILabel labelWithFrame:CGRectMake(kWidth(15) + 5, 309 - 64 + kNavigationBarHeight + 19, kWidth(100) - 10, 22) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kHexColor(@"#FFFFFF")];
    twePriceLabel.text = @"≈0.0";
    [self addSubview:twePriceLabel];


    UIButton *tweShareButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"他的分享" key:nil] titleColor:kHexColor(@"#FFFFFF") backgroundColor:RGB(10, 84, 200) titleFont:11];
    tweShareButton.frame = CGRectMake(kWidth(30), 309 - 64 + kNavigationBarHeight + 47, kWidth(100) - kWidth(30), 22);
    kViewRadius(tweShareButton, 11);
    tweShareButton.alpha = 0.6;
    [self addSubview:tweShareButton];
}

-(void)thereCustomView
{
    therePhotoImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - kWidth(65)  - 30 + 3, 163 - 64 + kNavigationBarHeight + 3, 54, 54)];
    therePhotoImage.image = kImage(@"头像");
    [self addSubview:therePhotoImage];

    UIImageView *thereImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - kWidth(65)  - 30, 163 - 64 + kNavigationBarHeight, 60, 60 + 12.5)];
    thereImage.image = kImage(@"第三名");
    [self addSubview:thereImage];

    thereMobileLabel = [UILabel labelWithFrame:CGRectMake(kWidth(246) + kWidth(15), 246 - 64 + kNavigationBarHeight, kWidth(100) , 17) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(12) textColor:kHexColor(@"#FFFFFF")];
    thereMobileLabel.text = @"";
    [self addSubview:thereMobileLabel];

    UILabel *thereNameLabel = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH - kWidth(115) + 5, 320 - 64 + kNavigationBarHeight, kWidth(100) - 10, 17) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(11) textColor:kHexColor(@"#FFFFFF")];
    thereNameLabel.alpha = 0.6;
    thereNameLabel.text = [NSString stringWithFormat:@"%@(BTC)",[LangSwitcher switchLang:@"预估收益" key:nil]];
    [self addSubview:thereNameLabel];

    therePriceLabel = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH - kWidth(115) + 5, 320 - 64 + kNavigationBarHeight + 15, kWidth(100) - 10, 22) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(16) textColor:kHexColor(@"#FFFFFF")];
    therePriceLabel.text = @"≈0.0";
    [self addSubview:therePriceLabel];


    UIButton *thereShareButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"他的分享" key:nil] titleColor:kHexColor(@"#FFFFFF") backgroundColor:RGB(10, 84, 200) titleFont:11];
    thereShareButton.frame = CGRectMake(SCREEN_WIDTH - kWidth(100), 320 - 64 + kNavigationBarHeight + 39, kWidth(100) - kWidth(30), 22);
    kViewRadius(thereShareButton, 11);
    thereShareButton.alpha = 0.6;
    [self addSubview:thereShareButton];
}

-(void)setTopModel:(NSMutableArray<MyIncomeTopModel *> *)topModel
{
    if (topModel.count > 0) {
        MyIncomeTopModel *model = topModel[0];
//        onePhotoImage
//        oneNameLabel.text =

        if ([TLUser isBlankString:model.photo] == YES) {
            onePhotoImage.image = kImage(@"头像");
        }else
        {
            [onePhotoImage sd_setImageWithURL:[NSURL URLWithString:[model.photo convertImageUrl]] placeholderImage:kImage(@"头像")];
        }

        NSString *incomeTotal = [CoinUtil convertToRealCoin2:model.incomeTotal setScale:4  coin:@"BTC"];
        onePriceLabel.text = [NSString stringWithFormat:@"%@ BTC",incomeTotal];
        oneMobileLabel.text = model.mobile;

    }
    if (topModel.count > 1)
    {

        MyIncomeTopModel *model = topModel[1];
        //        onePhotoImage
        //        oneNameLabel.text =

        if ([TLUser isBlankString:model.photo] == YES) {
            twePhotoImage.image = kImage(@"头像");
        }else
        {
            [twePhotoImage sd_setImageWithURL:[NSURL URLWithString:[model.photo convertImageUrl]] placeholderImage:kImage(@"头像")];
        }

        NSString *incomeTotal = [CoinUtil convertToRealCoin2:model.incomeTotal setScale:4  coin:@"BTC"];
        twePriceLabel.text = [NSString stringWithFormat:@"%@ BTC",incomeTotal];
        tweMobileLabel.text = model.mobile;
    }
    if (topModel.count > 2)
    {

        MyIncomeTopModel *model = topModel[2];
        //        onePhotoImage
        //        oneNameLabel.text =

        if ([TLUser isBlankString:model.photo] == YES) {
            therePhotoImage.image = kImage(@"头像");
        }else
        {
            [therePhotoImage sd_setImageWithURL:[NSURL URLWithString:[model.photo convertImageUrl]] placeholderImage:kImage(@"头像")];
        }

        NSString *incomeTotal = [CoinUtil convertToRealCoin2:model.incomeTotal setScale:4  coin:@"BTC"];
        therePriceLabel.text = [NSString stringWithFormat:@"%@ BTC",incomeTotal];
        thereMobileLabel.text = model.mobile;
    }


}



@end
