//
//  GlobalRevenueListTableView.h
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "MyIncomeTopModel.h"

@interface GlobalRevenueListTableView : TLTableView

@property (nonatomic , strong)NSMutableArray <MyIncomeTopModel *>*topModel;
@end
