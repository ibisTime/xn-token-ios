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

- (NSString *)getBizName {
    NSDictionary *dict = @{
                           
                           @"charge" : @"ETH充值",
                           @"withdraw" : @"ETH取现",
                           @"buy": @"平台转入",
                           @"sell" : @"平台转出",
                           @"tradefee" : @"交易手续费",
                           @"withdrawfee" : @"提现手续费",
                           @"invite" : @"邀请好友送",
                           
                           };
    
    return dict[self.bizType];
    
}

- (NSString *)getImgName {
    
    NSDictionary *dict = @{
                           @"charge" : @"账单-充币",
                           @"withdraw" : @"账单-提币",
                           @"buy": @"账单-买入",
                           @"sell" : @"账单-卖出",
                           @"tradefee" : @"账单-手续费",
                           @"withdrawfee" : @"账单-手续费",
                           @"invite" : @"账单-活动奖励",
                           
                           };
    
    return dict[self.bizType];
}

//- (CGFloat)dHeightValue {
//    
//    CGFloat width = kScreenWidth - 15 - 40 - 15 - 36 - 15 - 15;
//
////    CGSize size = [self.bizNote calculateStringSize:CGSizeMake(width, MAXFLOAT) font:Font(14)];
//
//    CGSize size = [self.bizNote ca];
//    return size.height - [Font(14) lineHeight] + 3;
//
//}

@end
