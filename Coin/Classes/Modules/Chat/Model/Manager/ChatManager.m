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


- (void)initChat {
    
    IMAPlatformConfig *config = [[IMAPlatformConfig alloc] init];
    //不打印日志
    [config chageEnableConsoleTo:NO];
    [IMAPlatform configWith:config];
    
}

//
- (void)play {
    
    // 获取所有的会话列表
    // IMAConversation
    // 获取列表
//    CLSafeMutableArray *conversionList = [IMAPlatform sharedInstance].conversationMgr.conversationList;
    
    //
    //群组列表
    //获取所有的群组列表
//    [IMAPlatform sharedInstance].contactMgr.groupList;
    //
    //先去获取订单列表，根据订单列表查询是否有会话
    //
    
}

+ (ChatManager *)sharedManager {
    
    static ChatManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[ChatManager alloc] init];

    });
    
    return manager;
}

- (IMAGroup *)getGroupByGroupId:(NSString *)groupId {
    
    
    if (!groupId) {
        return nil;
    }
    [[IMAPlatform sharedInstance].contactMgr asyncGroupList];
    // user 或者 group
    __block IMAGroup *currentGroup = nil;
    
   currentGroup = (IMAGroup *)[[IMAPlatform sharedInstance].contactMgr getUserByGroupId:groupId];
    
//    CLSafeMutableArray *groupList = [IMAPlatform sharedInstance].contactMgr.groupList;
//    if (groupList.safeArray) {
//        [groupList.safeArray enumerateObjectsUsingBlock:^(IMAGroup *group, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            if ([group.groupInfo.groupId isEqualToString:groupId]) {
//                //找到了该会话
//                currentGroup = group;
//                *stop = YES;
//            }
//
//        }];
//    }
    
    return currentGroup;
    
}


- (IMAUser *)getConversitionUserById:(NSString *)idStr {
    
    if (!idStr) {
        return nil;
    }
    // user 或者 group
    __block IMAUser *user = nil;
    CLSafeMutableArray *groupList = [IMAPlatform sharedInstance].contactMgr.groupList;
    if (groupList.safeArray) {
        [groupList.safeArray enumerateObjectsUsingBlock:^(IMAGroup *group, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([group.groupInfo.groupId isEqualToString:idStr]) {
                //找到了该会话
                user = group;
                *stop = YES;
            }
            
        }];
    }
    
    return user;
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

- (NSString *)appId {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:SDK_APP_ID];

}

- (NSString *)accountType {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_TYPE];
    
}



- (void)loginWithParam:(TIMLoginParam*)param {
    
    
    [[TIMManager sharedInstance] login:param succ:^{
        
        //同步消息列表
        [[IMAPlatform sharedInstance].conversationMgr asyncConversationList];
        
        // 同步群组列表
        [[IMAPlatform sharedInstance].contactMgr asyncGroupList];
        
        //消息栏消息数
        NSInteger unReadCount = [[IMAPlatform sharedInstance].conversationMgr unReadMessageCount];
        
        [TLUser user].unReadMsgCount = unReadCount;
        
        [IMAPlatform setAutoLogin:YES];        
        [[IMAPlatform sharedInstance] configOnLoginSucc:param];
        //配置APNs
        //        [self configAPNs];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kIMLoginNotification object:nil];

    } fail:^(int code, NSString *msg) {
        
        NSLog(@"LoginFailureCode = %d, errorMsg = %@", code, msg);
    }];
    
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

- (void)pullLoginUI {
    
    
};

//- (void)loginWithUserName:(NSString *)userName {
//
//  [self loginWithUserName:userName pwd:IM_PWD];
//
//}
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
