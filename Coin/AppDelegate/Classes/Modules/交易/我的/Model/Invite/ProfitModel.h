//
//  ProfitModel.h
//  Coin
//
//  Created by haiqingzheng on 2018/3/24.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseModel.h"
#import "CoinModel.h"

@interface ProfitModel : TLBaseModel

@property (nonatomic, copy) NSString *inviteProfit;

@property (nonatomic, strong) CoinModel *coin;

@end
