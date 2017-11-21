//
//  PayTypeModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface PayTypeModel : TLBaseModel

@property (nonatomic, copy) NSString *payType;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIColor *color;

@end
