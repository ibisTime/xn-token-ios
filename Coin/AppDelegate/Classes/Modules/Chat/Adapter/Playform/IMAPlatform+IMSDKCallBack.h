//
//  IMAPlatform+IMSDKCallBack.h
//  TIMChat
//
//  Created by AlexiChen on 16/2/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAPlatform.h"
#import <ImSDK/TIMCallback.h>

// IMSDK回调（除MessageListener外）统一处理

@interface IMAPlatform (IMSDKCallBack)<TIMUserStatusListener, TIMConnListener, TIMRefreshListener, TLSRefreshTicketListener>


@end

@interface IMAPlatform (FriendShipListener)<TIMFriendshipListener>

@end

@interface IMAPlatform (GroupAssistantListener)<TIMGroupListener>

@end


