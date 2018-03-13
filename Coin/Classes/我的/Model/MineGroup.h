//
//  MineGroup.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "MineModel.h"

@interface MineGroup : TLBaseModel

@property (nonatomic,copy) NSArray <MineModel *>*items;

@property (nonatomic, copy) NSArray *sections;    //分组

@end
