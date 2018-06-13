//
//  WalletLocalModel.h
//  Coin
//
//  Created by shaojianfei on 2018/6/12.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrencyModel.h"
@interface WalletLocalModel : NSObject

@property (nonatomic , copy) NSString *totalAmountCNY;

@property (nonatomic , copy) NSString *totalAmountUSD;

@property (nonatomic , copy) NSString *totalAmountHKD;

@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*accountList;


@end
