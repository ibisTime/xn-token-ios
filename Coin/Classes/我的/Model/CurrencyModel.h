//
//  CurrencyModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/13.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLBaseModel.h"

@interface CurrencyModel : TLBaseModel

//积分 JF
//人民币 CNY
//账户编号
@property (nonatomic,copy) NSString *accountNumber;
//总额
@property (nonatomic,strong) NSNumber *amount;
//入金
@property (nonatomic, strong) NSNumber *inAmount;
//累计增加金额
@property (nonatomic, strong) NSNumber *addAmount;
//冻结金额
@property (nonatomic,strong) NSNumber *frozenAmount;
//充币地址
@property (nonatomic, copy) NSString *coinAddress;

@property (nonatomic,copy) NSString *createDatetime;
//币种
@property (nonatomic,copy) NSString *currency;
@property (nonatomic,copy) NSString *md5;
@property (nonatomic,copy) NSString *realName;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *systemCode;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *userId;
//最后一次流水
@property (nonatomic, copy) NSString *lastOrder;

- (NSString *)getTypeName;

- (NSString *)getImgName;

@end

FOUNDATION_EXTERN NSString *const kETH;
FOUNDATION_EXTERN NSString *const kCNY;
FOUNDATION_EXTERN NSString *const kBTC;

