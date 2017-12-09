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
//用户ID
@property (nonatomic, copy) NSString *userId;
//Token
@property (nonatomic, copy) NSString *token;
//手机号
@property (nonatomic, copy) NSString *mobile;
//状态
@property (nonatomic, strong) NSString *status;
//前端类型
@property (nonatomic, copy) NSString *kind;
//等级
@property (nonatomic, copy) NSString *level;
//登录名
@property (nonatomic, copy) NSString *loginName;
//昵称
@property (nonatomic, copy) NSString *nickname;
//注册时间
@property (nonatomic, copy) NSString *createDatetime;
//公司编号
@property (nonatomic, copy) NSString *companyCode;
//头像
@property (nonatomic, copy) NSString *photo;
//邮箱
@property (nonatomic, copy) NSString *email;

//用户手机号
@property (nonatomic, strong) NSString *userName;
//用户密码
@property (nonatomic, strong) NSString *userPassward;

//金额
@property (nonatomic, copy) NSString *amount;

//0 未设置交易密码 1已设置
@property (nonatomic, copy) NSString *tradepwdFlag;
//谷歌验证
@property (nonatomic, copy) NSString *googleAuthFlag;
//开启/关闭谷歌验证
@property (nonatomic, assign) BOOL isGoogleAuthOpen;
//真实姓名
@property (nonatomic, copy) NSString *realName;
//身份证
@property (nonatomic, copy) NSString *idNo;

@property (nonatomic, copy) NSString *remark;
//人民币账户
@property (nonatomic, copy) NSString *rmbAccountNumber;
//积分账户
@property (nonatomic, copy) NSString *jfAccountNumber;

@property (nonatomic, copy) NSString *updateDatetime;
@property (nonatomic, copy) NSString *updater;
//邀请码
@property (nonatomic, copy) NSString *inviteCode;
//邀请人个数
@property (nonatomic, copy) NSString *referrerNum;

//实名认证的 --- 临时参数
@property (nonatomic, copy) NSString *tempBizNo;
@property (nonatomic, copy) NSString *tempRealName;
@property (nonatomic, copy) NSString *tempIdNo;
//未读消息数
@property (nonatomic, assign) NSInteger unReadMsgCount;

//是否为需要登录，如果已登录，取出用户信息
- (BOOL)isLogin;

//用户已登录状态，则重新登录
- (void)reLogin;

//保存登录账号和密码
- (void)saveUserName:(NSString *)userName pwd:(NSString *)pwd;

- (void)loginOut;

//存储用户信息
- (void)saveUserInfo:(NSDictionary *)userInfo;

//设置用户信息
- (void)setUserInfoWithDict:(NSDictionary *)dict;

//异步更新用户信息
- (void)updateUserInfo;

@end

FOUNDATION_EXTERN  NSString *const kUserLoginNotification;
FOUNDATION_EXTERN  NSString *const kUserLoginOutNotification;
FOUNDATION_EXTERN  NSString *const kUserInfoChange;

FOUNDATION_EXTERN  NSString *const kLevelOrdinaryTraders;
FOUNDATION_EXTERN  NSString *const kLevelAgent;

FOUNDATION_EXTERN  NSString *const kGoogleAuthOpen;
FOUNDATION_EXTERN  NSString *const kGoogleAuthClose;
