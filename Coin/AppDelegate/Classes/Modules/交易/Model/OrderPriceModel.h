//
//  OrderPriceModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface OrderPriceModel : TLBaseModel

//价格
@property (nonatomic, copy) NSString *price;
//金额
@property (nonatomic, copy) NSString *amount;
//数量
@property (nonatomic, copy) NSString *num;

@property (nonatomic, copy) NSString *coin;


@end
