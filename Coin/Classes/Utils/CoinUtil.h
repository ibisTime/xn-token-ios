//
//  CoinUtil.h
//  Coin
//
//  Created by  tianlei on 2017/12/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CoinType) {
    
    CoinTypeETH = 0,
    CoinTypeBTC = 1
    
};

@interface CoinUtil : NSObject

/**
 把最小单位的数字货币字符串，100000.....转化为1.00000这种格式
 */
+ (NSString *)convertToRealCoin:(NSString *)count coin:(NSString *)coin;

/**
 把1.000 转换为最基本单位 100000000000.....
 */
+ (NSString *)convertToSysCoin:(NSString *)count coin:(NSString *)coin;

+ (NSArray *)shouldDisplayCoinArray;

+ (NSString *)chineseName:(NSString *)coin;

@end


FOUNDATION_EXTERN NSString *const kBTC;
FOUNDATION_EXTERN NSString *const kETH;
FOUNDATION_EXTERN NSString *const kSC;

FOUNDATION_EXTERN NSString *const kCNY;


