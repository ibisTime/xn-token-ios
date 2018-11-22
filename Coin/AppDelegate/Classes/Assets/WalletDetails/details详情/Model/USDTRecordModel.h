//
//  USDTRecordModel.h
//  Coin
//
//  Created by 郑勤宝 on 2018/11/1.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USDTRecordModel : NSObject


@property (nonatomic , copy)NSString *txid;
@property (nonatomic , copy)NSString *amount;
@property (nonatomic , copy)NSString *typeInt;
@property (nonatomic , copy)NSString *fee;
@property (nonatomic , copy)NSString *sendingAddress;
@property (nonatomic , copy)NSString *propertyName;
@property (nonatomic , copy)NSString *type;
@property (nonatomic , copy)NSString *confirmations;
@property (nonatomic , copy)NSString *propertyId;
@property (nonatomic , copy)NSString *divisible;
@property (nonatomic , copy)NSString *ismine;
@property (nonatomic , copy)NSString *blockTime;
@property (nonatomic , copy)NSString *referenceAddress;
@property (nonatomic , copy)NSString *block;


@end
