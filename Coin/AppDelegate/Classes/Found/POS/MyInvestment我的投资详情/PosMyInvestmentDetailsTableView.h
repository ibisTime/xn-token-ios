//
//  PosMyInvestmentDetailsTableView.h
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "PosMyInvestmentModel.h"
@interface PosMyInvestmentDetailsTableView : TLTableView
@property (nonatomic , strong)NSMutableArray <PosMyInvestmentModel *>*model;
@end
