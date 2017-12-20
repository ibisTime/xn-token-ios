//
//  ChatManager.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/9.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ChatManager.h"
#import "IMModel.h"
#import "IMALoginParam.h"
#import "CustomUIHeader.h"
#import "AppConfig.h"
#import "IMAPlatform.h"
#import "IMAConversation.h"


#define SDK_APP_ID @"CHAT_SDK_APP_ID"
#define ACCOUNT_TYPE @"CHAT_ACCOUNT_TYPE"
#define USER_SIGN @"CHAT_USER_SIGN"

//config.sdkAppId = 1400050575;
//config.accountType = @"19287";

@interface ChatManager ()<TIMConnListener,TIMUserStatusListener,TIMRefreshListener,TIMFriendshipListener,TIMGroupListener,TIMMessageListener,TIMMessageUpdateListener>

@property (nonatomic, strong) IMModel *imModel;

@end

@implementation ChatManager

// loginWithParam 方法中有调用
- (void)initChat {
    
    //log: [INFO][TIMManager.mm:137][-[TIMManager initSdk:]][ImSDK]Has InitSDK, skip
    // 可多次初始化，
    
    IMAPlatformConfig *config = [[IMAPlatformConfig alloc] init];
    //不打印日志
    [config chageEnableConsoleTo:NO];
    //设置环境类型
    [IMAPlatform configWith:config];
    
}



+ (ChatManager *)sharedManager {
    
    static ChatManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[ChatManager alloc] init];

    });
    
    return manager;
}

//获取签名，并登录
- (void)loginIM {
    
    if ([IMAPlatform isAutoLogin]) {
        
        //自动登录，获取数据库的历史记录
        [self loginWithParam:[IMALoginParam loadFromLocal]];
        return;
        
    }
  
    //该用户第一次登录
    TLNetworking *http = [TLNetworking new];
    http.code = @"625000";
    http.parameters[@"userId"] = [TLUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
        self.imModel = [IMModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        //保存信息,导数据库
        [self saveIMAppInfoToDBAppId: self.imModel.txAppCode
                         accountType: self.imModel.accountType
                            userSign: self.imModel.sign];
        
        
        IMALoginParam *loginParam = [[IMALoginParam alloc] init];
        
        //转成小写，登录
        loginParam.identifier = [TLUser user].userId;
        loginParam.userSig = self.imModel.sign;
        loginParam.appidAt3rd = self.imModel.txAppCode;
        [self loginWithParam:loginParam];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)saveIMAppInfoToDBAppId:(NSString *)apppId accountType:(NSString *)accountType userSign:(NSString *)sign {
    
    [[NSUserDefaults standardUserDefaults] setObject:apppId forKey:SDK_APP_ID];
    [[NSUserDefaults standardUserDefaults] setObject:accountType forKey:ACCOUNT_TYPE];
    [[NSUserDefaults standardUserDefaults] setObject:sign forKey:USER_SIGN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (void)loginWithParam:(IMALoginParam *)loginParam {

    //重新登录需要 init 一下，切换账户时
    [[IMAPlatform sharedInstance] login:loginParam succ:^{
        
//        [TIMManager sharedInstance].;
        //登录成功
        //保存登录信息
        [loginParam saveToLocal];
    
    } fail:^(int code, NSString *msg) {
        
        
    }];

}


- (NSString *)appId {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:SDK_APP_ID];
    
}

- (NSString *)accountType {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_TYPE];
    
}




#pragma mark- 登录整理
- (void)login2 {
    
    IMALoginParam *_loginParam = nil;
    
    BOOL isAutoLogin = [IMAPlatform isAutoLogin];
    if (isAutoLogin) {
        
        _loginParam = [IMALoginParam loadFromLocal];
        
    }  else {
        
        _loginParam = [[IMALoginParam alloc] init];
        
    }
    
    //配置_IM_
    [IMAPlatform configWith:_loginParam.config];
    
    if (isAutoLogin && [_loginParam isVailed])
    {
        //
        [[IMAPlatform sharedInstance] login:_loginParam succ:^{
            //登录成功
            
        } fail:^(int code, NSString *msg) {
            

        }];
        
    }
    
}





- (void)configAPNs {
    
    TIMAPNSConfig * apnsConfig = [[TIMAPNSConfig alloc] init];
    apnsConfig.openPush = 1;
    
    apnsConfig.c2cSound = nil;
    
    [[TIMManager sharedInstance] setAPNS:apnsConfig succ:^()
     {
         NSLog(@"APNs配置成功");
         //         [TLAlert alertWithSucces:@"APNs配置成功"];
         
     } fail:^(int code, NSString *err)
     {
         //         [TLAlert alertWithSucces:@"APNs配置失败"];
         
         NSLog(@"APNs配置失败,原因: %d %@",code , err);
         
     }];
    
}

//
//- (void)loginWithUserName:(NSString *)userName pwd:(NSString *)password{
//
//    TIMLoginParam * login_param = [[TIMLoginParam alloc ]init];
//
//    // identifier为用户名，userSig 为用户登录凭证
//    // appidAt3rd 在私有帐号情况下，填写与sdkAppId 一样
//    login_param.identifier = @"iOS_001";
//    login_param.userSig = @"usersig";
//    login_param.appidAt3rd = @"123456";
//
//    [[TIMManager sharedInstance] login: login_param succ:^(){
//
//        [TLAlert alertWithSucces:@"登录成功"];
//
//    } fail:^(int code, NSString * err) {
//        NSLog(@"Login Failed: %d->%@", code, err);
//
//        switch (code) {
//            case 0:
//            {
//                [TLAlert alertWithError:err];
//
//            }break;
//
//            case 1:
//            {
//                [TLAlert alertWithError:err];
//
//            }break;
//
//            case 2:
//            {
//                [TLAlert alertWithError:err];
//
//            }break;
//
//            case 3:
//            {
//                [TLAlert alertWithError:err];
//
//            }break;
//
//            default:
//                break;
//        }
//
//    }];
//
//}



@end
