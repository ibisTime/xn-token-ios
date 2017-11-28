//
//  CoinAddressModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@class CoinAddressUser;

@interface CoinAddressModel : TLBaseModel

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, copy) NSString *label;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *initialBalanceString;

@property (nonatomic, copy) NSString *balanceString;

@property (nonatomic, strong) CoinAddressUser *user;

@end

@interface CoinAddressUser : NSObject

@property (nonatomic, copy) NSString *kind;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *tradePwdStrength;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *loginPwdStrength;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, assign) BOOL tradepwdFlag;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *nickname;

@end
