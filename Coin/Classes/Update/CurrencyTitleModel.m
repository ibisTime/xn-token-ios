//
//  CurrencyTitleModel.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//
#import <MJExtension.h>
#import "CurrencyTitleModel.h"

@implementation CurrencyTitleModel

MJCodingImplementation;

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"ID"]) {
        return @"id";
    }
    
    return propertyName;
}

@end
