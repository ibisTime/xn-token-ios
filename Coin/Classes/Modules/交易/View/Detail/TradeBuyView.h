//
//  TradeBuyView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AdvertiseModel.h"

typedef NS_ENUM(NSInteger, TradeBuyType) {
    
    TradeBuyTypeTrust = 0,      //信任
    TradeBuyTypeLink,           //联系对方
    TradeBuyTypeBuy,           //购买
};

typedef void(^TradeBuyBlock)(TradeBuyType tradeType);

@interface TradeBuyView : UIView

@property (nonatomic, strong) AdvertiseModel *advertise;

@property (nonatomic, copy) TradeBuyBlock tradeBlock;
//余额
@property (nonatomic, strong) NSNumber *leftAmount;

@end
