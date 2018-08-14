//
//  TLBillBTCVC.h
//  Coin
//
//  Created by shaojianfei on 2018/8/11.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseVC.h"
#import "BillModel.h"
#import "CurrencyModel.h"
@interface TLBillBTCVC : TLBaseVC
@property (nonatomic, strong) BillModel *bill;

@property (nonatomic, strong) CurrencyModel *currentModel;

@property (nonatomic, copy) NSString *address;

@end
