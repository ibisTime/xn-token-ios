//
//  AdvertiseModel.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AdvertiseModel.h"
#import "TLUser.h"
#import "NSNumber+Extension.h"
#import "NSString+Extension.h"

//DRAFT("0", "草稿"), DAIJIAOYI("1", "待交易"), JIAOYIZHONG("2", "交易中"), XIAJIA(
//                                                                         "3", "已下架");
NSString *const kAdsStatusDraft =  @"0";
NSString *const kAdsStatusDaiJiaoYi =  @"1";
NSString *const kAdsStatusJiaoYiZhong =  @"2";
NSString *const kAdsStatusXiaJia =  @"3";

NSString *const kTradeTypeBuy = @"0";
NSString *const kTradeTypeSell = @"1";

@implementation AdvertiseModel

+ (NSDictionary *)objectClassInArray{
    
    return @{@"displayTime" : [Displaytime class]};
}

- (AdsType)adsType {
    
    return [self.tradeType isEqualToString:@"1"] ? AdsTradeTypeSell : AdsTradeTypeBuy;
    
}

- (NSString *)statusTitle {
    
    NSDictionary *dict = @{
                           @"0": @"发布",
                           @"1": @"查看",
                           @"2": @"查看",
                           @"3": @"已下架",
                           };
    
    return dict[self.status];
}


- (BOOL)isMineAds {
    
    return [TLUser user].userId != nil && [TLUser user].userId.length != 0 && [self.userId isEqualToString:[TLUser user].userId];
    
}

- (BOOL)isMineDaiJiaoYiAds {
    
    return [self isMineAds] && [self.status isEqualToString:kAdsStatusDaiJiaoYi];
    
}

@end

@implementation TradeUserInfo

@end

@implementation UserStatistics


- (NSString *)goodCommentRate {
    
    if (self.beiHaoPingCount == 0) {
        
        return @"0%";
    }
    
    CGFloat rate = 100*self.beiHaoPingCount/(self.beiPingJiaCount*1.0);
    
    NSString *rateStr = [NSString stringWithFormat:@"%.0lf%%", rate];
    
    return rateStr;
}

- (NSString *)convertTotalTradeCount {
    
    if (!self.totalTradeCount || self.totalTradeCount.length == 0) {
        return nil;
    }
    
    NSString *realNum = [self.totalTradeCount convertToSimpleRealCoin];
    
    CGFloat historyNum = [[realNum convertToRealMoneyWithNum:8] doubleValue];
    
    //判断个数
    NSString *history = @"";
    
    if (historyNum == 0) {
        
        history = @"0 ETH";
        
    } else if (historyNum > 0 && historyNum <= 0.5) {
        
        history = @"0-0.5 ETH";
        
    } else if (historyNum > 0.5 && historyNum <= 1) {
        
        history = [NSString stringWithFormat:@"0.5-1 ETH"];
        
    } else if (historyNum > 1) {
        
        history = [NSString stringWithFormat:@"%@+ ETH", [realNum convertToRealMoneyWithNum:0]];
    }
    
    //
    return history;
    
}

@end

@implementation Displaytime

@end
