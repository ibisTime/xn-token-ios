//
//  TradeSellVC.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "AdvertiseModel.h"

typedef NS_ENUM(NSInteger, TradeSellPositionType) {
    
    TradeSellPositionTypeTrade = 0,  //交易区
    TradeSellPositionTypeMyPublish,  //我发布的
};

@interface TradeSellVC : TLBaseVC

@property (nonatomic, strong) AdvertiseModel *advertise;

@property (nonatomic, assign) TradeSellPositionType type;

@end
