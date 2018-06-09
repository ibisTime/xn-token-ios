//
//  CurrencyTitleModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyTitleModel.h"

@interface CurrencyTitleModel : NSObject
//编号
@property (nonatomic, copy) NSString *ID;
//币种中文名
@property (nonatomic, copy) NSString *cname;

@property (nonatomic, copy) NSString *maxSupply;
//展示用的
@property (nonatomic, copy) NSString *symbol;

@property (nonatomic, copy) NSString *todayVol;
//帖子数
@property (nonatomic, copy) NSString *totalSupply;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, copy) NSString *rank;
//币种英文名
@property (nonatomic, copy) NSString *ename;

@property (nonatomic, copy) NSString *todayChange;

@property (nonatomic, copy) NSString *lastPrice;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *marketCap;
@property (nonatomic, assign) BOOL  IsSelect;

@end
