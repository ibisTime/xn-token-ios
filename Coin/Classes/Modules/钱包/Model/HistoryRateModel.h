//
//  HistoryRateModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/30.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface HistoryRateModel : TLBaseModel

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *currency;

@property (nonatomic, copy) NSString *referCurrency;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, copy) NSString *origin;

@property (nonatomic, strong) NSNumber *rate;

@end
