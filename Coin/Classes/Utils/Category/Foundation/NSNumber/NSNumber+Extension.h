//
//  NSNumber+Extension.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Extension)

//转换金额
- (NSString *)convertToRealMoney;

//能去掉小数点的尽量去掉小数点
- (NSString *)convertToSimpleRealMoney;
//位数
- (NSString *)convertToRealMoneyWithNum:(NSInteger)num;

//- (NSString *)convertToSimpleRealCoin;

//- (NSString *)convertToCountMoney;
//减法
- (NSString *)subNumber:(NSNumber *)number;

@end
