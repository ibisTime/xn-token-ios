//
//  CurrencyModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/13.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CurrencyModel.h"
#import "CoinUtil.h"
#import "LangSwitcher.h"

NSString *const kCNY = @"CNY";




@implementation CurrencyModel

- (NSString *)getTypeName {
    
    NSDictionary *dict = @{
                           kETH : [LangSwitcher switchLang:@"以太币资产(ETH)" key:nil],
                          
                           };
    
    return dict[self.currency];
    
}

- (NSString *)getImgName {
    
    NSDictionary *dict = @{
                           kETH : @"以太币图标",
                           kBTC : @"比特币图标",
                           };
    
    return dict[self.currency];
    
}

@end
