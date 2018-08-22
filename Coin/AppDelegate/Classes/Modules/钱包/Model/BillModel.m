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
#import "utxoModel.h"
@implementation BillModel

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"Hashs"]) {
        return @"hash";
    }
    
    return propertyName;
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{
              @"vin" : [utxoModel class],
              @"vout" : [utxoModel class]
             };
    
}

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
                           @"withdrawfrozen":[LangSwitcher switchLang:@"取现冻结" key:nil],
                           @"withdrawunfrozen":[LangSwitcher switchLang:@"取现解冻" key:nil],
                           @"withdrawfee" : [LangSwitcher switchLang:@"提现手续费" key:nil] ,
                           @"o2o_in" : [LangSwitcher switchLang:@"o2o店铺消费收入" key:nil],
                           @"o2o_out" : [LangSwitcher switchLang:@"o2o店铺消费支出" key:nil],
                           @"transfer_in" : [LangSwitcher switchLang:@"转账收入" key:nil],
                           @"transfer_out" : [LangSwitcher switchLang:@"转账支出" key:nil]
                           ,
                           @"sendredpacket_out" : [LangSwitcher switchLang:@"发红包" key:nil],
                            @"redpacket_back" : [LangSwitcher switchLang:@"红包退回" key:nil],
                           @"sendredpacket_in" : [LangSwitcher switchLang:@"抢红包" key:nil],
                           @"lhlc_invest" : [LangSwitcher switchLang:@"量化理财投资" key:nil],
                           @"lhlc_repay" : [LangSwitcher switchLang:@"量化理财还款" key:nil],

                           
                           };
    
    return dict[self.bizType];
    
}

@end
