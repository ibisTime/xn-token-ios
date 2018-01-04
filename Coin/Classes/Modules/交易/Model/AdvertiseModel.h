//
//  AdvertiseModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "OrderModel.h"
#import "UserStatistics.h"

@class TradeUserInfo, UserStatistics, Displaytime;

typedef NS_ENUM(NSUInteger, AdsType) {
    
    AdsTradeTypeSell,
    AdsTradeTypeBuy
    
};

@interface AdvertiseModel : TLBaseModel

@property (nonatomic, copy) NSString *onlyTrust;

@property (nonatomic, copy) NSString *leftCountString;

@property (nonatomic, strong) NSNumber *maxTrade;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) NSNumber *protectPrice;

@property (nonatomic, strong) NSNumber *truePrice;

@property (nonatomic, copy) NSString *tradeCoin;

@property (nonatomic, copy) NSString *tradeType;
@property (nonatomic, assign, readonly) AdsType adsType;

//支付方式（0=支付宝、1=微信、2=银行卡转账)
@property (nonatomic, copy) NSString *payType;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, assign) NSInteger payLimit;

@property (nonatomic, copy) NSString *leaveMessage;

@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, assign) CGFloat marketPrice;

@property (nonatomic, strong) UserInfo *user;
//交易信息
@property (nonatomic, strong) UserStatistics *userStatistics;

@property (nonatomic, strong) NSNumber *minTrade;

@property (nonatomic, strong) NSNumber *premiumRate;

@property (nonatomic, copy) NSString *totalCountString;

@property (nonatomic, copy) NSString *tradeCurrency;

@property (nonatomic, copy) NSString *userId;
//是否信任
@property (nonatomic, strong) NSNumber *isTrust;
//是否黑名单
@property (nonatomic, strong) NSNumber *isBlackList;
//状态
@property (nonatomic, copy) NSString *statusTitle;
//时间
@property (nonatomic, strong) NSArray<Displaytime *> *displayTime;


/**
  是否为我的广告
 */
- (BOOL)isMineAds;

/**
 是否为我的广告(上架状态)
 */
- (BOOL)isMineShangJiaAds;

///**
// 是否为我的广告( 待交易状态)
// */
//- (BOOL)isMineDaiJiaoYiAds;
//
//
///**
// 是否为我的广告( 交易中状态 )
// */
//- (BOOL)isMineJiaoYiZhong;

- (NSString *)tradeAmountLimit;

@end

FOUNDATION_EXTERN NSString *const kAdsStatusDraft;
FOUNDATION_EXTERN NSString *const kAdsStatusXiaJia;
FOUNDATION_EXTERN NSString *const kAdsStatusShangJia;

//FOUNDATION_EXTERN NSString *const kAdsStatusDaiJiaoYi;
//FOUNDATION_EXTERN NSString *const kAdsStatusJiaoYiZhong;

FOUNDATION_EXTERN NSString *const kAdsTradeTypeBuy;
FOUNDATION_EXTERN NSString *const kAdsTradeTypeSell;

@interface Displaytime : NSObject

@property (nonatomic, copy) NSString *week;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger startTime;

@property (nonatomic, assign) NSInteger endTime;

@property (nonatomic, copy) NSString *adsCode;


@end
