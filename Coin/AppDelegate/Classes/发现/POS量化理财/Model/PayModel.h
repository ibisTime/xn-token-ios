//
//  PayModel.h
//  Coin
//
//  Created by shaojianfei on 2018/8/19.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseModel.h"

@interface PayModel : TLBaseModel

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *symbol;


@property (nonatomic, strong) NSString *count;

@property (nonatomic, strong) NSString *endTime;

@property (nonatomic, strong) NSString *getFree;

@end
