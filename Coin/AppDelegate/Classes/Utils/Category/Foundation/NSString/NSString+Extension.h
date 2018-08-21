//
//  NSString+Extension.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

// 处理空字符串
+ (NSString *)convertNullOrNil:(NSString *)str;

// 序列化JSON
+ (NSString *)serializeMessage:(id)message;

// 反序列化JSON
+ (id)deserializeMessageJSON:(NSString *)messageJSON;

//通过正则表达式截取字符串
+ (NSString *)stringWithRegularExpression:(NSString *)regularStr string:(NSString *)string;

//MD5加密
+ (NSString *)MD5:(NSString *)sourceString;

//根据返回的结果状态码，返回原因
+ (NSString *)stringWithReturnCode:(NSInteger)returnCode;

//图片转换
- (NSString *)convertImageUrl;
/**
 输出图片url
 @param scale 0~100的值
 */
- (NSString *)convertImageUrlWithScale:(NSInteger)scale;

//拼接字符串
- (NSAttributedString *)attrStr;

/** 返回加密MD5 string  32位字符串*/
- (NSString *)md5String;

//122.89元  转换为  122890厘
- (NSString *)convertToSysMoney;
//转换 乘以10的18次方
//- (NSString *)convertToSysCoin;

//- (NSString *)convertToSimpleRealCoin;
//减法
- (NSString *)subNumber:(NSString *)number;
//除法
- (NSString *)divNumber:(NSString *)number leaveNum:(NSInteger)num;

//能去掉小数点的尽量去掉小数点
- (NSString *)convertToSimpleRealMoney;

//位数
- (NSString *)convertToRealMoneyWithNum:(NSInteger)num;

//获取WiFiMac物理地址
+ (NSString *)getWifiMacAddress;

//获取IP
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSString *)appVersionString;

@end
