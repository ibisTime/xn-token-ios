//
//  CoinAddressTableView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLTableView.h"

#import "CoinAddressModel.h"

@interface CoinAddressTableView : TLTableView

@property (nonatomic, strong) NSMutableArray <CoinAddressModel *>*addressArr;

@end
