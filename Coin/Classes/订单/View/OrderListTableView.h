//
//  OrderListTableView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLTableView.h"

#import "OrderModel.h"

@interface OrderListTableView : TLTableView

//订单
@property (nonatomic, strong) NSMutableArray <OrderModel *>*orders;

@end
