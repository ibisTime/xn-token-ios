//
//  NSString+Check.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Check)

// 验证手机号码合法性（正则）
+ (BOOL)isValidatePhoneNumber:(NSString *)phoneNumber;

// 验证邮箱合法性（正则）
- (BOOL)isValidateEmail;

//判断字符串是否为纯数字
+ (BOOL)isPureNumWithString:(NSString *)string;

- (BOOL)bankCardluhmCheck;

- (BOOL)isBlank;
- (BOOL)isNotBlank;

- (BOOL)isPhoneNum;

/** 是否为正确的银行名称 */
- (BOOL)isBlankName;

//是否为银行卡号
- (BOOL)isBankCardNo;

//指定长度的字符串是否为数字
- (BOOL)isDigital:(NSUInteger)length;
- (BOOL)isDigital;

//判断为字母或者数字的组合
- (BOOL)isDigitalOrLetter;

//检测
- (BOOL)isChinese;

//
- (BOOL)isLegal;

//基本验证 不为nil ， 且长度不为0
- (BOOL)valid;
//判断字符串是否为空
- (NSString *)vaildString;

@end
