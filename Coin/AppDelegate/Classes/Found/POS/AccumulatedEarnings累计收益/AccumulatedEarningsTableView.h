//
//  AccumulatedEarningsTableView.h
//  Coin
//
//  Created by QinBao Zheng on 2018/9/27.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "AccumulatedEarningsModel.h"
@interface AccumulatedEarningsTableView : TLTableView

@property (nonatomic , strong)NSMutableArray <AccumulatedEarningsModel *>*model;

@property (nonatomic , copy)NSString *date;

@end
