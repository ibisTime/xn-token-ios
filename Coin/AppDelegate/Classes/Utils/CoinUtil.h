//
//  CoinUtil.h
//  Coin
//
//  Created by  tianlei on 2017/12/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoinModel.h"

typedef NS_ENUM(NSUInteger, CoinType) {
    
    CoinTypeETH = 0,
    CoinTypeBTC = 1
    
};

@interface CoinUtil : NSObject

typedef void (^RefreshOpenCoinListBlock)();

typedef void (^RefreshOpenCoinListFailureBlock)();

/**
 把最小单位的数字货币字符串，100000.....转化为1.00000这种格式
 */
+ (NSString *)convertToRealCoin:(NSString *)count coin:(NSString *)coin;

/**
 100000.....转化为1.00000这种格式，可以指定小数位数
 */
+ (NSString *)convertToRealCoin:(NSString *)count coin:(NSString *)coin scale:(NSUInteger)scale;

/**
 把1.000 转换为最基本单位 100000000000.....
 */
+ (NSString *)convertToSysCoin:(NSString *)count coin:(NSString *)coin;

/**
 两个数相乘，可以指定小数位数
 */
+ (NSString *)mult1:(NSString *)mult1 mult2:(NSString *)mult2 scale:(NSUInteger)scale;

+ (NSArray *)shouldDisplayCoinArray;

+ (NSArray *)shouldDisplayOriginalCoinArray;

+ (NSArray *)shouldDisplayTokenCoinArray;

+ (NSMutableArray<CoinModel *> *)shouldDisplayCoinModelArray;

+ (NSMutableArray<CoinModel *> *)shouldDisplayOriginalCoinModelArray;

+ (NSMutableArray<CoinModel *> *)shouldDisplayTokenCoinModelArray;

+ (CoinModel *)getCoinModel:(NSString *)symbol;

+ (NSString *)chineseName:(NSString *)coin;

+ (void)refreshOpenCoinList:(RefreshOpenCoinListBlock)block
                    failure:(RefreshOpenCoinListFailureBlock)failure;
@end


FOUNDATION_EXTERN NSString *const kBTC;
FOUNDATION_EXTERN NSString *const kETH;
FOUNDATION_EXTERN NSString *const kSC;
FOUNDATION_EXTERN NSString *const kOGC;

FOUNDATION_EXTERN NSString *const kCNY;


