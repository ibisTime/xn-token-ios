//
//  TradeBuyVC.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

#import "AdvertiseModel.h"

typedef NS_ENUM(NSInteger, TradeBuyPositionType) {
    
    TradeBuyPositionTypeTrade = 0,  //交易区
    TradeBuyPositionTypeMyPublish,  //我发布的
};

// 我要购买， 广告为出售广告
@interface TradeBuyVC : TLBaseVC


@property (nonatomic, copy) NSString *adsCode;

@property (nonatomic, assign) TradeBuyPositionType type;

@end
