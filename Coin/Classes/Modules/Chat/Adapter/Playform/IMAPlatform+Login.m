//
//  IMAPlatform+Login.m
//  TIMChat
//
//  Created by AlexiChen on 16/2/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAPlatform+Login.h"

#import "TLAlert.h"

@implementation IMAPlatform (Login)

//互踢下线错误码

#define kEachKickErrorCode 6208
- (void)login:(TIMLoginParam *)param succ:(TIMLoginSucc)succ fail:(TIMFail)fail
{
    if (!param)
    {
        if (fail)
        {
            fail(-1,@"参数错误");
        }
        return;
    }
    
    __weak IMAPlatform *ws = self;
    [[TIMManager sharedInstance] login:param succ:^{
        
        DebugLog(@"登录成功:%@ tinyid:%llu sig:%@", param.identifier, [[IMSdkInt sharedInstance] getTinyId], param.userSig);
        [IMAPlatform setAutoLogin:YES];
        //去掉此处的获取群里表，放到IMAPlatform+IMSDKCallBack 的 onRefresh中去，如果直接在这里获取群里表，第一次安装app时，会拉去不到群列表
//        [ws configGroup];
        
        if (succ)
        {
            succ();
        }
    } fail:^(int code, NSString *msg) {
        
        DebugLog(@"TIMLogin Failed: code=%d err=%@", code, msg);
        if (code == kEachKickErrorCode)
        {
            //互踢重联，重新再登录一次
            [ws offlineKicked:param succ:succ fail:fail];
        }
        else
        {
            if (fail)
            {
                fail(code, msg);
            }
        }
    }];
}

- (void)registNotification
{
    [[IMAPlatform sharedInstance] configOnAppLaunchWithOptions:nil];
}

//离线被踢
//用户离线时，在其它终端登录过，再次在本设备登录时，会提示被踢下线，需要重新登录
- (void)offlineKicked:(TIMLoginParam *)param succ:(TIMLoginSucc)succ fail:(TIMFail)fail
{
    __weak typeof(self) ws = self;
    
    [TLAlert alertWithTitle:@"下线通知" message:@"您的帐号于另一台手机上登录。" confirmMsg:@"重新登录" confirmAction:^{
        
        [ws offlineLogin];
        // 重新登录
        [ws login:param succ:^{
            
            [TLAlert alertWithSucces:@"登录成功"];
            
            [ws registNotification];
            succ ? succ() : nil;
            
        } fail:fail];
        
    }];
}

- (void)configGroup
{
    [self.contactMgr asyncConfigGroup];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)configHost:(TIMLoginParam *)param
{
    if (!_host)
    {
        _host = [[IMAHost alloc] init];
    }
    _host.loginParm = param;
    [_host asyncProfile];
}
#pragma clang diagnostic pop

- (void)configConversation
{
//    [self.conversationMgr asyncConversationList];
}

- (void)configContact
{
    [self.contactMgr asyncConfigContact];
}

- (void)configOnLoginSucc:(TIMLoginParam *)param
{
    // 配置, 获取个人名片
    [self configHost:param];
    
    // 获取好友列表
    //不能在登录成功之后获取好友里表，需要在OnProxyStatusChange回调成功的时候获取好友列表，否则可能获取不到
//    [self configContact];
    
    // 获取会话列表
    [self configConversation];
}


@end
