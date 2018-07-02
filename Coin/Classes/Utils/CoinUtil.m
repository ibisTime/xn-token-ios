//
//  CoinUtil.m
//  Coin
//
//  Created by  tianlei on 2017/12/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CoinUtil.h"
#import "TLNetworking.h"

NSString *const kETH = @"ETH";
NSString *const kSC = @"SC";
NSString *const kBTC = @"BTC";
NSString *const kOGC = @"OGC";

NSString *const kCNY = @"CNY";

//#define NUM_10_18 @(1.0e+18)
//#define NUM_10_8 @(1.0e+8)
#define SCALE 8

@implementation CoinUtil

+ (NSString *)convertToRealCoin:(NSString *)count coin:(NSString *)coin {
    
    return [self convertCount:count scale:SCALE cardinality:[self getCardinality:coin]];
    
}

+ (NSString *)convertToRealCoin:(NSString *)count coin:(NSString *)coin scale:(NSUInteger)scale {
    
    return [self convertCount:count scale:scale cardinality:[self getCardinality:coin]];
    
}

+ (NSString *)convertToSysCoin:(NSString *)count coin:(NSString *)coin {
    
    return [self mult1:count mult2:[[self getCardinality:coin] stringValue]];
    
}

+ (NSNumber *)getCardinality:(NSString *)coin {
    
    NSNumber *result = [NSNumber numberWithInteger:1];
    
    NSMutableArray<CoinModel *> *coins = [[CoinModel coin] getOpenCoinList];
    
    for (CoinModel *coinModel in coins) {
        if ([coin isEqualToString:coinModel.symbol]) {
            result = [[NSNumber alloc] initWithDouble:pow(10, coinModel.unit.doubleValue)];
        }
    }
    
//    if ([coin isEqualToString:kETH]) {
//        
//        return @(1.0e+18);
//        
//    } else if ([coin isEqualToString:kBTC]) {
//        
//        return @(1.0e+8);
//        
//    } else if([coin isEqualToString:kSC]) {
//        
//        return @(1.0e+24);
//    }
    
    return result;
}

+ (NSString *)mult1:(NSString *)mult1 mult2:(NSString *)mult2 {
    
    NSDecimalNumber *mult1Num = [[NSDecimalNumber alloc] initWithString:mult1];
    NSDecimalNumber *mult2Num = [[NSDecimalNumber alloc] initWithString:mult2];
    NSDecimalNumber *result = [mult1Num decimalNumberByMultiplyingBy:mult2Num];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown
                                       scale:0
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    
    return [[result decimalNumberByRoundingAccordingToBehavior:roundUp] stringValue];
    
}



+ (NSString *)convertCount:(NSString *)count scale:(short)scale cardinality:(NSNumber *)num {
    

    //保留8位小数,第九位舍去
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                             scale:scale
                                                                                raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSDecimalNumber *m = [NSDecimalNumber decimalNumberWithString:count];
    NSDecimalNumber *n = [NSDecimalNumber decimalNumberWithString:[num stringValue]];
    NSDecimalNumber *o = [m decimalNumberByDividingBy:n];
    NSDecimalNumber *p = [o decimalNumberByRoundingAccordingToBehavior:handler];
    return [NSString stringWithFormat:@"%@",p];
    
}

+ (NSString *)chineseName:(NSString *)coin {
    
    NSMutableArray<CoinModel *> *coins = [[CoinModel coin] getOpenCoinList];
    
    for (CoinModel *coinModel in coins) {
        if ([coin isEqualToString:coinModel.symbol]) {
            return coinModel.cname;
        }
    }
    
    return nil;
}

+ (NSString *)mult1:(NSString *)mult1 mult2:(NSString *)mult2 scale:(NSUInteger)scale {
    
    NSDecimalNumber *mult1Num = [[NSDecimalNumber alloc] initWithString:mult1];
    NSDecimalNumber *mult2Num = [[NSDecimalNumber alloc] initWithString:mult2];
    NSDecimalNumber *result = [mult1Num decimalNumberByMultiplyingBy:mult2Num];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown
                                       scale:scale
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    
    return [[result decimalNumberByRoundingAccordingToBehavior:roundUp] stringValue];
    
}

+ (NSArray *)shouldDisplayCoinArray {
    
    NSMutableArray<CoinModel *> *coinList = [[CoinModel coin] getOpenCoinList];
    
    NSMutableArray *coins = [[NSMutableArray alloc] init];
    for (CoinModel *coinModel in coinList) {
        [coins addObject:coinModel.symbol];
    }
    return coins;
}

+ (NSArray *)shouldDisplayOriginalCoinArray {
    
    NSMutableArray<CoinModel *> *coinList = [[CoinModel coin] getOpenCoinList];
    
    NSMutableArray *coins = [[NSMutableArray alloc] init];
    for (CoinModel *coinModel in coinList) {
        if ([@"0" isEqualToString:coinModel.type]) {
            [coins addObject:coinModel.symbol];
        }
    }
    return coins;
}

+ (NSArray *)shouldDisplayTokenCoinArray {
    
    NSMutableArray<CoinModel *> *coinList = [[CoinModel coin] getOpenCoinList];
    
    NSMutableArray *coins = [[NSMutableArray alloc] init];
    for (CoinModel *coinModel in coinList) {
        if ([@"1" isEqualToString:coinModel.type]) {
            [coins addObject:coinModel.symbol];
        }
    }
    return coins;
}

+ (NSMutableArray<CoinModel *> *)shouldDisplayCoinModelArray {
    
    return [[CoinModel coin] getOpenCoinList];

}

+ (NSMutableArray<CoinModel *> *)shouldDisplayOriginalCoinModelArray {
    
    NSMutableArray<CoinModel *> *coinList = [[CoinModel coin] getOpenCoinList];
    
    NSMutableArray *coins = [[NSMutableArray alloc] init];
    for (CoinModel *coinModel in coinList) {
        if ([@"0" isEqualToString:coinModel.type]) {
            [coins addObject:coinModel];
        }
    }
    return coins;
    
}

+ (NSMutableArray<CoinModel *> *)shouldDisplayTokenCoinModelArray {
    
    NSMutableArray<CoinModel *> *coinList = [[CoinModel coin] getOpenCoinList];
    
    NSMutableArray *coins = [[NSMutableArray alloc] init];
    for (CoinModel *coinModel in coinList) {
        if ([@"1" isEqualToString:coinModel.type]) {
            [coins addObject:coinModel];
        }
    }
    return coins;
    
}

+ (CoinModel *)getCoinModel:(NSString *)symbol {
    CoinModel *coinModel;
    
    for (CoinModel *coin in [self shouldDisplayCoinModelArray]) {
        if ([symbol isEqualToString:coin.symbol]) {
            coinModel = coin;
            break;
        }
    }
    
    return coinModel;
}

+ (void)refreshOpenCoinList:(RefreshOpenCoinListBlock)block
                    failure:(RefreshOpenCoinListFailureBlock)failure{
    TLNetworking *http = [TLNetworking new];
    http.code = @"802267";
    
    http.parameters[@"status"] = @"0";
    
    http.isUploadToken = NO;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSMutableArray *coinList = responseObject[@"data"];
        
        [[CoinModel coin] saveOpenCoinList:coinList];
       

    
        
        if (block) {
            block();
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
    }];
}



@end
