//
//  NSDictionary+Extension.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)

//处理字典为NULL和字典元素为NULL情况
+ (NSDictionary *)convertNULLData:(NSDictionary *)sourceDic;

//字典转化为字符串
- (NSString *)getDictionaryOfSortString;

//支付宝参数
- (NSString *)getDictionaryOfPayString;

@end
