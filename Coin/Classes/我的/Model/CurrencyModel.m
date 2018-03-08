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

//NSString *const kCNY = @"CNY";




@implementation CurrencyModel

- (NSString *)getTypeName {
    
    NSString *name =  [CoinUtil chineseName:self.currency];
    
    NSString *fullName = [NSString stringWithFormat:@"%@资产(%@)",name,self.currency];
    return [LangSwitcher switchLang:fullName key:nil];

}

- (NSString *)getImgName {
    
    NSDictionary *dict = @{
                           kETH : @"以太币图标",
                           kBTC : @"比特币图标",
                           kSC : @"云储币图标",
                           kOGC : @"橙币图标"
                           };
    
    
    return dict[self.currency] ? : @"以太币图标";
    
}

@end
