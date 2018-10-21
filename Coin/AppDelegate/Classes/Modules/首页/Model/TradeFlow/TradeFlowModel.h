//
//  TradeFlowModel.h
//  OGC
//
//  Created by 蔡卓越 on 2018/3/14.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface TradeFlowModel : TLBaseModel
//产生时间
@property (nonatomic, copy) NSString *creates;
//来方地址
@property (nonatomic, copy) NSString *tokenFrom;
//去方地址
@property (nonatomic, copy) NSString *tokenTo;
//金额
@property (nonatomic, copy) NSString *tokenValue;
//哈希
@property (nonatomic, copy) NSString *code;
//符号
@property (nonatomic, copy) NSString *symbol;
//
@property (nonatomic, assign) CGFloat cellHeight;

@end
