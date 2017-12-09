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


/**
   做一些初始化工作
 */
- (void)initChat;


- (void)loginIM;

@end
