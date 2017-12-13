//
//  ChatManager.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/9.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>

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

/**
   应用启动一次，初始化一次即可
 */
- (void)initChat;


/**
 登录IM, 如果已经设置了自动登录，把参数取出进行登录
 */
- (void)loginIM;


@end
