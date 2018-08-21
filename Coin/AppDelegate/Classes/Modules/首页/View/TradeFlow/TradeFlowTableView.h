//
//  TradeFlowTableView.h
//  OGC
//
//  Created by 蔡卓越 on 2018/3/14.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLTableView.h"
//M
#import "TradeFlowModel.h"

@interface TradeFlowTableView : TLTableView
//
@property (nonatomic, strong) NSArray <TradeFlowModel *>*flows;

@end
