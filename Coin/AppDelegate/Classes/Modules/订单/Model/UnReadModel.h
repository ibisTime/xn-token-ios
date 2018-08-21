//
//  UnReadModel.h
//  Coin
//
//  Created by haiqingzheng on 2018/3/27.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseModel.h"

@interface UnReadModel : TLBaseModel

@property (nonatomic, assign) BOOL unReadFlag;

@property (nonatomic, strong) NSMutableArray *unReadCurrencyList;

@end
