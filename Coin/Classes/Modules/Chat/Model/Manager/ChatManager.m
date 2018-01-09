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
#import <IMGroupExt/IMGroupExt.h>

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
//    NSLog(@"%ld",[TIMManager sharedInstance].);
    
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
    
    
//    [self testPlayGround];
//    return;
    
    if ([IMAPlatform isAutoLogin]) {
        
        //自动登录，获取数据库的历史记录
        [self loginWithParam:[IMALoginParam loadFromLocal]];
        return;
        
    }
  
    //该用户第一次登录
    TLNetworking *http = [TLNetworking new];
    http.code = @"625000";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        self.imModel = [IMModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        //保存信息,导数据库
//        [self saveIMAppInfoToDBAppId: self.imModel.txAppCode
//                         accountType: self.imModel.accountType
//                            userSign: self.imModel.sign];
        
        
        IMALoginParam *loginParam = [[IMALoginParam alloc] init];
        
        //
        loginParam.identifier = [TLUser user].userId;
        loginParam.userSig = self.imModel.sign;
        loginParam.tokenTime = [[NSDate date] timeIntervalSince1970];
//        loginParam.appidAt3rd = self.imModel.txAppCode;
        [self loginWithParam:loginParam];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)saveIMAppInfoToDBAppId:(NSString *)apppId
                   accountType:(NSString *)accountType
                      userSign:(NSString *)sign {
    
    [[NSUserDefaults standardUserDefaults] setObject:apppId forKey:SDK_APP_ID];
    [[NSUserDefaults standardUserDefaults] setObject:accountType forKey:ACCOUNT_TYPE];
    [[NSUserDefaults standardUserDefaults] setObject:sign forKey:USER_SIGN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (void)loginWithParam:(IMALoginParam *)loginParam {
    
    //没有网络的时候应该首先尝试调用此方法，
    //    [[TIMManager sharedInstance] initStorage:<#(TIMLoginParam *)#> succ:<#^(void)succ#> fail:<#^(int code, NSString *msg)fail#>];
    // 有网络的时候调用下面的方法


    //重新登录需要 init 一下，切换账户时
    [[IMAPlatform sharedInstance] login:loginParam succ:^{
        
//      [TIMManager sharedInstance].;
        //登录成功
        //保存登录信息
        [loginParam saveToLocal];
        //注册通知
        //腾讯云需要在登录成功之后，才能上报token
        // app delegate 中 didRegisterForRemoteNotification 会回调
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
//        NSLog(@"%ld",count);
//        [IMAConversationManager ].getun
        
        [self setPushConfig];
//        [self test];
    
    } fail:^(int code, NSString *msg) {
        
        
    }];

}

- (void)test {
    
    //
//    TIMConversation *conversition = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:@"tianlei02"];
//    
//    TIMTextElem *elem = [[TIMTextElem alloc] init];
//    elem.text = @"测试";
//    TIMMessage *msg = [[TIMMessage alloc] init];
//    [msg addElem:elem];
//    [conversition sendMessage:msg succ:^{
//        
//        NSLog(@"发送成功");
//        
//    } fail:^(int code, NSString *msg) {
//        
//        
//    }];
    
//    [self test1];
//    [self test2];
    
//    [[TIMGroupManager sharedInstance] modifyReciveMessageOpt:<#(NSString *)#> opt:<#(TIMGroupReceiveMessageOpt)#> succ:^{
//
//    } fail:^(int code, NSString *msg) {
//
//    }];
    
}


//- (void)test2 {
//
////    IMAGroup *group = [[IMAGroup alloc] initWith:@"@TGS#2BULOHAFB"];
//    IMAGroup *group = [[IMAGroup alloc] initWith:@"JY201801181901305368479"];
//    IMAConversation *newConversation = [[IMAPlatform sharedInstance].conversationMgr chatWith:group];
//
//    IMAMsg *msg = [IMAMsg msgWithText:@"群组——测试2"];
//    [newConversation sendMessage:msg completion:^(NSArray *imamsgList, BOOL succ, int code) {
//
//        if (succ) {
//
//            [TLAlert alertWithMsg:@"测试2-发送成功"];
//
//        }
//
//    }];
//
//}

/**
 登录成功调用
 */
- (void)setPushConfig {
    
    TIMAPNSConfig *config = [[TIMAPNSConfig alloc] init];
    [config setOpenPush:1];
    config.c2cSound = nil;
    config.groupSound = nil;
    config.videoSound = nil;
    [[TIMManager sharedInstance] setAPNS:config succ:^{
        
        [[TIMManager sharedInstance] getAPNSConfig:^(TIMAPNSConfig *config) {
            
            
        } fail:^(int code, NSString *msg) {
            
        }];
        
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







- (void)testCount {
    
    __block int testCount = 0;
    NSArray *conversationList = [[TIMManager sharedInstance] getConversationList];
    [conversationList enumerateObjectsUsingBlock:^(TIMConversation *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        testCount += obj.getUnReadMessageNum;
    }];
    NSLog(@"%d",testCount);
    
}


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
