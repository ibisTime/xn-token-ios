//
//  TLBaseModel.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@implementation TLBaseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    NSDictionary *dict = [self tl_replacedKeyFromPropertyName];
    if (!dict.allKeys.count) {
        return nil;
    }
    return dict;
}

+ (NSDictionary *)tl_replacedKeyFromPropertyName
{
    return @{};
    
}

+ (instancetype)tl_objectWithDictionary:(NSDictionary *)dictionary
{
    return [self mj_objectWithKeyValues:dictionary];
}


+ (NSMutableArray *)tl_objectArrayWithDictionaryArray:(id)dictionaryArray;
{
    
    return [self mj_objectArrayWithKeyValuesArray:dictionaryArray];
    
}


@end
