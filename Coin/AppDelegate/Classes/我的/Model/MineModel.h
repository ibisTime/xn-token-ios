//
//  MineModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface MineModel : TLBaseModel

@property (nonatomic,copy) NSString *imgName;
@property (nonatomic,copy) NSString *text;
@property (nonatomic, copy) NSString *rightText;

@property (nonatomic,strong) void(^action)();

@end
