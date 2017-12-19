//
//  TradeCell.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TradeCell.h"

#import "NSString+Extension.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "NSNumber+Extension.h"
#import "TLUser.h"
#import "PayTypeModel.h"
#import "UserStatistics.h"
#import "UserPhotoView.h"
#import "PayTypeView.h"

@interface TradeCell ()

//头像
@property (nonatomic, strong) UserPhotoView *userPhotoView;
//昵称
@property (nonatomic, strong) UILabel *nameLbl;
//交易、好评跟信任
@property (nonatomic, strong) UILabel *dataLbl;
//支付方式
@property (nonatomic, strong) PayTypeView *payTypeView;
//限额
@property (nonatomic, strong) UILabel *limitAmountLbl;
//价格
@property (nonatomic, strong) UILabel *priceLbl;
//交易方式
@property (nonatomic, strong) UIButton *tradeTypeBtn;

@end

@implementation TradeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //头像
    CGFloat imgWidth = 40;
    self.userPhotoView = [UserPhotoView photoView];
    [self addSubview:self.userPhotoView];
    [self.userPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);

    }];
    
    //昵称
    self.nameLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    [self addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.userPhotoView.mas_right).offset(10);
        
    }];
    
    //支付方式
    self.payTypeView = [[PayTypeView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.payTypeView];
    [self.payTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLbl.mas_right).offset(5);
        make.centerY.equalTo(self.nameLbl.mas_centerY);
    }];
    
    //交易、好评跟信任
    self.dataLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    
    [self addSubview:self.dataLbl];
    [self.dataLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLbl.mas_bottom).offset(10);
        make.left.equalTo(self.nameLbl.mas_left);
        
    }];
    
    //限额
    self.limitAmountLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12.0];
    
    [self addSubview:self.limitAmountLbl];
    [self.limitAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.dataLbl.mas_bottom).offset(10);

    }];
    
    //价格
    self.priceLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kRiseColor font:15.0];
    
    [self addSubview:self.priceLbl];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(@(15));
        
    }];
    
    //交易方式
    self.tradeTypeBtn = [UIButton buttonWithTitle:@"" titleColor:kClearColor backgroundColor:kClearColor titleFont:14.0 cornerRadius:5];
    [self addSubview:self.tradeTypeBtn];
    self.tradeTypeBtn.layer.borderWidth = 0.5;
    [self.tradeTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.priceLbl.mas_right);
        make.width.equalTo(@44);
        make.height.equalTo(@24);
        make.top.equalTo(self.priceLbl.mas_bottom).offset(14);
        
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
    self.nameLbl.text = userInfo.nickname;
    
    //支付方式
    PayTypeModel *payModel = [PayTypeModel new];
    payModel.payType = advertise.payType;
    self.payTypeView.payType = payModel;

    //交易、好评跟信任
    self.dataLbl.text =
    [LangSwitcher switchLang:[NSString stringWithFormat:@"交易 %ld · 好评 %@ · 信任 %ld",
                              userStatist.jiaoYiCount,
                              userStatist.goodCommentRate,
                              userStatist.beiXinRenCount]
                         key:nil];

    
    
    
    //限额
    NSString *limitAmountText = [NSString stringWithFormat:@"限额: %@-%@ CNY",[advertise.minTrade convertToSimpleRealMoney], [advertise.maxTrade convertToSimpleRealMoney]];
    
    self.limitAmountLbl.text = [LangSwitcher switchLang:limitAmountText
                                                    key:nil];
    //价格
    
    self.priceLbl.text = [NSString stringWithFormat:@"%@ CNY", [advertise.truePrice convertToSimpleRealMoney]];
    
    NSString *tradeText = nil;
    
    if ([advertise isMineShangJiaAds]) {
       //只有待交易的广告才显示，编辑
        tradeText = [LangSwitcher switchLang:@"编辑" key:nil];
        
    } else {
        
        tradeText = [advertise.tradeType isEqualToString:kAdsTradeTypeSell] ?
        [LangSwitcher switchLang:@"购买" key:nil] : [LangSwitcher switchLang:@"出售" key:nil];

    }
    
    UIColor *tradeColor = [advertise.tradeType isEqualToString:@"1"] ? kPaleBlueColor: kThemeColor;
    
    //交易方式
    [self.tradeTypeBtn setTitleColor:tradeColor forState:UIControlStateNormal];
    [self.tradeTypeBtn setTitle:tradeText forState:UIControlStateNormal];
    self.tradeTypeBtn.layer.borderColor = tradeColor.CGColor;
    
}

@end
