//
//  TLtakeMoneyModel.m
//  Coin
//
//  Created by shaojianfei on 2018/8/16.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLtakeMoneyModel.h"

@implementation TLtakeMoneyModel

-(NSString *)statusStr
{
    if (!_statusStr) {
        if ([_status isEqualToString:@"4"]) {
            _statusStr = @"即将开始";
        }else if ([_status isEqualToString:@"5"]) {
            _statusStr = @"认购中";
        }else if ([_status isEqualToString:@"6"]) {
            _statusStr = @"已售罄";
        }else if ([_status isEqualToString:@"7"]) {
            _statusStr = @"已售罄";
        }else if ([_status isEqualToString:@"8"]) {
            _statusStr = @"已到期";
        }
        else
        {
            _statusStr = @"敬请期待";
        }

    }
    return _statusStr;
}

@end
