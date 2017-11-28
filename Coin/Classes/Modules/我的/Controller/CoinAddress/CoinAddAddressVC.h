//
//  CoinAddAddressVC.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

typedef void(^CoinAddressAddSuccess)(void);

@interface CoinAddAddressVC : TLBaseVC

@property (nonatomic, copy) CoinAddressAddSuccess success;

@end
