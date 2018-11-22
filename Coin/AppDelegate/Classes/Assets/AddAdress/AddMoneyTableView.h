//
//  AddMoneyTableView.h
//  Coin
//
//  Created by shaojianfei on 2018/6/7.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "CurrencyModel.h"

@interface AddMoneyTableView : TLTableView
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;

@property (nonatomic, assign)NSInteger PersonalWallet;

@end
