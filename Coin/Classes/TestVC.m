//
//  TestVC.m
//  Coin
//
//  Created by  tianlei on 2018/1/01.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TestVC.h"
#import <TLSUI/TLSUI.h>
#import "ChatManager.h"

@interface TestVC ()

@end

@implementation TestVC


-(void)TLSUILoginOK:(TLSUserInfo*)userinfo {
    
    IMALoginParam *_loginParam = [IMALoginParam new];
    
    _loginParam.identifier = userinfo.identifier;
    _loginParam.userSig = [[TLSHelper getInstance] getTLSUserSig:userinfo.identifier];
    _loginParam.tokenTime = [[NSDate date] timeIntervalSince1970];
    
    [[ChatManager sharedManager] loginWithParam:_loginParam];
    

//    IMAUser *user = [[IMAUser alloc] initWith:@"tianlei02"];
//    IMAConversation *conversation = [[IMAPlatform sharedInstance].conversationMgr chatWith:user];
//    IMAMsg *msg = [IMAMsg msgWithText:@"12345"];
//    [conversation sendMessage:msg completion:^(NSArray *imamsgList, BOOL succ, int code) {
//
//        NSLog(@"发送成功");
//
//    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
