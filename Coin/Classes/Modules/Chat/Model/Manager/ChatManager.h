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

//登录


- (void)chatLoginOut;
//消息
- (void)getAllConversionFromDB;

- (NSInteger)unreadMsgCount;

//获取腾讯云IM签名、账号并登录
- (void)getTencentSign;

@end
