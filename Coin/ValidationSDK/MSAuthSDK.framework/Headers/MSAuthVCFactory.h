//
//  MSAuthVCFactory.h
//  MSAuthSDK
//
//  Created by Jeff Wang on 16/4/6.
//  Copyright © 2016年 Jeff Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAuthProtocol.h"

typedef enum {
    env_daily,
    env_pre,
    env_online
} env_type;

@interface MSAuthVCFactory : NSObject

/**
 *  获取验证VC的工厂方法
 *
 *  @param type     验证类型。目前支持的类型有滑动验证、短信验证和电话验证
 *  @param jsonData 聚安全服务器透传下发数据
 *  @param delegate 处理回调结果的代理
 *  @param language 需要展示的语言，如：zh_CN 简体中文, en 英文，language要和相应的Localizable.strings对应。nil为当前环境语言。如果语言文件不存在显示英文
 *  @param authCode 根据接入环境需要填入,比如0335，1222
 *  @param appKey   根据接入环境需要填入默认填写空
 *  @return 返回一个实例VC
 */
+ (UIViewController *)vcWithAuthType:(MSAuthType)type
                            jsonData:(NSString *)jsonData
                            language:(NSString *)lang
                            Delegate:(id<MSAuthProtocol>)delegate
                            authCode:(NSString *)code
                              appKey:(NSString *)key;


/**
 *  验证VC的工厂方法， 使用风险验证用户直接调用这个接口
 *  @param type     验证类型。目前支持的类型有滑动验证
 *  @param language 需要展示的语言，如：zh_CN 简体中文, en 英文，language要和相应的Localizable.strings对应。nil为当前环境语言。如果语言文件不存在显示英文
 *  @param delegate 处理回调结果的代理
 *  @param authCode 根据接入环境需要填入,比如0335，1222
 *  @param appKey   根据接入环境需要填入默认填写空
 *  @return         返回一个实例VC
 */

+ (UIViewController *)simapleVerifyWithType:(MSAuthType)type
                                   language:(NSString *)lang
                                   Delegate:(id<MSAuthProtocol>)delegate
                                   authCode:(NSString *)code
                                     appKey:(NSString *)key;


/**
 *  设置运行环境
 *
 *  @param type     运行环境参数
 */
+ (void)setEnv:(env_type)type;
+ (NSString *)version;

@end
