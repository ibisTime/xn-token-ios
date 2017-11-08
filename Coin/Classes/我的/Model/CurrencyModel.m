//
//  CurrencyModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/13.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CurrencyModel.h"

NSString *const kJF  = @"JF";
NSString *const kCNY = @"CNY";


@implementation CurrencyModel

- (NSString *)getTypeName {
    
    NSDictionary *dict = @{
                           kCNY : @"CNY",
                           kJF : @"JF",
                          
                           };
    
    return dict[self.currency];
    
}

@end
