//
//  UserInfo.h
//  Coin
//
//  Created by  tianlei on 2017/12/19.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface UserInfo : TLBaseModel


@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *loginPwdStrength;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, assign) BOOL tradepwdFlag;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *kind;

/**
  最后的登录时间
 */
@property (nonatomic, copy) NSString *lastLogin;


@end
