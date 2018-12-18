//
//  MineTableView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLTableView.h"
#import "MineGroup.h"
#import "MyIncomeModel.h"
@interface MineTableView : TLTableView

@property (nonatomic , strong)MyIncomeModel *model;

@property (nonatomic, strong) MineGroup *mineGroup;

@property (nonatomic , strong)NSString *priceStr;

@property (nonatomic , strong)NSString *earningsStr;

@end
