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
#import "PublishService.h"

typedef NS_ENUM(NSUInteger, TLPublishVCType) {
    TLPublishVCTypeSell = 0,
    TLPublishVCTypeBuy = 1
};
// 卖币 还是 买币

@interface TLPublishVC : TLBaseVC

@property (nonatomic, strong) NSString *adsCode;


/**
 如果已经知道出事化是哪个币种，那就需要传进来币种，如果不穿初始化为ETH
 */
@property (nonatomic, copy) NSString *firstCoin;


//以下必须同时设置 
@property (nonatomic, assign) TLPublishVCType VCType;
@property (nonatomic, assign) PublishType publishType;

@end
