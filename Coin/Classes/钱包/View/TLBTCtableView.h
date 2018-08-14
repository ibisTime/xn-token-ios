//
//  TLBTCtableView.h
//  Coin
//
//  Created by shaojianfei on 2018/8/11.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "CurrencyModel.h"
#import "BillModel.h"
@interface TLBTCtableView : TLTableView
@property (nonatomic, strong) BillModel *bill;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, strong) CurrencyModel *currentModel;
@end
