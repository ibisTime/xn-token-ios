//
//  QuotationModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface QuotationModel : TLBaseModel

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, strong) NSNumber *mid;

@property (nonatomic, copy) NSString *volume;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, assign) CGFloat bid;

@property (nonatomic, assign) CGFloat high;

@property (nonatomic, assign) CGFloat ask;

@property (nonatomic, copy) NSString *referCurrency;

@property (nonatomic, assign) CGFloat low;

@property (nonatomic, copy) NSString *origin;
//最新价格
@property (nonatomic, strong) NSNumber *lastPrice;
//币种
@property (nonatomic, copy) NSString *coin;

@end
