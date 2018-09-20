//
//  MSAuthDefines.h
//  MSAuthSDK
//
//  Created by Jeff Wang on 16/4/6.
//  Copyright © 2016年 Jeff Wang. All rights reserved.
//

#ifndef MSAuthDefines_h
#define MSAuthDefines_h

typedef enum {
    VERIFY_REUSLT_OK   = 0,
    VERIFY_REUSLT_FAIL = 1
} t_verify_reuslt;

//extern NSString *const kMSAuthErrorDomain;
//extern NSString *const kAliAuthGeneric;
//extern NSString *const kAliAuthServer;
//extern NSString *const kAliAuthService;

static NSString *const kAliAuthGeneric   = @"AliAuthGeneric";
static NSString *const kAliAuthServer    = @"AliAuthServer";
static NSString *const kAliAuthService   = @"AliAuthService";
static NSString *const kAliAuthServiceNC = @"AliAuthServiceNc";

typedef enum {
    ALIAUTH_CLIENT_ERROR_GENERIC = 50000,
    ALIAUTH_CLIENT_ERROR_NORESP  = 50001,
    ALIAUTH_CLIENT_ERROR_BADJSON = 50002,
    ALIAUTH_CLIENT_ERROR_VERSION = 50003,
    ALIAUTH_CLIENT_ERROR_TIMEOUT = 50004,
} kAliAuthGenericErrorCode;

typedef enum {
    ALIAUTH_SERVICE_ERROR_ABORT = 60000,
    ALIAUTH_SERVICE_ERROR_MAXTRY,
    ALIAUTH_SERVICE_ERROR_BAD_TOKEN,
} kAliAuthServiceErrorCode;

/**
 * 当前支持的验证类型
 */
typedef enum : NSUInteger {
    MSAuthTypeSms = 1,
    MSAuthTypeCall,
    MSAuthTypeSlide,
    MSAuthTypeMail,
    MSAuthBallShake,
    MSAuthBallRoll
} MSAuthType;

typedef enum : NSUInteger {
    //status code
    MSAuthStatusInitSucceed               = 101,
    MSAuthStatusAuthPassed                = 102,
    MSAuthStatusRetry                     = 103,
    MSAuthStatusServerFault               = 104,

    //error status code
    MSAuthStatusInvalidParam              = 1201,
    MSAuthStatusNoMemory                  = 1202,
    MSAuthStatusNotInitYet                = 1203,
    MSAuthStatusQueueFull                 = 1204,

    MSAuthStatusRetryToMax                = 1205,
    MSAuthStatusHttpNoToken               = 1206,
    MSAuthStatusHttpRequestFail           = 1207,
    MSAuthStatusServerReturnError         = 1208,
    MSAuthStatusVeriGetWuaFail            = 1209,
    MSAuthStatusVeriGetTraceFail          = 1210,
    MSAuthStatusVeriAppKeyMismatch        = 1211,
    MSAuthStatusVeriSessionExpired        = 1212,
    MSAuthStatusVeriWUAInvalidParam       = 1213,
    MSAuthStatusVeriWUADataFileMismatch   = 1214,
    MSAuthStatusVeriWUANoDataFile         = 1215,
    MSAuthStatusVeriWUAIncorrectDataFile  = 1216,
    MSAuthStatusVeriWUAKeyNotExist        = 1217,
    MSAuthStatusVeriWUALowVersionDataFile = 1218,

    MSAuthStatusUnknownError              = 1299,
} MSAuthStatus;

#endif /* MSAuthDefines_h */
