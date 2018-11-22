//
//  PosBuyTableView.h
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "CurrencyModel.h"
#import "TLtakeMoneyModel.h"

@interface PosBuyTableView : TLTableView

@property (nonatomic ,strong) TLtakeMoneyModel *moneyModel;
@property (nonatomic, strong)CurrencyModel *currencys;
@property (nonatomic, strong)NSDictionary *dataDic;



@end
