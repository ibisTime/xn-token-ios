//
//  ChatManager.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/9.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMAPlatform+AppConfig.h"

#define CHAT_APP_ID 1400050575
#define CHAT_ACCOUNT_TYPE @"19287"
#define PUSH_DEV_BUSI_ID 7017
#define PUSH_DIS_BUSI_ID 7038


//托管模式
//#define CHAT_APP_ID 1400056456
//#define CHAT_ACCOUNT_TYPE @"21025"
//#define PUSH_DEV_BUSI_ID 7016



// MAPlatform+AppConfig.h 中设置了推送
// IMAPlatform( AppConfig )


@interface ChatManager : NSObject

+ (ChatManager *)sharedManager;

@property (nonatomic, copy, readonly) NSString *appId;
@property (nonatomic, copy, readonly) NSString *accountType;



///**
// groupId 或者 userId
// @return IMAUser 或者 IMAGroup
// */
//- (IMAUser *)getConversitionUserById:(NSString *)idStr;
//
///**
// groupId
// @return  或者 IMAGroup
// */
//- (IMAGroup *)getGroupByGroupId:(NSString *)groupId;

- (void)loginWithParam:(IMALoginParam *)loginParam;

/**
   应用启动一次，初始化一次即可
 */
- (void)initChat;


/**
 登录IM, 如果已经设置了自动登录，把参数取出进行登录
 */
- (void)loginIM;

- (void)testCount;

@end
