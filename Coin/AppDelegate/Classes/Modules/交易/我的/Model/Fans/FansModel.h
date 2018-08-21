//
//  FansModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@class ToUserInfo,UserStatist;

@interface FansModel : TLBaseModel

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *toUser;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, strong) ToUserInfo *toUserInfo;

@end

@interface ToUserInfo : NSObject

@property (nonatomic, copy) NSString *kind;

@property (nonatomic, copy) NSString *tradePwdStrength;

@property (nonatomic, copy) NSString *idKind;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, strong) UserStatist *userStatistics;

@property (nonatomic, copy) NSString *loginPwdStrength;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *idNo;

@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, assign) BOOL tradepwdFlag;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *photo;

@end

@interface UserStatist : NSObject

@property (nonatomic, assign) NSInteger beiXinRenCount;

@property (nonatomic, assign) NSInteger jiaoYiCount;

@property (nonatomic, assign) NSInteger beiPingJiaCount;

@property (nonatomic, assign) NSInteger beiHaoPingCount;
//好评率
@property (nonatomic, copy) NSString *goodCommentRate;

@end
