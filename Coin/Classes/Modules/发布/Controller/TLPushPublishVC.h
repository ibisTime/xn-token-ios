//
//  TLPublishSellVC.h
//  Coin
//
//  Created by  tianlei on 2018/1/03.
//  Copyright © 2018年  tianlei. All rights reserved.
//   1.增加行情市场价格显示
//   2.买币广告需要实名认证
//   3.

#import "TLBaseVC.h"
#import "PushPublishService.h"

typedef NS_ENUM(NSUInteger, TLPushPublishVCType) {
    TLPushPublishVCTypeSell = 0,
    TLPushPublishVCTypeBuy = 1
};
// 卖币 还是 买币

@interface TLPushPublishVC : TLBaseVC

@property (nonatomic, strong) NSString *adsCode;


/**
 如果已经知道出事化是哪个币种，那就需要传进来币种，如果不穿初始化为ETH
 */
@property (nonatomic, copy) NSString *firstCoin;


//以下必须同时设置 
@property (nonatomic, assign) TLPushPublishVCType VCType;
@property (nonatomic, assign) PushPublishType publishType;

@end
