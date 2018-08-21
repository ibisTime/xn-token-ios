//
//  TradeTableView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLTableView.h"

#import "AdvertiseModel.h"

@interface PushTradeTableView : TLTableView
//广告
@property (nonatomic, strong) NSArray <AdvertiseModel *>*advertises;

@end
