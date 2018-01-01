//
//  XGPushHandler.m
//  Coin
//
//  Created by  tianlei on 2017/12/29.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "XGPushHandler.h"
#import "XGPush.h"

@implementation XGPushHandler

+ (instancetype)handler {
    
    static XGPushHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        handler = [[XGPushHandler alloc] init];
        
    });
    
    return handler;
}


/**
 @brief 监控token对象绑定的情况
 
 @param identifier token对象绑定的标识
 @param type token对象绑定的类型
 @param error token对象绑定的结果信息
 */
- (void)xgPushDidBindWithIdentifier:(nullable NSString *)identifier type:(XGPushTokenBindType)type error:(nullable NSError *)error {
    
    
}


/**
 @brief 监控token对象解绑的情况
 
 @param identifier token对象绑定的标识
 @param type token对象绑定的类型
 @param error token对象绑定的结果信息
 */
- (void)xgPushDidUnbindWithIdentifier:(nullable NSString *)identifier type:(XGPushTokenBindType)type error:(nullable NSError *)error {
    
    
}


@end
