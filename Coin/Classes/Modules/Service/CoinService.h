//
//  CoinService.h
//  Coin
//
//  Created by  tianlei on 2018/2/03.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoinUtil.h"
#import "CoinModel.h"

@interface CoinService : NSObject

+ (instancetype)shareService;


/**
 记录交易切换的当前coin,默认为 eth
 */
@property (nonatomic, strong) CoinModel *currentCoin;


//- (NSString *)pageAddressApiCode:(NSString *)coin;

@end
