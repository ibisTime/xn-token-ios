//
//  RateModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface RateModel : TLBaseModel
//币种
@property (nonatomic, copy) NSString *currency;
//参照货币
@property (nonatomic, copy) NSString *referCurrency;
//数据源
@property (nonatomic, copy) NSString *origin;
//汇率
@property (nonatomic, strong) NSNumber *rate;
//cellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@end
