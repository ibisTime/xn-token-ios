//
//  BillModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "NSString+CGSize.h"

@interface BillModel : TLBaseModel

@property (nonatomic, copy) NSString *preAmountString;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, copy) NSString *accountNumber;

@property (nonatomic, copy) NSString *channelType;

@property (nonatomic, copy) NSString *refNo;

@property (nonatomic, copy) NSString *bizNote;

@property (nonatomic, copy) NSString *type;
//账户余额
@property (nonatomic, copy) NSString *postAmountString;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *transAmountString;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, copy) NSString *bizType;

@property (nonatomic, copy) NSString *workDate;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *currency;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) CGFloat dHeightValue;

@property (nonatomic, copy) NSString *priceCNY;

@property (nonatomic, copy) NSString *priceUSD;

@property (nonatomic, copy) NSString *priceHKD;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *from;

@property (nonatomic, copy) NSString *to;

@property (nonatomic, copy) NSString *direction;

@property (nonatomic, copy) NSString *txFee;

@property (nonatomic, copy) NSString *transDatetime;

@property (nonatomic, copy) NSString *height;

@property (nonatomic, copy) NSString *txHash;

@property (nonatomic, copy) NSString *interType;
//输入来源
@property (nonatomic, strong) NSArray *vin;
//输出来源
@property (nonatomic, strong) NSArray *vout;

@property (nonatomic, assign) CGFloat rowHeight;








- (NSString *)getStatusName;

- (NSString *)getBizName;

@end
