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

//
#define IM_PWD @"123456"

@interface ChatManager ()<TIMConnListener,TIMUserStatusListener,TIMRefreshListener,TIMFriendshipListener,TIMGroupListener,TIMMessageListener,TIMMessageUpdateListener>

@property (nonatomic, strong) IMModel *imModel;

@end

@implementation ChatManager
{
    //微信、QQ、游客登录现在Demo中不再支持，如有需要，请用户自行完成
    //    __weak id<WXApiDelegate>    _tlsuiwx;
    //    TencentOAuth                *_openQQ;
//    IMALoginParam               *_loginParam;
}

- (void)initChat {
    
     [IMAPlatform configWith:[[IMAPlatformConfig alloc] init]];
    
}

//
- (void)play {
    
    // 获取所有的会话列表
    // IMAConversation
    // 获取列表
    CLSafeMutableArray *conversionList = [IMAPlatform sharedInstance].conversationMgr.conversationList;
    
    //
    //群组列表
    //获取所有的群组列表
    [IMAPlatform sharedInstance].contactMgr.groupList;
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
        [AppConfig config].chatAppId = self.imModel.txAppCode;
        [AppConfig config].chatAccountType = self.imModel.accountType;
        //登录
        
        IMALoginParam *loginParam = [[IMALoginParam alloc] init];
        loginParam.identifier = [TLUser user].userId;
        loginParam.userSig = self.imModel.sign;
        loginParam.appidAt3rd = self.imModel.txAppCode;
        [self loginWithParam:loginParam];
        
    } failure:^(NSError *error) {
        
        
    }];
}



- (void)loginWithParam:(TIMLoginParam*)param {
    
    
    [[TIMManager sharedInstance] login:param succ:^{
        
        //同步消息列表
        [[IMAPlatform sharedInstance].conversationMgr asyncConversationList];
        
        //消息栏消息数
        NSInteger unReadCount = [[IMAPlatform sharedInstance].conversationMgr unReadMessageCount];
        
        [TLUser user].unReadMsgCount = unReadCount;
        
        [IMAPlatform setAutoLogin:YES];
        //        [_loginParam saveToLocal];
        
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
