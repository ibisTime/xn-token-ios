//
//  DataBaseModel.h
//  Coin
//
//  Created by shaojianfei on 2018/8/3.
//  Copyright © 2018年 chengdai. All rights reserved.
//

/*walletId INTEGER PRIMARY KEY AUTOINCREMENT,userId text, Mnemonics text, wanaddress text,wanprivate text,ethaddress text,ethprivate text,btcaddress text,btcprivate text,PwdKey text,name text*/

#import <Foundation/Foundation.h>

@interface DataBaseModel : NSObject

@property (nonatomic ,assign) NSInteger walletId;
@property (nonatomic ,copy) NSString* userId;
@property (nonatomic ,copy) NSString* Mnemonics;
@property (nonatomic ,copy) NSString* wanaddress;
@property (nonatomic ,copy) NSString* wanprivate;
@property (nonatomic ,copy) NSString* ethaddress;
@property (nonatomic ,copy) NSString* ethprivate;
@property (nonatomic ,copy) NSString* btcaddress;
@property (nonatomic ,copy) NSString* btcprivate;
@property (nonatomic ,copy) NSString* PwdKey;
@property (nonatomic ,copy) NSString* name;


@end
