//
//  InviteEarningsTableView.h
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "InviteEarningsModel.h"
@interface InviteEarningsTableView : TLTableView

@property (nonatomic , strong)NSMutableArray <InviteEarningsModel *>*model;
@property (nonatomic , strong)NSMutableArray *array;

@end
