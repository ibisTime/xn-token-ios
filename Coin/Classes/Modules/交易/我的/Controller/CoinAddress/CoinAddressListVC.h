//
//  CoinAddressListVC.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

#import "CoinAddressModel.h"

typedef void(^CoinAddressBlock)(CoinAddressModel *addressModel);

@interface CoinAddressListVC : TLBaseVC

@property (nonatomic, copy) CoinAddressBlock addressBlock;
@property (nonatomic, copy) NSString *coin;


/**
 是否可以查看多个coin, 默认no
 */
@property (nonatomic, assign) BOOL isCanLookManyCoin;


@end
