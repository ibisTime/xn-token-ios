//
//  HistoryRateTableView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/30.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLTableView.h"

#import "HistoryRateModel.h"

@interface HistoryRateTableView : TLTableView

@property (nonatomic, strong) NSArray <HistoryRateModel *>*rates;

@end
