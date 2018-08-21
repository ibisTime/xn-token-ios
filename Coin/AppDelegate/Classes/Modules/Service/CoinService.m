//
//  CoinService.m
//  Coin
//
//  Created by  tianlei on 2018/2/03.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "CoinService.h"
#import "CoinUtil.h"

@implementation CoinService

+ (instancetype)shareService {
    
    static CoinService *coinService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        coinService = [[[self class] alloc] init];
        coinService.currentCoin = [[CoinUtil shouldDisplayOriginalCoinModelArray] objectAtIndex:0];
        coinService.currentToken = [[CoinUtil shouldDisplayTokenCoinModelArray] objectAtIndex:0];
        
    });
    
    return coinService;
    
}




@end
