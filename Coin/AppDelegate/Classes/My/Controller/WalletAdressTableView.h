//
//  WalletAdressTableView.h
//  Coin
//
//  Created by shaojianfei on 2018/6/12.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "CurrencyModel.h"

@interface WalletAdressTableView : TLTableView
@property (nonatomic, strong) NSArray <CurrencyModel *>*currencys;

@end
