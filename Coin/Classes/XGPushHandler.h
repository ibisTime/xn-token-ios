//
//  XGPushHandler.h
//  Coin
//
//  Created by  tianlei on 2017/12/29.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XGPush.h"

@interface XGPushHandler : NSObject<XGPushTokenManagerDelegate>

+ (instancetype)handler;

@end
