//
//  PayTypeModel.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PayTypeModel.h"
#import "LangSwitcher.h"
#import "UIColor+Extension.h"

NSString *const kPayTypeWX = @"1";
NSString *const kPayTypeAliPay = @"0";
NSString *const kPayTypeBank = @"2";

#define WX @"微信"
#define ALI @"支付宝"
#define BANK @"银行卡"


@implementation PayTypeModel

- (void)setPayType:(NSString *)payType {
    
    _payType = payType;
    
    NSInteger index = [payType integerValue];
    
    switch (index) {
        case 0:
        {
            self.text = [LangSwitcher switchLang:ALI key:nil];
            self.color = [UIColor colorWithHexString:@"#48b0fb"];
            
        }break;
         
        case 1:
        {
            self.text = [LangSwitcher switchLang:WX key:nil];
            self.color = [UIColor colorWithHexString:@"#2ac64c"];

        }break;
            
        case 2:
        {
            self.text = [LangSwitcher switchLang:BANK key:nil];
            self.color = [UIColor colorWithHexString:@"#f15353"];

        }break;
            
        default:
            break;
    }
}

+ (NSArray <NSString *> *)payTypeNames {
    
    return @[
             [LangSwitcher switchLang:ALI key:nil],
             [LangSwitcher switchLang:WX key:nil],
             [LangSwitcher switchLang:BANK key:nil]
          ];
    
}


+ (NSString *)payNameByType:(NSString *)type {
    
    static NSDictionary *dict = nil;
    dict =  @{
              
              kPayTypeAliPay : [LangSwitcher switchLang:ALI key:nil],
              kPayTypeWX     : [LangSwitcher switchLang:WX key:nil],
              kPayTypeBank   : [LangSwitcher switchLang:BANK key:nil]
              
              };
    
    return dict[type];
    
}


//+ (NSString *)payType

@end
