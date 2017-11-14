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

@property (nonatomic, assign) NSInteger preAmount;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, copy) NSString *accountNumber;

@property (nonatomic, copy) NSString *channelType;

@property (nonatomic, copy) NSString *refNo;

@property (nonatomic, copy) NSString *bizNote;

@property (nonatomic, copy) NSString *type;
//账户余额
@property (nonatomic, strong) NSNumber *postAmount;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) NSNumber *transAmount;

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

- (NSString *)getBizName;

- (NSString *)getImgName;

//- (CGFloat)dHeightValue;

@end
