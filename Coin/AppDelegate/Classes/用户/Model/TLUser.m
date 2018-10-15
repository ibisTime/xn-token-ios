//
//  TLUser.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/14.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLUser.h"

#import "UserDefaultsUtil.h"
#import "CurrencyModel.h"
#import "TLNetworking.h"
#import "APICodeMacro.h"
#import "TLUIHeader.h"
#import "AppConfig.h"
#import "TLDataBase.h"
#import "AppColorMacro.h"
//#import "ChatManager.h"       czy
//#import "IMAHost+HostAPIs.h"  czy
//#import "IMAHost.h"           czy
//#import "TabbarViewController.h"

#define USER_ID_KEY @"user_id_key"
#define TOKEN_ID_KEY @"token_id_key"
#define USER_INFO_DICT_KEY @"user_info_dict_key"

NSString *const kUserLoginNotification = @"kUserLoginNotification";
NSString *const kUserLoginOutNotification = @"kUserLoginOutNotification";
NSString *const kUserInfoChange = @"kUserInfoChange";

// ONE("1", "普通交易者"), TWO("2", "代理人")
NSString *const kLevelOrdinaryTraders = @"1";
NSString *const kLevelAgent = @"2";
//谷歌验证(0:关闭 1:开启)
NSString *const kGoogleAuthOpen = @"1";
NSString *const kGoogleAuthClose = @"0";

@implementation TLUser {
    
    NSTimer *_updateLoginTimeTimer;
    
}

+ (instancetype)user {

    static TLUser *user = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        user = [[TLUser alloc] init];
        
    });
    
    return user;

}

#pragma mark - Setting

- (void)setToken:(NSString *)token {
    
    _token = [token copy];
    [[NSUserDefaults standardUserDefaults] setObject:_token forKey:TOKEN_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)setUserId:(NSString *)userId {
    _userId = [userId copy];
    [[NSUserDefaults standardUserDefaults] setObject:_userId forKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)checkLogin {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:USER_ID_KEY];
    NSString *token = [userDefault objectForKey:TOKEN_ID_KEY];
    if (userId && token) {
    
        return YES;
        
    } else {
        
        
        return NO;
    }
    
}

// 登录状态才调用
- (void)loadUserInfoFromDB {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:USER_ID_KEY];
    NSString *token = [userDefault objectForKey:TOKEN_ID_KEY];
    
    //
    self.userId = userId;
    self.token = token;
    self.localMoney = [[NSUserDefaults standardUserDefaults] objectForKey:KLocalMoney];
    
   
    
    //
    NSDictionary *dict = [userDefault objectForKey:USER_INFO_DICT_KEY];
    [self setUserInfoWithDict:dict];
    
}

- (BOOL)isLogin {
    
    if ([self checkLogin]) {
        
        [self loadUserInfoFromDB];
        return YES;
        
    } else {
        
        return NO;
    }


}

- (void)reLogin {
    
    self.userName = [UserDefaultsUtil getUserDefaultName];
    
    self.userPassward = [UserDefaultsUtil getUserDefaultPassword];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_LOGIN_CODE;
    
    http.parameters[@"loginName"] = self.userName;
    http.parameters[@"loginPwd"] = self.userPassward;
    http.parameters[@"kind"] = APP_KIND;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.token = responseObject[@"data"][@"token"];
        self.userId = responseObject[@"data"][@"userId"];
        
        [self updateUserInfo];
        [self requestQiniuDomain];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)changLoginTime {
    [self refreshLoginTime];
    if (_updateLoginTimeTimer) {
        return;
    }
   
    _updateLoginTimeTimer = [NSTimer scheduledTimerWithTimeInterval:5*60
                                                             target:self
                                                        selector:@selector(refreshLoginTime)
                                                           userInfo:nil repeats:YES];
}

- (void)refreshLoginTime {
    
    if (![[TLUser user] checkLogin]) {
        return;
    }
    TLNetworking *http = [TLNetworking new];
    http.code = @"805083";
    http.parameters[@"userId"] = [TLUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestQiniuDomain {
    
    TLNetworking *http = [TLNetworking new];
    http.code = USER_CKEY_CVALUE;
    http.parameters[SYS_KEY] = @"qiniu_domain";
    [http postWithSuccess:^(id responseObject) {
        
        [AppConfig config].qiniuDomain = [NSString stringWithFormat:@"http://%@", responseObject[@"data"][@"cvalue"]];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 账户

- (void)loginOut {

    self.userId = nil;
    self.token = nil;
    //
    //
    self.jfAmount = nil;
    self.jfInviteNumber = nil;
    self.localMoney = nil;
    self.secretUserId = nil;
    self.photo = nil;
    self.mobile = nil;
    self.nickname = nil;
    self.email = nil;
    self.tradepwdFlag = nil;
    self.googleAuthFlag = nil;
    self.level = nil;
    self.rmbAccountNumber = nil;
    self.jfAccountNumber = nil;
//    self.unReadMsgCount = 0;
    self.realName = nil;
    self.idNo = nil;
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID_KEY];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_INFO_DICT_KEY];
    
    
 
}


- (void)saveUserInfo:(NSDictionary *)userInfo {

//    NSLog(@"原%@--现%@",[TLUser user].userId,userInfo[@"userId"]);
    
//    if (![[TLUser user].userId isEqualToString:userInfo[@"userId"]]) {
//        
//        @throw [NSException exceptionWithName:[LangSwitcher switchLang:@"用户信息错误" key:nil] reason:[LangSwitcher switchLang:@"后台原因" key:nil] userInfo:nil];
//        
//    }
    
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:USER_INFO_DICT_KEY];
    //
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)updateUserInfoWithNotification:(BOOL)isPostNotification {
    
    TLNetworking *http = [TLNetworking new];
    
    http.isShowMsg = NO;
    http.code = USER_INFO;
    http.parameters[@"userId"] = self.userId;
    http.parameters[@"token"] = self.token;
    
    [http postWithSuccess:^(id responseObject) {
        
        [self setUserInfoWithDict:responseObject[@"data"]];
        [self saveUserInfo:responseObject[@"data"]];
        
        if (isPostNotification) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (BOOL)chang
{

    TLNetworking *http = [TLNetworking new];
    
    http.isShowMsg = NO;
    http.code = USER_INFO;
    http.parameters[@"userId"] = self.userId;
    http.parameters[@"token"] = self.token;
    CoinWeakSelf;
    [http postWithSuccess:^(id responseObject) {
    
        [self setUserInfoWithDict:responseObject[@"data"]];
        [self saveUserInfo:responseObject[@"data"]];
//        return YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"upsecuees" object:nil];
        
    } failure:^(NSError *error) {
        
        
    }];
    return YES;
}

- (void)updateUserInfo {
    
    [self updateUserInfoWithNotification:YES];
    
}

- (void)setUserInfoWithDict:(NSDictionary *)dict {
    
    self.mobile = dict[@"mobile"];
    self.nickname = dict[@"nickname"];
    self.realName = dict[@"realName"];
    self.loginPwdFlag = dict[@"loginPwdFlag"];
    self.jfAmount = dict[@"jfAmount"];
    self.jfInviteNumber = dict[@"jfInviteNumber"];

    self.idNo = dict[@"idNo"];
    self.tradepwdFlag = [NSString stringWithFormat:@"%@", dict[@"tradepwdFlag"]];
    self.googleAuthFlag = [NSString stringWithFormat:@"%@", dict[@"googleAuthFlag"]];
    self.level = dict[@"level"];
    self.photo = dict[@"photo"];
    self.email = dict[@"email"];
    self.interCode = dict[@"country"][@"interCode"];
    self.secretUserId =  dict[@"secretUserId"];
    
    //腾讯云-设置昵称和头像
//  [IMAPlatform sharedInstance].host.icon = [self.photo convertImageUrl];

}

- (void)setMobile:(NSString *)mobile {
    
    _mobile = [mobile copy];
    
}

- (void)setPhoto:(NSString *)photo {
    
    _photo = [photo copy];
    
}

//- (void)saveUserName:(NSString *)userName pwd:(NSString *)pwd {
//    
//    self.userName = userName;
//    
//    self.userPassward = pwd;
//    
//    [UserDefaultsUtil setUserDefaultName:userName];
//    
//    [UserDefaultsUtil setUserDefaultPassword:pwd];
//    
//}

//- (void)setUnReadMsgCount:(NSInteger)unReadMsgCount {
//    
//    _unReadMsgCount = unReadMsgCount;
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageDidRefresh" object:[NSString stringWithFormat:@"%ld", unReadMsgCount]];
//}

- (void)setGoogleAuthFlag:(NSString *)googleAuthFlag {
    
    _googleAuthFlag = googleAuthFlag;
    _isGoogleAuthOpen = [googleAuthFlag isEqualToString:kGoogleAuthOpen] ? YES: NO;
    
}

+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL)
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }

    return NO;
}

+ (NSString *)stringByNotRounding:(double)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];

    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];

    return [NSString stringWithFormat:@"%@",roundedOunces];
}

@end
