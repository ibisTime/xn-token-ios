//
//  GlobalRevenueListBottomView.m
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "GlobalRevenueListBottomView.h"

@implementation GlobalRevenueListBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = kWhiteColor;
        UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        headImage.image = kImage(@"头像");
        self.headImage = headImage;
        kViewRadius(headImage, 25);
        [self addSubview:headImage];

        UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(70, 19.5, 0, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:kHexColor(@"#999999")];
//        nameLabel.text = @"我的137****1878";
        self.nameLabel = nameLabel;
        [nameLabel sizeToFit];
        [self addSubview:nameLabel];

        UILabel *earningsLabel = [UILabel labelWithFrame:CGRectMake(nameLabel.xx + 10, 17, SCREEN_WIDTH - 25 - nameLabel.xx, 17) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(12) textColor:kHexColor(@"#999999")];
        earningsLabel.text = [LangSwitcher switchLang:@"预估收益" key:nil];
        self.earningsLabel = earningsLabel;
        [self addSubview:earningsLabel];

        UILabel *rankingLabel = [UILabel labelWithFrame:CGRectMake(70, 38, 0, 14) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#333333")];
//        rankingLabel.text = @"排名100名以外，加油";
        [rankingLabel sizeToFit];
        self.rankingLabel = rankingLabel;
        [self addSubview:rankingLabel];

        UILabel *priceLabel = [UILabel labelWithFrame:CGRectMake(rankingLabel.xx + 10, 35, SCREEN_WIDTH - 25 - rankingLabel.xx, 20) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#999999")];
//        priceLabel.text = @"0.0032 BTC";
        self.priceLabel = priceLabel;
        [self addSubview:priceLabel];

    }
    return self;
}

-(void)setModel:(MyIncomeTopModel *)model
{

    if ([TLUser isBlankString:model.photo] == YES) {
        _headImage.image = kImage(@"头像");
    }else
    {
        [_headImage sd_setImageWithURL:[NSURL URLWithString:[model.photo convertImageUrl]] placeholderImage:kImage(@"头像")];
    }
    _nameLabel.text = model.mobile;
    _nameLabel.frame = CGRectMake(70, 19.5, 0, 12);
    [_nameLabel sizeToFit];

    self.earningsLabel.frame = CGRectMake(_nameLabel.xx + 10, 17, SCREEN_WIDTH - 25 - _nameLabel.xx, 17);
    if (model.rank == 0) {
        _rankingLabel.text = [LangSwitcher switchLang:@"排名100名以外，加油" key:nil];
    }else
    {
        _rankingLabel.text = [NSString stringWithFormat:@"%@ NO.%ld",[LangSwitcher switchLang:@"排名" key:nil],model.rank];
    }

    _rankingLabel.frame = CGRectMake(70, 38, 0, 14);
    [_rankingLabel sizeToFit];

    _priceLabel.frame = CGRectMake(_rankingLabel.xx + 10, 35, SCREEN_WIDTH - 25 - _rankingLabel.xx, 20);

    NSString *incomeTotal = [CoinUtil convertToRealCoin2:model.incomeTotal setScale:4  coin:@"BTC"];
    _priceLabel.text = [NSString stringWithFormat:@"%@ BTC",incomeTotal];

}

@end
