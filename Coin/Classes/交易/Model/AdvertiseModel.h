//
//  AdvertiseModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@class TradeUserInfo, UserStatistics, Displaytime;

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
//支付方式（0=支付宝、1=微信、2=银行卡转账)
@property (nonatomic, copy) NSString *payType;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, assign) NSInteger payLimit;

@property (nonatomic, copy) NSString *leaveMessage;

@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, assign) CGFloat marketPrice;

@property (nonatomic, strong) TradeUserInfo *user;
//交易信息
@property (nonatomic, strong) UserStatistics *userStatistics;

@property (nonatomic, strong) NSNumber *minTrade;

@property (nonatomic, strong) NSNumber *premiumRate;

@property (nonatomic, copy) NSString *totalCountString;

@property (nonatomic, copy) NSString *tradeCurrency;

@property (nonatomic, copy) NSString *userId;
//是否信任
@property (nonatomic, strong) NSNumber *isTrust;
//状态
@property (nonatomic, copy) NSString *statusTitle;
//时间
@property (nonatomic, strong) NSArray<Displaytime *> *displayTime;

@end

@interface TradeUserInfo : NSObject

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *loginPwdStrength;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, assign) BOOL tradepwdFlag;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *kind;

@end

@interface UserStatistics: NSObject
//交易次数
@property (nonatomic, assign) NSInteger jiaoYiCount;
//信任人数
@property (nonatomic, assign) NSInteger beiXinRenCount;
//评论次数
@property (nonatomic, assign) NSInteger beiPingJiaCount;
//好评次数
@property (nonatomic, assign) NSInteger beiHaoPingCount;
//好评率
@property (nonatomic, copy) NSString *goodCommentRate;

@end

@interface Displaytime : NSObject

@property (nonatomic, copy) NSString *week;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger startTime;

@property (nonatomic, assign) NSInteger endTime;

@property (nonatomic, copy) NSString *adsCode;

@end
