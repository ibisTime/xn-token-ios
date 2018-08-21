//
//  CoinQuotationModel.m
//  Coin
//
//  Created by 蔡卓越 on 2017/12/7.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CoinQuotationModel.h"
#import "AppColorMacro.h"

@implementation CoinQuotationModel

- (UIColor *)bgColor {
    
    CGFloat fluct = [self.percent_change_24h doubleValue];
    
    return fluct >= 0 ? kThemeColor: kRiseColor;
}

@end
