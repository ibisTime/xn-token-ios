//
//  AdsTradeDetailVC.h
//  Coin
//
//  Created by  tianlei on 2017/12/09.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "ChatManager.h"
@class UserInfo;

@interface AdsTradeDetailVC : TLBaseVC


/**
 groupId 和 订单 id 相同
 */
- (void)goChatWithGroupId:(NSString *)groupId toUser:(UserInfo *)toUser;

@end
