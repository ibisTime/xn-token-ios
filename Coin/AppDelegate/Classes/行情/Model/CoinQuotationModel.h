//
//  CoinQuotationModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/12/7.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CoinQuotationModel : TLBaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *price_cny;

@property (nonatomic, copy) NSString *one_day_volume_usd;

@property (nonatomic, copy) NSString *percent_change_24h;

@property (nonatomic, copy) NSString *symbol;

@property (nonatomic, copy) NSString *last_updated;

@property (nonatomic, copy) NSString *market_cap_usd;

@property (nonatomic, copy) NSString *one_day_volume_cny;

@property (nonatomic, copy) NSString *price_usd;

@property (nonatomic, copy) NSString *percent_change_7d;

@property (nonatomic, copy) NSString *rank;

@property (nonatomic, copy) NSString *price_btc;

@property (nonatomic, copy) NSString *available_supply;

@property (nonatomic, copy) NSString *total_supply;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *percent_change_1h;
//涨跌颜色
@property (nonatomic, strong) UIColor *bgColor;

@end
