//
//  CurrencyModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/13.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLBaseModel.h"
#import "AddAccoutModel.h"
@interface CurrencyModel : TLBaseModel
@property (nonatomic,strong) NSDictionary *coin;
@property (nonatomic,copy) NSString *isDisplay;

@property (nonatomic,copy) NSString *name;
//积分 JF
//人民币 CNY
//账户编号
@property (nonatomic,copy) NSString *accountNumber;
//总额
@property (nonatomic, copy) NSString *amountString;
//入金
@property (nonatomic, copy) NSString *inAmountString;
//累计增加金额
@property (nonatomic, copy) NSString *addAmountString;
//冻结金额
@property (nonatomic, copy) NSString *frozenAmountString;
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

@property (nonatomic,copy) NSString *symbol;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *priceCNY;
@property (nonatomic,copy) NSString *priceUSD;
@property (nonatomic,copy) NSString *priceKRW;

@property (nonatomic,copy) NSString *amountCNY;
@property (nonatomic,copy) NSString *priceHKD;
@property (nonatomic,copy) NSString *amountUSD;
@property (nonatomic,copy) NSString *amountKRW;

@property (nonatomic,copy) NSString *amountHKD;
@property (nonatomic,copy) NSString *balance;

@property (nonatomic, copy) NSString *lastOrder;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) BOOL IsSelected;


@property (nonatomic, copy) NSString *chineseName;
@property (nonatomic, copy) NSString *AvailableBalance;


- (NSString *)getTypeName;

- (NSString *)getImgName;

@end



