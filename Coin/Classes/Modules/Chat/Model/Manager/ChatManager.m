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

#define IM_PWD @"123456"

@interface ChatManager ()<TIMConnListener,TIMUserStatusListener,TIMRefreshListener,TIMFriendshipListener,TIMGroupListener,TIMMessageListener,TIMMessageUpdateListener>

@property (nonatomic, strong) IMModel *imModel;

@end

@implementation ChatManager
{
    //微信、QQ、游客登录现在Demo中不再支持，如有需要，请用户自行完成
    //    __weak id<WXApiDelegate>    _tlsuiwx;
    //    TencentOAuth                *_openQQ;
    IMALoginParam               *_loginParam;
}

+ (ChatManager *)sharedManager {
    
    static ChatManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[ChatManager alloc] init];

    });
    
    return manager;
}

- (void)getTencentSign {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625000";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
//        self.imModel = [IMModel mj_objectWithKeyValues:responseObject[@"data"]];
//
//        [AppConfig config].chatAppId = self.imModel.txAppCode;
//
//        [AppConfig config].chatAccountType = self.imModel.accountType;
//        //登录
//        [self configLoginParam];
        
    } failure:^(NSError *error) {
        
        
    }];
}

//获取签名后配置
- (void)configLoginParam {
    
    BOOL isAutoLogin = [IMAPlatform isAutoLogin];
    if (isAutoLogin)
    {
        _loginParam = [IMALoginParam loadFromLocal];
    }
    else
    {
        _loginParam = [[IMALoginParam alloc] init];
        
        _loginParam.identifier = [TLUser user].userId;
        _loginParam.userSig = self.imModel.sign;
        _loginParam.appidAt3rd = self.imModel.txAppCode;
    
    }
    //初始化SDK
    [[IMAPlatform sharedInstance] configIMSDK:_loginParam.config];
    //另一台设备登录问题
    [[IMAPlatform sharedInstance] configOnLoginSucc:_loginParam];
    
    [self loginIM];

//    if (isAutoLogin && [_loginParam isVailed])
//    {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self loginIM];
//        });
//    }
//    else
//    {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 *  NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self pullLoginUI];
//        });
//
//    }
}


- (void)loginIM {
    
    [[TIMManager sharedInstance] login:_loginParam succ:^{
        
//        [TLAlert alertWithSucces:@"登录成功"];
        //消息栏消息数
        NSInteger unReadCount = [[IMAPlatform sharedInstance].conversationMgr unReadMessageCount];
        
        [TLUser user].unReadMsgCount = unReadCount;
        
        //配置APNs
        [self configAPNs];
        
        
    } fail:^(int code, NSString *msg) {
        
        NSLog(@"LoginFailureCode = %d, errorMsg = %@", code, msg);
        
//        [TLAlert alertWithError:@"登录失败"];
        
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

- (void)loginWithUserName:(NSString *)userName {
    
  [self loginWithUserName:userName pwd:IM_PWD];
    
}

- (void)loginWithUserName:(NSString *)userName pwd:(NSString *)password{
    
    TIMLoginParam * login_param = [[TIMLoginParam alloc ]init];
    
    // identifier为用户名，userSig 为用户登录凭证
    // appidAt3rd 在私有帐号情况下，填写与sdkAppId 一样
    login_param.identifier = @"iOS_001";
    login_param.userSig = @"usersig";
    login_param.appidAt3rd = @"123456";
    
    [[TIMManager sharedInstance] login: login_param succ:^(){

        [TLAlert alertWithSucces:@"登录成功"];
        
    } fail:^(int code, NSString * err) {
        NSLog(@"Login Failed: %d->%@", code, err);
        
        switch (code) {
            case 0:
            {
                [TLAlert alertWithError:err];

            }break;
             
            case 1:
            {
                [TLAlert alertWithError:err];
                
            }break;
                
            case 2:
            {
                [TLAlert alertWithError:err];
                
            }break;
                
            case 3:
            {
                [TLAlert alertWithError:err];
                
            }break;
                
            default:
                break;
        }

    }];
    
}

- (void)chatLoginOut{
    
//    self.conversationListVC = nil;
//    self.currentConversionId = nil;
//    self.isHaveKefuUnredMsg = NO;
//    [[EMClient sharedClient] logout:YES];
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}


//- (NSInteger)unreadMsgCount{

//    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
//    NSInteger unreadCount = 0;
//    for (EMConversation *conversation in conversations) {
//        unreadCount += conversation.unreadMessagesCount;
//
//    }
//    return unreadCount;
//}

@end
