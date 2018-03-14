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
@property (nonatomic, copy) NSString *advPic;
//banner图
@property (nonatomic, copy) NSString *pic;
//由pic 转化成的 数组
@property (nonatomic,copy) NSArray *pics;
//店铺名称
@property (nonatomic, copy) NSString *name;
//广告语
@property (nonatomic, copy) NSString *slogan;
//电话
@property (nonatomic, copy) NSString *bookMobile;
//店铺地址
@property (nonatomic, copy) NSString *address;
//省
@property (nonatomic, copy) NSString *province;
//市
@property (nonatomic, copy) NSString *city;
//区
@property (nonatomic, copy) NSString *area;
//图文详情
@property (nonatomic, copy) NSString *desc;
//店铺编号
@property (nonatomic, copy) NSString *code;

@end
