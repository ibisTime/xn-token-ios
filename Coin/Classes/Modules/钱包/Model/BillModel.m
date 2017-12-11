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

@implementation BillModel

- (NSString *)getStatusName {
    
    NSDictionary *dict = @{
                           
                           @"1" : @"待对账",
                           @"3" : @"已对账且账已平",
                           @"4": @"帐不平待调账审批",
                           @"5" : @"已对账且账不平",
                           @"6" : @"无需对账",
                           
                           };
    
    return dict[self.status];
    
}

- (NSString *)getBizName {
    NSDictionary *dict = @{
                           
                           @"charge" : @"ETH充值",
                           @"withdraw" : @"ETH取现",
                           @"buy":  @"交易买入",
                           @"sell" : @"交易卖出",
                           @"tradefrozen" : @"交易冻结",
                           @"tradeunfrozen" : @"交易解冻",
                           @"withdrawfrozen": @"取现冻结",
                           @"withdrawunfrozen": @"取现解冻",
                           @"tradefee" : @"交易手续费",
                           @"withdrawfee" : @"提现手续费",
                           @"invite" : @"邀请好友送",
                           
                           };
    
    return dict[self.bizType];
    
}

@end
