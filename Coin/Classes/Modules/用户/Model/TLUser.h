 //
//  TLUser.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/14.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "TLUserExt.h"

@class TLUserExt;

@interface TLUser : TLBaseModel

+ (instancetype)user;
//
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, strong) NSString *status;
//金额
@property (nonatomic, copy) NSString *amount;
//类型
@property (nonatomic, copy) NSString *kind;
//等级
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *ljAmount;
@property (nonatomic, copy) NSString *loginName;
//昵称
@property (nonatomic, copy) NSString *nickname;
//用户手机号
@property (nonatomic, strong) NSString *userName;
//用户密码
@property (nonatomic, strong) NSString *userPassward;
//关注数
@property (nonatomic, strong) NSNumber *totalFollowNum;
//粉丝数
@property (nonatomic, strong) NSNumber *totalFansNum;
//登录时间
@property (nonatomic, copy) NSString *loginDatetime;
//注册时间
@property (nonatomic, copy) NSString *createDatetime;

//公司编号
@property (nonatomic, copy) NSString *companyCode;

//0 未设置交易密码 1已设置
@property (nonatomic, copy) NSString *tradepwdFlag;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *idNo;

@property (nonatomic, copy) NSString *remark;
//人民币账户
@property (nonatomic, copy) NSString *rmbAccountNumber;
//积分账户
@property (nonatomic, copy) NSString *jfAccountNumber;

@property (nonatomic, copy) NSString *updateDatetime;
@property (nonatomic, copy) NSString *updater;
@property (nonatomic, strong) TLUserExt *userExt;

//邀请码
@property (nonatomic, copy) NSString *inviteCode;
//邀请人个数
@property (nonatomic, copy) NSString *referrerNum;

//ext
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;

@property (nonatomic,copy) NSString *photo;

@property (nonatomic, copy) NSString *birthday;//生日
@property (nonatomic, copy) NSString *email; //email
@property (nonatomic, copy) NSString *gender; //性别
@property (nonatomic, copy) NSString *introduce; //介绍

//实名认证的 --- 临时参数
@property (nonatomic, copy) NSString *tempBizNo;
@property (nonatomic, copy) NSString *tempRealName;
@property (nonatomic, copy) NSString *tempIdNo;
//未读消息数
@property (nonatomic, assign) NSInteger unReadMsgCount;

//是否为需要登录，如果已登录，取出用户信息
- (BOOL)isLogin;

//重新登录
- (void)reLogin;

//保存登录账号和密码
- (void)saveUserName:(NSString *)userName pwd:(NSString *)pwd;

//用户已登录状态，从数据库中初始化用户信息
- (void)initUserData;

- (void)loginOut;

- (void)saveToken:(NSString *)token;

//存储用户信息
- (void)saveUserInfo:(NSDictionary *)userInfo;

//设置用户信息
- (void)setUserInfoWithDict:(NSDictionary *)dict;

//异步更新用户信息
- (void)updateUserInfo;

- (NSString *)detailAddress;

//转换等级
- (NSString *)userLevel:(NSString *)levelStr;

@end

FOUNDATION_EXTERN  NSString *const kUserLoginNotification;
FOUNDATION_EXTERN  NSString *const kUserLoginOutNotification;
FOUNDATION_EXTERN  NSString *const kUserInfoChange;

