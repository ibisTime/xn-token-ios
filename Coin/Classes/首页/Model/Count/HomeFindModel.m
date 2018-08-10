//
//  HomeFindModel.m
//  Coin
//
//  Created by shaojianfei on 2018/8/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "HomeFindModel.h"

@implementation HomeFindModel
MJCodingImplementation
+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"Description"]) {
        return @"description";
    }
    
    return propertyName;
}
@end
