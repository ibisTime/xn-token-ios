//
//  AdvertiseModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@class TradeUserInfo;

@interface AdvertiseModel : TLBaseModel

@property (nonatomic, copy) NSString *onlyTrust;

@property (nonatomic, assign) long long leftAmount;

@property (nonatomic, assign) NSInteger maxTrade;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, assign) CGFloat protectPrice;

@property (nonatomic, assign) CGFloat truePrice;

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

@property (nonatomic, assign) NSInteger minTrade;

@property (nonatomic, assign) CGFloat premiumRate;

@property (nonatomic, assign) long long totalAmount;

@property (nonatomic, copy) NSString *tradeCurrency;

@property (nonatomic, copy) NSString *userId;

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

