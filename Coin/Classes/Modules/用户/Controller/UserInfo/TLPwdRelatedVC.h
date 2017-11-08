//
//  TLPwdRelatedVC.h
//  ZHBusiness
//
//  Created by  蔡卓越 on 2016/12/12.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLAccountSetBaseVC.h"


typedef  NS_ENUM(NSInteger,TLPwdType) {
    
    TLPwdTypeForget = 0, //忘记密码
    TLPwdTypeReset, //重设密码
    TLPwdTypeTradeReset, //重置交易密码
    TLPwdTypeSetTrade,//设置交易密码
};

@interface TLPwdRelatedVC : TLAccountSetBaseVC

- (instancetype)initWithType:(TLPwdType)type;

@property (nonatomic,copy)  void(^success)();


@end
