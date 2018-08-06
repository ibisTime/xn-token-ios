//
//  TLDataBase.h
//  Coin
//
//  Created by shaojianfei on 2018/6/29.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "DataBaseModel.h"
#import "CoinModel.h"
@interface TLDataBase : NSObject
@property (nonatomic, strong) FMDatabase *dataBase;
@property (nonatomic, strong) NSMutableArray <DataBaseModel *>*dataBaseModels;
@property (nonatomic, strong) NSMutableArray <CoinModel *>*coinModels;


@property (nonatomic ,copy) NSString *dataStr;
@property (nonatomic ,copy) NSString *localStr;

+ (instancetype)sharedManager;
@end
