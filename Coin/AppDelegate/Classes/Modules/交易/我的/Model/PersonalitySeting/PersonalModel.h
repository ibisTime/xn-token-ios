//
//  PersonalModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/12/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

FOUNDATION_EXTERN NSString *const kAutoPraise;
FOUNDATION_EXTERN NSString *const kAutoAddFriend;

@interface PersonalModel : TLBaseModel
//设置结果(0=添加设置，1=取消设置)
@property (nonatomic, copy) NSString *value;
//类型type("1", "设置自动好评"), ("2",设置自动信任）
@property (nonatomic, copy) NSString *type;

@end
