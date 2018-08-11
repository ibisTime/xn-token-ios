//
//  utxoModel.h
//  Coin
//
//  Created by shaojianfei on 2018/8/11.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseModel.h"

@interface utxoModel : TLBaseModel

@property (nonatomic ,copy) NSString *address;

@property (nonatomic ,copy) NSString *count;

@property (nonatomic ,copy) NSString *scriptPubKey;

@property (nonatomic ,copy) NSString *txid;
@property (nonatomic ,copy) NSString *vout;

@end
