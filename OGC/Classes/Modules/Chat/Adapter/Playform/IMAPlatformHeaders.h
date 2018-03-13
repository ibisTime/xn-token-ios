//
//  IMAPlatformHeaders.h
//  TIMAdapter
//
//  Created by AlexiChen on 16/2/17.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#ifndef IMAPlatformHeaders_h
#define IMAPlatformHeaders_h


typedef NS_ENUM(NSInteger, IMARefreshStyle) {
    EIMARefresh_None,   // 无更新
    EIMARefresh_ING,    // 正在刷新
    EIMARefresh_Wait,   // 正在刷新，下一个须等待
};


#import "IMAContactManager.h"
#import "IMAContactManager+SubGroup.h"
#import "IMAContactManager+Group.h"

#import "IMAConversationManager.h"

#import "IMAPlatformConfig.h"

#import "IMALoginParam.h"

#import "IMAPlatform.h"

#import "IMAPlatform+AppConfig.h"

#import "IMAPlatform+IMSDKCallBack.h"

#import "IMAPlatform+Login.h"

#import "IMAPlatform+FriendShip.h"

#import "IMAPlatform+Friend.h"

#import "IMAContactManager+User.h"

#endif /* IMPlatformHeader_h */
