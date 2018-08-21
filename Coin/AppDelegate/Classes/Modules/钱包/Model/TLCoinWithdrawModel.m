//
//  TLCoinWithdrawModel.m
//  Coin
//
//  Created by  tianlei on 2018/1/17.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLCoinWithdrawModel.h"

@implementation TLCoinWithdrawModel

- (NSString *)statusName {
    
//    toApprove("1", "待审批"),
//    Approved_NO("2", "审批不通过"),
//    Approved_YES("3", "审批通过待广播"),
//    Broadcast("4", "广播中"),
//    Pay_NO("5", "广播失败"),
//    Pay_YES("6", "广播成功");
    
    NSDictionary *dict = @{
                           @"1" : @"待审批",
                           @"2" : @"审批不通过",
                           @"3" : @"审批通过待广播",
                           @"4" : @"广播中",
                           @"5" : @"广播失败",
                           @"6" : @"广播成功"
                        
                           };
    
    return dict[self.status];
    
    
}

@end
