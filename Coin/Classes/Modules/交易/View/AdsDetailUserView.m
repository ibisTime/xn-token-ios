//
//  AdsDetailUserView.m
//  Coin
//
//  Created by  tianlei on 2017/12/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AdsDetailUserView.h"
#import "TLUIHeader.h"
#import "UIButton+Custom.h"
#import "NSString+Extension.h"
#import "NSNumber+Extension.h"
#import "TopBottomView.h"
#import "PayTypeView.h"
#import "UserPhotoView.h"
#import "AppColorMacro.h"

#define IMG_WIDTH 48
@interface AdsDetailUserView()

//@property (nonatomic, strong) UIButton *photoBtn;
@property (nonatomic, strong) UserPhotoView *userPhotoView;
@property (nonatomic, strong) UILabel  *nameLbl;
@property (nonatomic, strong) UILabel  *limitAmountLbl;
@property (nonatomic, strong) UILabel  *priceLbl;
@property (nonatomic, strong) PayTypeView *payTypeView;

//
@property (nonatomic, strong) TopBottomView *tradeTimesView;
@property (nonatomic, strong) TopBottomView *receiveTrustTimesView;
@property (nonatomic, strong) TopBottomView *goodCommentRateView;
@property (nonatomic, strong) TopBottomView *historyTradeCountView;

@end

@implementation AdsDetailUserView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        
        [self topUI];
        [self topUILayout];
        
        //
        [self bottomeUI];
        [self bottomUILayout];
        
        
        
    }
    return self;
}

- (void)setAds:(AdvertiseModel *)ads {
    
    _ads = ads;

    UserInfo *userInfo = _ads.user;
    
    self.userPhotoView.userInfo = userInfo;
    //头像
//    if (userInfo.photo) {
//
//        [self.photoBtn setTitle:@"" forState:UIControlStateNormal];
//
//        [self.photoBtn sd_setImageWithURL:[NSURL URLWithString:[userInfo.photo convertImageUrl]] forState:UIControlStateNormal];
//
//    } else {
//
//        NSString *nickName = userInfo.nickname;
//
//        NSString *title = [nickName substringToIndex:1];
//
//        [self.photoBtn setTitle:title forState:UIControlStateNormal];
//
//    }
    
    self.nameLbl.text = userInfo.nickname;
    
    //支付方式
        PayTypeModel *payModel = [PayTypeModel new];
        payModel.payType = _ads.payType;
    self.payTypeView.payType = payModel;
    
    
    //限额
    self.limitAmountLbl.text = [_ads tradeAmountLimit];
    
    //价格
    self.priceLbl.text = [NSString stringWithFormat:@"%@ %@", [_ads.truePrice convertToSimpleRealMoney],_ads.tradeCurrency];
    
    // 底部
    UserStatistics *userStatist = _ads.userStatistics;
    
    self.tradeTimesView.bottomLbl.text = [LangSwitcher switchLang:@"交易次数" key:nil];
    self.tradeTimesView.topLbl.text = [NSString stringWithFormat:@"%ld", userStatist.jiaoYiCount];
    
    self.receiveTrustTimesView.bottomLbl.text = [LangSwitcher switchLang:@"信任次数" key:nil];
    self.receiveTrustTimesView.topLbl.text = [NSString stringWithFormat:@"%ld", userStatist.beiXinRenCount];
    
    self.goodCommentRateView.bottomLbl.text = [LangSwitcher switchLang:@"好评率" key:nil];
    self.goodCommentRateView.topLbl.text = userStatist.goodCommentRate;
    
    self.historyTradeCountView.bottomLbl.text =  [LangSwitcher switchLang:@"历史交易" key:nil];
    self.historyTradeCountView.topLbl.text = [userStatist convertTotalTradeCount];
    
}


- (void)bottomeUI{
    
    //交易次数
    self.tradeTimesView = [[TopBottomView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.tradeTimesView];
    
    //信任次数
    self.receiveTrustTimesView = [[TopBottomView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.receiveTrustTimesView];
    
    //好评率
    self.goodCommentRateView = [[TopBottomView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.goodCommentRateView];
    
    //历史交易
    self.historyTradeCountView = [[TopBottomView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.historyTradeCountView];
    
}

- (void)bottomUILayout{
    //交易次数
    //信任次数
    NSArray *bottomViews = @[ self.tradeTimesView,
                              self.receiveTrustTimesView,
                              self.goodCommentRateView,
                              self.historyTradeCountView
                              ];
    
    [bottomViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lineColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width);
        make.height.mas_equalTo(0.7);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [bottomViews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                             withFixedSpacing:0
                                  leadSpacing:0
                                  tailSpacing:0];
    
}

- (void)topUILayout {
    
//    CGFloat imgWidth = IMG_WIDTH;
    [self.userPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(15);
        
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.userPhotoView.mas_centerY).offset(-2);
        make.left.equalTo(self.userPhotoView.mas_right).offset(10);
        
    }];
    
    [self.limitAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl);
        make.top.equalTo(self.userPhotoView.mas_centerY).offset(5);
    }];
    
    [self.payTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_right).offset(5);
        make.centerY.equalTo(self.nameLbl.mas_centerY);
        
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.userPhotoView.mas_centerY);
        
    }];
    
}

- (void)topUI {
    
    //头像
//    CGFloat imgWidth = IMG_WIDTH;
//    self.photoBtn = [UIButton buttonWithTitle:@""
//                                   titleColor:kWhiteColor
//                              backgroundColor:kAppCustomMainColor
//                                    titleFont:24
//                                 cornerRadius:imgWidth/2.0];
//    self.photoBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    [self addSubview:self.photoBtn];
    self.userPhotoView = [UserPhotoView photoView];
    [self addSubview:self.userPhotoView];
    self.userPhotoView.userInteractionEnabled = NO;
    
    //昵称
    self.nameLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    [self addSubview:self.nameLbl];

    self.payTypeView = [[PayTypeView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.payTypeView];
    
    
    //限额
    self.limitAmountLbl = [UILabel labelWithBackgroundColor:[UIColor whiteColor]
                                                  textColor:kTextColor2
                                                       font:12.0];
    [self addSubview:self.limitAmountLbl];
    
    
    //价格
    self.priceLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentCenter
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(15)
                                  textColor:kRiseColor];
    
    [self addSubview:self.priceLbl];
    
}

@end
