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

@implementation OrderModel

- (NSString *)statusStr {
    
    NSDictionary *dict = @{
                           
                           @"-1": [LangSwitcher switchLang:@"待下单" key:nil] ,
                           @"0": [LangSwitcher switchLang:@"待支付" key:nil] ,
                           @"1": [LangSwitcher switchLang:@"待释放" key:nil]  ,
                           @"2": [LangSwitcher switchLang:@"待评价" key:nil]  ,
                           @"3": [LangSwitcher switchLang:@"已完成" key:nil]   ,
                           @"4": [LangSwitcher switchLang:@"已取消" key:nil]  ,
                           @"5": [LangSwitcher switchLang:@"仲裁中" key:nil]  ,
                           
                           };
    
    return dict[self.status];
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
    
    NSInteger status = [self.status integerValue];
    
    switch (status) {
        case 0:
        {
            title = self.isBuy ? @"标记已打款":@"等待标记打款";
            
            self.bgColor = self.isBuy ? kThemeColor: kPlaceholderColor;
            
            self.enable = self.isBuy ? YES: NO;
            
        }break;
           
        case 1:
        {
            title = self.isBuy ? @"等待释放货币":@"释放货币";
            
            self.bgColor = self.isBuy ? kPlaceholderColor: kThemeColor;
            
            self.enable = self.isBuy ? NO: YES;

        }break;
            
        case 2:
        {
            if (self.isBuy && [self.bsComment valid]){
                
                title = @"买家已评价";
                
                self.enable = NO;
                
                self.bgColor = kPlaceholderColor;
                
                return title;
            }
            
            if (!self.isBuy && [self.sbComment valid]){
                
                title = @"卖家已评价";
                
                self.enable = NO;
                
                self.bgColor = kPlaceholderColor;
                
                return title;
            }
            
            if ((![self.bsComment valid] && self.isBuy) || (![self.sbComment valid] && !self.isBuy)) {
                
                title = @"交易评价";

                self.bgColor = kThemeColor;

                self.enable = YES;

                return title;
            }

        }break;
            
        case 3:
        {
            title = @"查看钱包";
            
            self.bgColor = kThemeColor;

            self.enable = YES;

        }break;
          
        case 4:
        {
            title = @"已取消";
            
            self.bgColor = kPlaceholderColor;

            self.enable = NO;

        }break;
            
        case 5:
        {
            title = @"仲裁中";
            
            self.bgColor = kPlaceholderColor;

            self.enable = NO;

        }break;
            
        default:
            break;
    }
    
    return title;
}

- (NSString *)promptStr {
    
    NSString *title = @"";
    
     if (self.isBuy && [self.bsComment valid]){
        
        title = @"买家已评价, 等待卖家评价";
        
    } else if (!self.isBuy && [self.sbComment valid]){
        
        title = @"卖家已评价, 等待买家评价";
        
    } else if ((![self.bsComment valid] && self.isBuy) || (![self.sbComment valid] && !self.isBuy)) {
        
        title = @"已释放货币, 请对交易做出评价";
    
    }

    NSDictionary *dict = @{
                           @"2": title,
                           @"3": @"交易成功, 已评价交易",
                        
                           };
    
    return dict[self.status];
}

@end

@implementation SellUserInfo

@end


@implementation BuyUserInfo

@end
