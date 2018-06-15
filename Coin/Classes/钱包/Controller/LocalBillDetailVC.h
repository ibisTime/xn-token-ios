//
//  LocalBillDetailVC.h
//  Coin
//
//  Created by shaojianfei on 2018/6/15.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseVC.h"
#import "BillModel.h"
#import "CurrencyModel.h"
@interface LocalBillDetailVC : TLBaseVC

@property (nonatomic, strong) BillModel *bill;

@property (nonatomic, strong) CurrencyModel *currentModel;


@end
