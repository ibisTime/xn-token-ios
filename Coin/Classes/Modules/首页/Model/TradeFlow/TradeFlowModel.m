//
//  TradeFlowModel.m
//  OGC
//
//  Created by 蔡卓越 on 2018/3/14.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TradeFlowModel.h"

@implementation TradeFlowModel
+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"code"]) {
        return @"hash";
    }
    
    return propertyName;
}

@end
