//
//  MyIncomeTableView.h
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "MyIncomeModel.h"
#import "MyIncomeTopModel.h"
@interface MyIncomeTableView : TLTableView

@property (nonatomic , strong)NSMutableArray <MyIncomeTopModel *>*topModel;
@property (nonatomic , strong)MyIncomeModel *model;
@end
