//
//  BillModel.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BillModel.h"
#import "AppColorMacro.h"
#import "NSString+CGSize.h"
#import "LangSwitcher.h"

@implementation BillModel

- (NSString *)getStatusName {
    
    NSDictionary *dict = @{
                           
                           @"1" : [LangSwitcher switchLang:@"待对账" key:nil],
                           @"3" :[LangSwitcher switchLang:@"已对账且账已平" key:nil] ,
                           @"4":[LangSwitcher switchLang:@"帐不平待调账审批" key:nil] ,
                           @"5" :[LangSwitcher switchLang:@"已对账且账不平" key:nil] ,
                           @"6" :[LangSwitcher switchLang:@"无需对账" key:nil] ,
                           
                           };
    
    return dict[self.status];
    
}

- (NSString *)getBizName {
    NSDictionary *dict = @{
                           
                          
                           @"charge" : [LangSwitcher switchLang: [NSString stringWithFormat:@"%@充值",self.currency] key:nil],
                           @"withdraw" : [LangSwitcher switchLang: [NSString stringWithFormat:@"%@取现",self.currency] key:nil] ,
                           @"autofill": [LangSwitcher switchLang:@"自动补给" key:nil]  ,
                           @"buy": [LangSwitcher switchLang:@"交易买入" key:nil]  ,
                           @"sell" : [LangSwitcher switchLang:@"交易卖出" key:nil],
                           @"tradefrozen" :[LangSwitcher switchLang:@"交易冻结" key:nil],
                           @"tradeunfrozen" :[LangSwitcher switchLang:@"交易解冻" key:nil],
                           @"withdrawfrozen":[LangSwitcher switchLang:@"取现冻结" key:nil],
                           @"withdrawunfrozen":[LangSwitcher switchLang:@"取现解冻" key:nil],
                           @"tradefee" : [LangSwitcher switchLang:@"交易手续费" key:nil] ,
                           @"withdrawfee" : [LangSwitcher switchLang:@"提现手续费" key:nil] ,
                           @"invite" : [LangSwitcher switchLang:@"邀请好友送" key:nil]
                           };
    
    return dict[self.bizType];
    
}

@end
