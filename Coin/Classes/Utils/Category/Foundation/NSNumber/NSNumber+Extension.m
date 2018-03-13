//
//  NSNumber+Extension.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NSNumber+Extension.h"

@implementation NSNumber (Extension)

- (NSString *)convertToRealMoney {
    
    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
    }
    
    long long m = [self longLongValue];
    double value = m/1.0;
    
    NSString *tempStr =  [NSString stringWithFormat:@"%.3f",value];
    NSString *subStr = [tempStr substringWithRange:NSMakeRange(0, tempStr.length - 1)];
    
    //  return [NSString stringWithFormat:@"%.2f",value];
    return subStr;
    
}

- (NSString *)convertToSimpleRealCoin {
    
    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
        
    }
    
    //保留8位小数,第九位舍去
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:8 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSDecimalNumber *m = [NSDecimalNumber decimalNumberWithString:[self stringValue]];
    
    NSDecimalNumber *n = [NSDecimalNumber decimalNumberWithString:[@(1.0e+18) stringValue]];
    
    NSDecimalNumber *o = [m decimalNumberByDividingBy:n];
    
    NSDecimalNumber *p = [o decimalNumberByRoundingAccordingToBehavior:handler];
    
    return [NSString stringWithFormat:@"%@",p];
}

//能去掉小数点的尽量去掉小数点
- (NSString *)convertToSimpleRealMoney {
    
    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
        
    }
    
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];

    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:[self stringValue]];
    
    NSDecimalNumber *result = [price decimalNumberByRoundingAccordingToBehavior:handler];

    return [result stringValue];

}

- (NSString *)convertToRealMoneyWithNum:(NSInteger)num {
    
    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
    }
    
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:num raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:[self stringValue]];
    
    NSDecimalNumber *result = [price decimalNumberByRoundingAccordingToBehavior:handler];
    
    return [result stringValue];
    
}

//折扣
- (NSString *)convertToCountMoney {
    
    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
    }
    
    long long m = [self doubleValue]*10000;
    
    double value = m*10.0/10000.0;
    
    if (m%10 > 0) { //有厘
        
        return [NSString stringWithFormat:@"%.2f",value];
        
    } else if (m%100 > 0) {//有分
        
        return [NSString stringWithFormat:@"%.2f",value];
        
    } else if(m%1000 > 0) { //有角
        
        return [NSString stringWithFormat:@"%.1f",value];
        
    } else {//元
        
        return [NSString stringWithFormat:@"%.0f",value];
    }
    
    
}

//减法
- (NSString *)subNumber:(NSNumber *)number {
    
    //保留8位小数,第九位舍去
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:8 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSDecimalNumber *m = [NSDecimalNumber decimalNumberWithString:[self stringValue]];
    
    NSDecimalNumber *n = [NSDecimalNumber decimalNumberWithString:[number stringValue]];
    
    NSDecimalNumber *o = [m decimalNumberBySubtracting:n];
    
    NSDecimalNumber *p = [o decimalNumberByRoundingAccordingToBehavior:handler];
    
    return [NSString stringWithFormat:@"%@",p];
}

@end
