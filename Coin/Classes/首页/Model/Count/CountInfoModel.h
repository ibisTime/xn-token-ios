//
//  CountInfoModel.h
//  OGC
//
//  Created by 蔡卓越 on 2018/3/14.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface CountInfoModel : TLBaseModel
//总量
@property (nonatomic, copy) NSString *totalCount;
//使用量
@property (nonatomic, copy) NSString *useCount;
//使用占有率
@property (nonatomic, copy) NSString *useRate;

@end
