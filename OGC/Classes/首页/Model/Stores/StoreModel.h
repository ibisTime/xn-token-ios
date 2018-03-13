//
//  StoreModel.h
//  OGC
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface StoreModel : TLBaseModel
//缩略图
@property (nonatomic, copy) NSString *pic;
//店铺名称
@property (nonatomic, copy) NSString *name;
//广告语
@property (nonatomic, copy) NSString *slogan;
//店铺地址
@property (nonatomic, copy) NSString *address;

@end
