//
//  PosBuyVC.h
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseVC.h"
#import "TLtakeMoneyModel.h"
#import "CurrencyModel.h"
@interface PosBuyVC : TLBaseVC
@property (nonatomic ,strong) TLtakeMoneyModel *moneyModel;
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;
@end
