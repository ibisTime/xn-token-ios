//
//  TradeSellVC.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AdsTradeDetailVC.h"
#import "AdvertiseModel.h"

//typedef NS_ENUM(NSInteger, TradeSellPositionType) {
//
//    TradeSellPositionTypeTrade = 0,  //交易区
//    TradeSellPositionTypeMyPublish,  //我发布的
//};


/**
 我要出售//
 购买广告
 */
@interface TradeSellVC : AdsTradeDetailVC

@property (nonatomic, copy) NSString  *adsCode;

//@property (nonatomic, assign) TradeSellPositionType type;

@end
