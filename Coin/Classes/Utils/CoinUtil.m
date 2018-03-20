//
//  CoinUtil.m
//  Coin
//
//  Created by  tianlei on 2017/12/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CoinUtil.h"

NSString *const kETH = @"ETH";
NSString *const kSC = @"SC";
NSString *const kBTC = @"BTC";

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
    
    
    if ([coin isEqualToString:kETH]) {
        
        return @(1.0e+18);
        
    } else if ([coin isEqualToString:kBTC]) {
        
        return @(1.0e+8);
        
    } else if([coin isEqualToString:kSC]) {
        
        return @(1.0e+24);
    }
    
    return nil;
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
    
    NSDictionary *dict = @{
                           kETH : @"以太币",
                           kSC : @"云储币",
                           kBTC : @"比特币"
                           };
    
    return dict[coin];
}


+ (NSMutableArray<CoinModel *> *)shouldDisplayCoinArray {
    
    return [[CoinModel coin] getOpenCoinList];

}



@end
