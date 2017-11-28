//
//  CoinAddressListVC.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

typedef void(^CoinAddressBlock)(NSString *address);

@interface CoinAddressListVC : TLBaseVC

@property (nonatomic, copy) CoinAddressBlock addressBlock;

@end
