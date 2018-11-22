//
//  Coin.m
//  Coin
//
//  Created by haiqingzheng on 2018/3/19.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "CoinModel.h"

#define COIN_LIST_KEY @"coin_list_key"

@implementation CoinModel

- (void)saveOpenCoinList:(NSMutableArray *)coinList {
    
    [[NSUserDefaults standardUserDefaults] setObject:coinList forKey:COIN_LIST_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray<CoinModel *> *)getOpenCoinList {
    NSUserDefaults *coinDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *coinList = [coinDefault objectForKey:COIN_LIST_KEY];
    return [CoinModel tl_objectArrayWithDictionaryArray:coinList];
}

+ (instancetype)coin {
    
    static CoinModel *coin = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        coin = [[CoinModel alloc] init];
        
    });
    
    return coin;
    
}

@end
