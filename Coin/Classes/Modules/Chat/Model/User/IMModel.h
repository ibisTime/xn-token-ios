//
//  IMModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/30.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLBaseModel.h"

@interface IMModel : TLBaseModel

@property (nonatomic, copy) NSString *txAppAdmin;

@property (nonatomic, copy) NSString *secretKey;

@property (nonatomic, copy) NSString *txAppCode;

@property (nonatomic, copy) NSString *accessKey;
//签名
@property (nonatomic, copy) NSString *sign;

@property (nonatomic, copy) NSString *accountType;

@end
