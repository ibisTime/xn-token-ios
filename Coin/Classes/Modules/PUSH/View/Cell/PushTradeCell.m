//
//  TradeCell.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PushTradeCell.h"

#import "NSString+Extension.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "NSNumber+Extension.h"
#import "TLUser.h"
#import "PayTypeModel.h"
#import "UserStatistics.h"
#import "PushUserPhotoView.h"
#import "PayTypeView.h"
#import "CoinUtil.h"

@interface PushTradeCell ()

//头像
@property (nonatomic, strong) PushUserPhotoView *userPhotoView;

//交易、好评跟信任
@property (nonatomic, strong) UILabel *dataLbl;

//单价
@property (nonatomic, strong) UILabel *priceLbl;

//数量
@property (nonatomic, strong) UILabel *quantityLbl;

//金额
@property (nonatomic, strong) UILabel *amountLbl;

//交易方式
@property (nonatomic, strong) UIButton *tradeTypeBtn;

@end

@implementation PushTradeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //头像
    self.userPhotoView = [PushUserPhotoView photoView];
    self.userPhotoView.userInteractionEnabled = NO;
    [self addSubview:self.userPhotoView];
    [self.userPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(13);

    }];
    
    //交易、好评跟信任
    self.dataLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    
    [self addSubview:self.dataLbl];
    [self.dataLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.userPhotoView.mas_centerY);
        make.left.equalTo(self.userPhotoView.mas_right).offset(11);
        
    }];
    
    //单价
    self.priceLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
    
    [self addSubview:self.priceLbl];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.userPhotoView.mas_left);
        make.top.equalTo(self.userPhotoView.mas_bottom).offset(14);
        
    }];
    
    UILabel *priceT = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    priceT.text = [LangSwitcher switchLang:@"单价" key:nil];
    [self addSubview:priceT];
    [priceT mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.priceLbl.mas_left);
        make.top.equalTo(self.priceLbl.mas_bottom).offset(4);
        
    }];
    
    UILabel *quantityT = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    quantityT.text = [LangSwitcher switchLang:@"数量" key:nil];
    [self addSubview:quantityT];
    [quantityT mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(priceT.mas_left).offset(SCREEN_WIDTH/3);
        make.top.equalTo(priceT.mas_top);
        
    }];
    
    UILabel *totalAmountT = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    totalAmountT.text = [LangSwitcher switchLang:@"金额" key:nil];
    [self addSubview:totalAmountT];
    [totalAmountT mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(quantityT.mas_left).offset(SCREEN_WIDTH/3);
        make.top.equalTo(priceT.mas_top);
        
    }];
    
    //数量
    self.quantityLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
    
    [self addSubview:self.quantityLbl];
    [self.quantityLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(quantityT.mas_left);
        make.top.equalTo(self.priceLbl.mas_top);
        
    }];
    
    //金额
    self.amountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
    
    [self addSubview:self.amountLbl];
    [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(totalAmountT.mas_left);
        make.top.equalTo(self.priceLbl.mas_top);
        
    }];
    
    
    
    //交易方式
    self.tradeTypeBtn = [UIButton buttonWithTitle:@"" titleColor:kWhiteColor
                                  backgroundColor:kThemeColor titleFont:12.0 cornerRadius:12];
    self.tradeTypeBtn.userInteractionEnabled = NO;
    [self addSubview:self.tradeTypeBtn];
//    self.tradeTypeBtn.layer.borderWidth = 0.5;
    [self.tradeTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-22);
        make.width.equalTo(@50);
        make.height.equalTo(@24);
        make.centerY.equalTo(self.userPhotoView.mas_centerY);
        
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

- (void)setAdvertise:(AdvertiseModel *)advertise {
    
    _advertise = advertise;
    
    UserInfo *userInfo = advertise.user;
    UserStatistics *userStatist = advertise.userStatistics;
    
    //头像
    self.userPhotoView.userInfo = userInfo;
    
    //交易、好评跟信任
    self.dataLbl.text =
    [LangSwitcher switchLang:[NSString stringWithFormat:@"交易 %ld · 好评 %@ · 信任 %ld",
                              userStatist.jiaoYiCount,
                              userStatist.goodCommentRate,
                              userStatist.beiXinRenCount]
                         key:nil];
    
    //单价
    self.priceLbl.text = [NSString stringWithFormat:@"%@", [advertise.truePrice convertToSimpleRealMoney]];
    
    //数量
    NSString *quantity = [CoinUtil convertToRealCoin:advertise.leftCountString
                                                coin:advertise.tradeCoin];
    self.quantityLbl.text = [NSString stringWithFormat:@"%@", quantity];
    //金额
    double totalAmount = advertise.truePrice.doubleValue * quantity.doubleValue;
    self.amountLbl.text = [[NSString stringWithFormat:@"%.2f", totalAmount] convertToSimpleRealMoney];
    
    NSString *tradeText = nil;
    
    if ([advertise isMineShangJiaAds]) {
       //只有待交易的广告才显示，编辑
        tradeText = [LangSwitcher switchLang:@"编辑" key:nil];
        
    } else {
        
        tradeText = [advertise.tradeType isEqualToString:kAdsTradeTypeSell] ?
        [LangSwitcher switchLang:@"购买" key:nil] : [LangSwitcher switchLang:@"出售" key:nil];

    }
    
    UIColor *tradeBgColor = [advertise.tradeType isEqualToString:@"1"] ? kGreenColor : kThemeColor;
    
    //交易方式
    [self.tradeTypeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.tradeTypeBtn setTitle:tradeText forState:UIControlStateNormal];
    [self.tradeTypeBtn setBackgroundColor:tradeBgColor forState:UIControlStateNormal];
    
}

@end
