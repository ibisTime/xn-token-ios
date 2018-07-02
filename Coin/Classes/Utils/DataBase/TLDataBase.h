//
//  TLDataBase.h
//  Coin
//
//  Created by shaojianfei on 2018/6/29.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
@interface TLDataBase : NSObject
@property (nonatomic, strong) FMDatabase *dataBase;


@property (nonatomic ,copy) NSString *dataStr;
@property (nonatomic ,copy) NSString *localStr;

+ (instancetype)sharedManager;
@end
