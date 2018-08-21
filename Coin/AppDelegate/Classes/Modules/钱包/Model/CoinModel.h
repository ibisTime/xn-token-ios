//
//  Coin.h
//  Coin
//
//  Created by haiqingzheng on 2018/3/19.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CoinModel : TLBaseModel

+ (instancetype)coin;

//符号
@property (nonatomic, copy) NSString *symbol;
//英文名称
@property (nonatomic, copy) NSString *ename;
//中文名称
@property (nonatomic, copy) NSString *cname;
//币种类型 ORIGINAL("0", "原生币"), TOKEN("1", "token币");
@property (nonatomic, copy) NSString *type;
//单位
@property (nonatomic, copy) NSString *unit;
//官方图标
@property (nonatomic, copy) NSString *icon;
//钱包水印图标
@property (nonatomic, copy) NSString *pic1;
//流水加钱图标
@property (nonatomic, copy) NSString *pic2;
//流水减钱图标
@property (nonatomic, copy) NSString *pic3;
//UI序号
@property (nonatomic, copy) NSString *orderNo;
//取现手续费
@property (nonatomic, copy) NSString *withdrawFeeString;
@property (nonatomic, copy) NSString *withfrawFee;

//状态 PUBLISHED("0", "已发布"), REVOKE("1", "已撤下");
@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) BOOL IsSelect;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *walletId;
//token币合约地址
@property (nonatomic, copy) NSString * contractAddress;

//存储币种列表
- (void)saveOpenCoinList:(NSArray *)coinList;

- (NSMutableArray<CoinModel *> *) getOpenCoinList;

@end
