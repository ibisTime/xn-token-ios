//
//  PublishService.m
//  Coin
//
//  Created by  tianlei on 2017/12/07.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PublishService.h"
#import "OverTimeModel.h"
#import "LangSwitcher.h"
#import "TLNetworking.h"
#import "KeyValueModel.h"

NSString *const kSaveDraft = @"0";
NSString *const kPublish = @"1";
NSString *const kPublishDraft = @"2";
NSString *const kPublishRedit = @"3";


NSString *const kPublishTradeTypeSell = @"1";
NSString *const kPublishTradeTypeBuy = @"0";


@interface PublishService()

@property (nonatomic, strong) NSMutableArray <NSString *> *limitTimes;

@end

@implementation PublishService

+ (NSString *)publishCodeByType:(PublishType) type {
    

    switch (type) {
        case PublishTypePublish: {
            
            return kPublish;
            
        }  break;
            
        case PublishTypeSaveDraft: {
            
            return kSaveDraft;
            
        }  break;
            
        case PublishTypePublishDraft: {
            
            return kPublishDraft;
            
        }  break;
            
        case PublishTypePublishRedit: {
            
            return   kPublishRedit;
            
        }  break;

    }
    
    return nil;
    
}

+ (instancetype)shareInstance {
    
    static PublishService *publishService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        publishService = [[PublishService alloc] init];
        
    });
    
    return publishService;
    
}

- (void)configWith:(NSString *)tradeType {
    
    self.tradeType = tradeType;
    
    if([tradeType isEqualToString:kPublishTradeTypeBuy]) {
        //买
        
        self.balanceHeight = 0;
        self.publishTitle = [LangSwitcher switchLang:@"发布购买" key:nil];
        self.ads_hint_key = @"buy_ads_hint";
        
    } else if([tradeType isEqualToString:kPublishTradeTypeSell]) {
        //卖
        self.balanceHeight = 25;
        self.publishTitle = [LangSwitcher switchLang:@"发布卖出" key:nil];
        self.ads_hint_key = @"sell_ads_hint";
        
    } else {
        
        @throw [NSException exceptionWithName:@"不支持的交易类型"
                                       reason:nil
                                     userInfo:nil];
    }
    
}


- (void)handleHint:(id)res {
    
    NSArray <KeyValueModel *> *keyValues = [KeyValueModel tl_objectArrayWithDictionaryArray:res[@"data"][@"list"]];
    [keyValues enumerateObjectsUsingBlock:^(KeyValueModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self setValue:obj.cvalue forKey:obj.ckey];
        
    }];
    
}





- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"%@ 未发现的key",self);
}


- (NSArray <NSString *> *)obtainLimitTimes {
    
    return self.limitTimes;
}

- (void)handleOutLimitTime:(NSArray *)arr{
    
    
    NSArray <OverTimeModel *>*data = [OverTimeModel tl_objectArrayWithDictionaryArray:arr];
    
    self.limitTimes = [[NSMutableArray alloc] init];
    
    
    [[data reversedArray]  enumerateObjectsUsingBlock:^(OverTimeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.limitTimes addObject:obj.dvalue];
        
        
    }];
        
}



//errorInfo" : "成功",
//"data" : {
//    "totalCount" : 10,
//    "totalPage" : 1,
//    "list" : [
//              {
//                  "cvalue" : "开启后，仅限与自己信任的用户与本广告交易",
//                  "remark" : "仅限受信任的交易者",
//                  "id" : 74,
//                  "ckey" : "trust",
//                  "companyCode" : "CD-COIN000017",
//                  "type" : "buy_ads_hint",
//                  "updateDatetime" : "Dec 22, 2017 4:04:42 PM",
//                  "systemCode" : "CD-COIN000017",
//                  "updater" : "admin"
//              },
//              {
//                  "cvalue" : "您希望广告自动显示和隐藏的天数和小时数。",
//                  "remark" : "广告展示时间",
//                  "id" : 73,
//                  "ckey" : "displayTime",
//                  "companyCode" : "CD-COIN000017",
//                  "type" : "buy_ads_hint",
//                  "updateDatetime" : "Dec 22, 2017 4:04:42 PM",
//                  "systemCode" : "CD-COIN000017",
//                  "updater" : "admin"
//              },
//              {
//                  "cvalue" : "广告最高可成交的价格，可帮助您在价格剧烈波动时保持稳定的盈利，比如最高为5000时，市场价高于5000以下时，您的广告依旧以5000的价格展示。",
//                  "remark" : "买币保护价说明",
//                  "id" : 72,
//                  "ckey" : "protectPrice",
//                  "companyCode" : "CD-COIN000017",
//                  "type" : "buy_ads_hint",
//                  "updateDatetime" : "Dec 22, 2017 4:04:42 PM",
//                  "systemCode" : "CD-COIN000017",
//                  "updater" : "admin"
//              },
//              {
//                  "cvalue" : "广告想要购买的数字货币的总量。",
//                  "remark" : "买币交易总量说明",
//                  "id" : 71,
//                  "ckey" : "totalCount",
//                  "companyCode" : "CD-COIN000017",
//                  "type" : "buy_ads_hint",
//                  "updateDatetime" : "Dec 22, 2017 4:04:42 PM",
//                  "systemCode" : "CD-COIN000017",
//                  "updater" : "admin"
//              },
//              {
//                  "cvalue" : "您希望对方在此期限内付款。",
//                  "remark" : "买币付款期限说明",
//                  "id" : 70,
//                  "ckey" : "payLimit",
//                  "companyCode" : "CD-COIN000017",
//                  "type" : "buy_ads_hint",
//                  "updateDatetime" : "Dec 22, 2017 4:04:42 PM",
//                  "systemCode" : "CD-COIN000017",
//                  "updater" : "admin"
//              },
//              {
//                  "cvalue" : "您需指定最有效的付款方式，帮助对方更快的与你达成交易。",
//                  "remark" : "买币支付方式说明",
//                  "id" : 69,
//                  "ckey" : "payType",
//                  "companyCode" : "CD-COIN000017",
//                  "type" : "buy_ads_hint",
//                  "updateDatetime" : "Dec 22, 2017 4:04:42 PM",
//                  "systemCode" : "CD-COIN000017",
//                  "updater" : "admin"
//              },
//              {
//                  "cvalue" : "一次交易中的最大交易限制，您的钱包余额也会影响最大量的设置。",
//                  "remark" : "买币最大交易额说明",
//                  "id" : 68,
//                  "ckey" : "maxTrade",
//                  "companyCode" : "CD-COIN000017",
//                  "type" : "buy_ads_hint",
//                  "updateDatetime" : "Dec 22, 2017 4:04:42 PM",
//                  "systemCode" : "CD-COIN000017",
//                  "updater" : "admin"
//              },
//              {
//                  "cvalue" : "一次交易最低的交易限制",
//                  "remark" : "买币最小交易额说明",
//                  "id" : 67,
//                  "ckey" : "minTrade",
//                  "companyCode" : "CD-COIN000017",
//                  "type" : "buy_ads_hint",
//                  "updateDatetime" : "Dec 22, 2017 4:04:42 PM",
//                  "systemCode" : "CD-COIN000017",
//                  "updater" : "admin"
//              },
//              {
//                  "cvalue" : "基于比例得出的报价，每10分钟更新一次。",
//                  "remark" : "买币价格说明",
//                  "id" : 66,
//                  "ckey" : "price",
//                  "companyCode" : "CD-COIN000017",
//                  "type" : "buy_ads_hint",
//                  "updateDatetime" : "Dec 22, 2017 4:04:42 PM",
//                  "systemCode" : "CD-COIN000017",
//                  "updater" : "admin"
//              },
//              {
//                  "cvalue" : "基于市场价的溢出比例，市场价是根据部分大型交易所实时价格得出的，确保您的报价趋于一个相对合理的范围，比如当前价格为8000，溢价比例为10%，那么价格为8800。",
//                  "remark" : "买币溢价率说明",
//                  "id" : 65,
//                  "ckey" : "premiumRate",
//                  "companyCode" : "CD-COIN000017",
//                  "type" : "buy_ads_hint",
//                  "updateDatetime" : "Dec 22, 2017 4:04:42 PM",
//                  "systemCode" : "CD-COIN000017",
//                  "updater" : "admin"
//              }
//              ],
//    "pageSize" : 30,
//    "pageNO" : 1,
//    "start" : 0
//},
//"errorCode" : "0"
//}




@end


