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

// < 1.1.1之间
//DRAFT("0", "草稿"), DAIJIAOYI("1", "待交易"), JIAOYIZHONG("2", "交易中"), XIAJIA(
//                                                                         "3", "已下架");

// >= 1.1.1之间
//DRAFT("0", "草稿"), SHANGJIA("1", "已上架"), XIAJIA("2", "已下架");

//

 NSString *const kOnlyTrustYes = @"1";
 NSString *const kOnlyTrustNO = @"0";

//
NSString *const kAdsStatusDraft =  @"0";
NSString *const kAdsStatusXiaJia =  @"2";

//NSString *const kAdsStatusDaiJiaoYi =  @"1";
//NSString *const kAdsStatusJiaoYiZhong =  @"2";

NSString *const kAdsStatusShangJia = @"1";

//
NSString *const kAdsTradeTypeBuy = @"0";
NSString *const kAdsTradeTypeSell = @"1";

@implementation AdvertiseModel

+ (NSDictionary *)objectClassInArray{
    
    return @{@"displayTime" : [Displaytime class]};
}

- (AdsType)adsType {
    
    return [self.tradeType isEqualToString:kAdsTradeTypeSell] ? AdsTradeTypeSell : AdsTradeTypeBuy;
    
}

- (NSString *)statusTitle {
    
    NSDictionary *dict = @{
                           kAdsStatusDraft: @"发布",
//                           kAdsStatusDaiJiaoYi: @"查看",
//                           kAdsStatusJiaoYiZhong: @"查看",
                           kAdsStatusShangJia : @"查看",
                           kAdsStatusXiaJia: @"已下架",
                           };
    
    return [LangSwitcher switchLang:dict[self.status] key:nil];
}


- (BOOL)isMineAds {
    
    return
    [TLUser user].userId != nil &&
    [TLUser user].userId.length != 0 &&
    [self.userId isEqualToString:[TLUser user].userId];
    
}

- (BOOL)isMineShangJiaAds {
    
   return [self isMineAds] && [self.status isEqualToString:kAdsStatusShangJia];

}


+ (NSString *)calculateTruePriceByPreYiJia:(float)yiJiaRate marketPrice:(float)marketPrice {
    
    float prePrice = marketPrice*(yiJiaRate + 1);
    return  [NSString stringWithFormat:@"%.2lf", prePrice - 0.005];
    
    
}



//- (BOOL)isMineJiaoYiZhong {
//
//    return [self isMineAds] && [self.status isEqualToString:kAdsStatusJiaoYiZhong];
//
//}
//
//- (BOOL)isMineDaiJiaoYiAds {
//
//    return [self isMineAds] && [self.status isEqualToString:kAdsStatusDaiJiaoYi];
//
//}

- (NSString *)tradeAmountLimit {
    
    return [NSString stringWithFormat:@"限额: %@-%@ ",
            [self.minTrade convertToSimpleRealMoney],
            [self.maxTrade convertToSimpleRealMoney]];
}

@end




@implementation Displaytime

+ (instancetype)defaultTime {
    
    Displaytime *time = [[Displaytime alloc] init];
    time.startTime = 0;
    time.endTime = 24;
    return time;
    
}

- (NSDictionary *)toDict {
    
    NSDictionary *dict = @{
                           @"week" : self.week,
                           @"startTime" : [NSString stringWithFormat:@"%ld",self.startTime],
                           @"endTime" : [NSString stringWithFormat:@"%ld",self.endTime],
                           };
    
    return dict;
    
}



@end
