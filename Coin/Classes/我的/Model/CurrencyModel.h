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
@property (nonatomic,copy) NSString *accountNumber;

@property (nonatomic,strong) NSNumber *amount; //总额

@property (nonatomic,copy) NSString *createDatetime;
@property (nonatomic,copy) NSString *currency;
@property (nonatomic,strong) NSNumber *frozenAmount; //冻结金额
@property (nonatomic,copy) NSString *md5;
@property (nonatomic,copy) NSString *realName;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *systemCode;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *userId;

- (NSString *)getTypeName;

@end

FOUNDATION_EXTERN NSString *const kJF;
FOUNDATION_EXTERN NSString *const kCNY;
