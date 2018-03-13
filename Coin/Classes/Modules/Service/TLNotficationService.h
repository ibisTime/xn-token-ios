//
//  TLNotficationService.h
//  Coin
//
//  Created by  tianlei on 2018/2/07.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

//刷新广告列表
#define kAdvertiseListRefresh @"kAdvertiseListRefresh"

@interface TLNotficationService : NSObject

@end

typedef NS_ENUM(NSUInteger, TLNotificationType) {
    
    /**
     刷新广告列表
     */
    TLNotificationTypeRefreshAdsList = 0
    
};

@interface TLNotificationObj : NSObject

/**
 通知名称
 */
@property (nonatomic, copy) NSString *name;

/**
 通知类型
 */
@property (nonatomic, assign) TLNotificationType type;

/**
 通知内容
 */
@property (nonatomic, copy) NSString *content;

/**
 附加内容
 */
@property (nonatomic, copy) NSString *subContent;


/**
 文字注释
 */
@property (nonatomic, copy) NSString *contentIntroduce;

@end
