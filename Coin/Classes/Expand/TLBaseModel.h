//
//  TLBaseModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"

@interface TLBaseModel : NSObject<MJKeyValue>

/**
 通过字典获取一个模型
 */
+ (instancetype)tl_objectWithDictionary:(NSDictionary *)dictionary;

/**
 * 数组模型转换为对象模型
 */
+ (NSMutableArray *)tl_objectArrayWithDictionaryArray:(id)dictionaryArray;

/**
 * 对属性名称进行替换，key 模型属性的名称，value去字典里取值的key
 */
+ (NSDictionary *)tl_replacedKeyFromPropertyName;


@end
