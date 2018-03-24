//
//  MoreProfitCell.m
//  Coin
//
//  Created by haiqingzheng on 2018/3/24.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "MoreProfitCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "NSString+Extension.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CoinUtil.h"


@interface MoreProfitCell ()

//币种图标
@property (nonatomic, strong) UIImageView *coinIcon;
//币种英文名称
@property (nonatomic, strong) UILabel *enameLbl;
//提成收益
@property (nonatomic, strong) UILabel *profitLal;

@end

@implementation MoreProfitCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //头像
    CGFloat imgWidth = 16;
    
    self.coinIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.height - imgWidth)/2, 15, imgWidth, imgWidth)];
    self.coinIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.coinIcon];

    //英文名称
    self.enameLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];

    [self addSubview:self.enameLbl];
    [self.enameLbl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(self.coinIcon.mas_centerY);
        make.left.equalTo(self.coinIcon.mas_right).offset(10);

    }];

    //提成收益
    self.profitLal = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:15.0];

    [self addSubview:self.profitLal];
    [self.profitLal mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(self.coinIcon.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);

    }];

    //分割线
    UIView *line = [[UIView alloc] init];

    line.backgroundColor = kLineColor;

    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(-0.5));
        make.height.equalTo(@0.5);

    }];
}

- (void)setProfitModel:(ProfitModel *)profitModel {
    
    _profitModel = profitModel;
    
    CoinModel *coinModel = profitModel.coin;
    
    NSString *iconUrl = coinModel.icon;

    
    //头像
    if (iconUrl) {

        [self.coinIcon sd_setImageWithURL:[NSURL URLWithString:[iconUrl convertImageUrl]]];

    }
    
    self.enameLbl.text = coinModel.ename;
    
    NSString *realCoin = [CoinUtil convertToRealCoin:profitModel.inviteProfit coin:coinModel.symbol];
    
    self.profitLal.text = [NSString stringWithFormat:@"%@%@", realCoin, coinModel.symbol];
   
}


@end
