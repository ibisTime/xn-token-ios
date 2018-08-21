//
//  TLMoneyDeailVC.h
//  Coin
//
//  Created by shaojianfei on 2018/8/16.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseVC.h"
#import "TLtakeMoneyModel.h"
#import "CurrencyModel.h"
@interface TLMoneyDeailVC : TLBaseVC
@property (nonatomic ,strong) TLtakeMoneyModel *moneyModel;
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;

@end
