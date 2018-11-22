//
//  LocalBillDetailTableView.h
//  Coin
//
//  Created by shaojianfei on 2018/6/15.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "CurrencyModel.h"
#import "BillModel.h"
#import "USDTRecordModel.h"
@interface LocalBillDetailTableView : TLTableView
@property (nonatomic, strong) BillModel *bill;
@property (nonatomic, strong) CurrencyModel *currentModel;
@property (nonatomic , strong)USDTRecordModel *usdtModel;

@end
