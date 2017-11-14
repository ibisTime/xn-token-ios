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

//#import "ChatManager.h"
//#import "IMAHost+HostAPIs.h"
//#import "IMAHost.h"
//#import "TabbarViewController.h"

//#define USER_ID_KEY @"user_id_key"
#define TOKEN_ID_KEY @"token_id_key"
#define USER_INFO_DICT_KEY @"user_info_dict_key"

NSString *const kUserLoginNotification = @"kUserLoginNotification";
NSString *const kUserLoginOutNotification = @"kUserLoginOutNotification";
NSString *const kUserInfoChange = @"kUserInfoChange";

@implementation TLUser

+ (instancetype)user {

    static TLUser *user = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        user = [[TLUser alloc] init];
        
    });
    
    return user;

}

- (void)initUserData {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSString *userId = [userDefault objectForKey:USER_ID_KEY];
    NSString *token = [userDefault objectForKey:TOKEN_ID_KEY];
    self.token = token;
    
    //--//
    [self setUserInfoWithDict:[userDefault objectForKey:USER_INFO_DICT_KEY]];

}


- (void)saveToken:(NSString *)token {

    [[NSUserDefaults standardUserDefaults] setObject:token forKey:TOKEN_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];

}


- (BOOL)isLogin {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSString *userId = [userDefault objectForKey:USER_ID_KEY];
    NSString *token = [userDefault objectForKey:TOKEN_ID_KEY];
    if (token) {
        
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
        
        NSString *token = responseObject[@"data"][@"token"];
        
        self.token = token;
        
        [[TLUser user] saveToken:token];
        
        //异步跟新用户信息
        [[TLUser user] updateUserInfo];
        
        [self requestAccountNumber];
        
//        //获取腾讯云IM签名、账号并登录
//        [[ChatManager sharedManager] getTencentSign];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - 账户
- (void)requestAccountNumber {
    
    CoinWeakSelf;
    
    //获取人民币和积分账户
    TLNetworking *http = [TLNetworking new];
    http.code = @"802503";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray <CurrencyModel *> *arr = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [arr enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.currency isEqualToString:@"JF"]) {
                
                weakSelf.jfAccountNumber = obj.accountNumber;
                
            } else if ([obj.currency isEqualToString:@"CNY"]) {
                
                weakSelf.rmbAccountNumber = obj.accountNumber;
            }
            
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)loginOut {

    self.userId = nil;
    self.token = nil;
    self.photo = nil;
    self.mobile = nil;
    self.nickname = nil;
    self.tradepwdFlag = nil;
    self.level = nil;
    self.rmbAccountNumber = nil;
    self.jfAccountNumber = nil;
    self.unReadMsgCount = 0;
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID_KEY];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_INFO_DICT_KEY];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_login_out_notification" object:nil];
}


- (void)saveUserInfo:(NSDictionary *)userInfo {

    NSLog(@"原%@--现%@",[TLUser user].userId,userInfo[@"userId"]);
    
    if (![[TLUser user].userId isEqualToString:userInfo[@"userId"]]) {
        
        @throw [NSException exceptionWithName:@"用户信息错误" reason:@"后台原因" userInfo:nil];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:USER_INFO_DICT_KEY];
    //
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)updateUserInfo {

    TLNetworking *http = [TLNetworking new];
    http.isShowMsg = NO;
    http.code = USER_INFO;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        [self setUserInfoWithDict:responseObject[@"data"]];
        [self saveUserInfo:responseObject[@"data"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
        
    } failure:^(NSError *error) {
        
        
    }];

}

- (void)setUserInfoWithDict:(NSDictionary *)dict {

    self.userId = dict[@"userId"];
    
    //token用户信息没有返回，不能再此处初始化
//    self.token = dict[@"token"];
    self.mobile = dict[@"mobile"];
    self.nickname = dict[@"nickname"];
    self.realName = dict[@"realName"];
    self.idNo = dict[@"idNo"];
    self.tradepwdFlag = [NSString stringWithFormat:@"%@", dict[@"tradepwdFlag"]];
    self.level = dict[@"level"];
    self.photo = dict[@"photo"];
    
    //腾讯云-设置昵称和头像
//    [IMAPlatform sharedInstance].host.icon = [self.photo convertImageUrl];

    
}

- (void)saveUserName:(NSString *)userName pwd:(NSString *)pwd {
    
    self.userName = userName;
    
    self.userPassward = pwd;
    
    [UserDefaultsUtil setUserDefaultName:userName];
    
    [UserDefaultsUtil setUserDefaultPassword:pwd];
    
}

- (void)setUnReadMsgCount:(NSInteger)unReadMsgCount {
    
    _unReadMsgCount = unReadMsgCount;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageDidRefresh" object:[NSString stringWithFormat:@"%ld", unReadMsgCount]];
}

@end
