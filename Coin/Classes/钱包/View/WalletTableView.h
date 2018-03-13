//
//  WalletTableView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLTableView.h"
#import "CurrencyModel.h"

@interface WalletTableView : TLTableView

@property (nonatomic, strong) NSArray <CurrencyModel *>*currencys;

@end
