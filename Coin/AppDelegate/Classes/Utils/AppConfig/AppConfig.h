//
//  AppConfig.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/5/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RunEnv) {
//    正式
    RunEnvRelease = 0,
//    研发
    RunEnvDev,
//    测试
    RunEnvTest
};

FOUNDATION_EXPORT void TLLog(NSString *format, ...);

@interface AppConfig : NSObject

+ (instancetype)config;

@property (nonatomic,assign) RunEnv runEnv;

@property (nonatomic, strong) NSString *systemCode;
@property (nonatomic, strong) NSString *companyCode;

//url请求地址
@property (nonatomic, strong) NSString *addr;
//@property (nonatomic,copy) NSString *aliPayKey;
@property (nonatomic, copy) NSString *qiniuDomain;
@property (nonatomic,strong) NSString *shareBaseUrl;

@property (nonatomic, assign) BOOL isChecking;

@property (nonatomic,strong) NSString *wanHash;
@property (nonatomic,strong) NSString *ethHash;
@property (nonatomic,strong) NSString *wanAddress;
@property (nonatomic,strong) NSString *ethAddress;
@property (nonatomic,strong) NSString *btcHash;

@property (nonatomic, assign) BOOL isUploadCheck;


- (NSString *)apiUrl;
//- (NSString *)ipUrl;

////腾讯云
//@property (nonatomic, copy) NSString *chatAppId;
//@property (nonatomic, copy) NSString *chatAccountType;
//推送
@property (nonatomic,copy) NSString *pushKey;
//微信
@property (nonatomic, copy) NSString *wxKey;
//支付宝
@property (nonatomic, copy) NSString *aliMapKey;
//七牛云
@property (nonatomic, copy) NSString *qiNiuKey;

- (NSString *)getUrl;

@end
