//
//  OrderModel.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "OrderModel.h"
#import "TLUser.h"
#import "NSString+Check.h"


//TO_SUBMIT("-1", "代下单"), TO_PAY("0", "待支付"), PAYED("1", "已支付待释放"), RELEASED(
//                                                                           "2", "已释放待评价"), COMPLETE("3", "已完成"), CANCEL("4", "已取消"), ARBITRATE(
//                                                                                                                                               "5", "仲裁中");

 NSString * const kTradeOrderStatusToSubmit = @"-1";
 NSString * const kTradeOrderStatusToPay = @"0";
 NSString * const kTradeOrderStatusPayed  = @"1";
 NSString * const kTradeOrderStatusReleased  = @"2";
 NSString * const kTradeOrderStatusComplete  = @"3";
 NSString * const kTradeOrderStatusCancel  = @"4";
 NSString * const kTradeOrderStatusArbitrate  = @"5";

@implementation OrderModel

- (NSString *)statusStr {
    
    NSDictionary *dict = @{
                           
                           kTradeOrderStatusToSubmit:@"待下单" ,
                           kTradeOrderStatusToPay: @"待支付" ,
                           kTradeOrderStatusPayed: @"待释放",
                           kTradeOrderStatusReleased: @"待评价",
                           kTradeOrderStatusComplete: @"已完成",
                           kTradeOrderStatusCancel: @"已取消",
                           kTradeOrderStatusArbitrate: @"仲裁中"
                           
                           };
    
    return [LangSwitcher switchLang:dict[self.status] key:nil];
}

+ (NSArray *)endStatusList {
    
    return @[@"2", @"3", @"4"];
    
}

+ (NSArray *)ingStatusList {
    
    return @[@"-1", @"0", @"1", @"5"];

}

- (BOOL)isBuy {
    
    if ([self.buyUserInfo.userId isEqualToString:[TLUser user].userId]) {
        
        _isBuy = YES;
        
    } else {
        
        _isBuy = NO;
        
    }
    
    return _isBuy;
}

- (NSString *)btnTitle {
    
    NSString *title = @"";

    if ([self.status isEqualToString:kTradeOrderStatusToPay]) {
        
        title = self.isBuy ? [LangSwitcher switchLang: @"标记已打款" key:nil] : [LangSwitcher switchLang: @"等待标记打款" key:nil];
        self.bgColor = self.isBuy ? kThemeColor: kPlaceholderColor;
        self.enable = self.isBuy ? YES: NO;
        
    } else if ([self.status isEqualToString:kTradeOrderStatusPayed]) {
        
        title = self.isBuy ? [LangSwitcher switchLang:@"等待释放货币" key:nil] :
        [LangSwitcher switchLang:@"释放货币" key:nil];
        self.bgColor = self.isBuy ? kPlaceholderColor: kThemeColor;
        self.enable = self.isBuy ? NO: YES;
        
    } else if ([self.status isEqualToString:kTradeOrderStatusReleased]) {
        
        if (self.isBuy && [self.bsComment valid]){
            
            title = [LangSwitcher switchLang:@"买家已评价" key:nil];
            self.enable = NO;
            self.bgColor = kPlaceholderColor;
            return title;
            
        }
        
        if (!self.isBuy && [self.sbComment valid]){
            
            title = [LangSwitcher switchLang:@"卖家已评价" key:nil] ;
            self.enable = NO;
            self.bgColor = kPlaceholderColor;
            return title;
            
        }
        
        if ((![self.bsComment valid] && self.isBuy) ||
            (![self.sbComment valid] && !self.isBuy)) {
            
            title = [LangSwitcher switchLang:@"交易评价" key:nil];
            self.bgColor = kThemeColor;
            self.enable = YES;
            return title;
            
        }
        
    } else if ([self.status isEqualToString:kTradeOrderStatusComplete]) {
        
        title = [LangSwitcher switchLang: @"查看钱包" key:nil];
        self.bgColor = kThemeColor;
        self.enable = YES;
        
    } else if ([self.status isEqualToString:kTradeOrderStatusCancel]) {
        
        title = [LangSwitcher switchLang:@"已取消" key:nil];
        self.bgColor = kPlaceholderColor;
        self.enable = NO;
        
    } else if ([self.status isEqualToString:kTradeOrderStatusArbitrate]) {
        
        title = [LangSwitcher switchLang:@"仲裁中" key:nil];
        self.bgColor = kPlaceholderColor;
        self.enable = NO;
        
    }

    return title;
}

- (NSString *)promptStr {
    
    NSString *title = @"";
    
     if (self.isBuy && [self.bsComment valid]){
        
        title = [LangSwitcher switchLang:@"买家已评价, 等待卖家评价" key:nil];
        
    } else if (!self.isBuy && [self.sbComment valid]){
        
        title = [LangSwitcher switchLang:@"卖家已评价, 等待买家评价" key:nil];
        
    } else if ((![self.bsComment valid] && self.isBuy) ||
               (![self.sbComment valid] && !self.isBuy)) {
        
        title = [LangSwitcher switchLang:@"已释放货币, 请对交易做出评价" key:nil];
    
    }

    NSDictionary *dict = @{
                      
                           kTradeOrderStatusReleased: title,
                           kTradeOrderStatusComplete: [LangSwitcher switchLang: @"交易成功, 已评价交易" key:nil],
                        
                           };
    
    return dict[self.status];
}

@end


