//
//  HttpSign.h
//  AFNetworkingTool
//
//  Created by 蔡卓越 on 15/11/15.
//  Copyright © 2015年 蔡卓越. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpSign : NSObject

+ (NSString *)doMD5:(NSString *)signStr;

+ (NSString *)doSHA1:(NSString *)signStr;

+ (NSString *)doSHA256:(NSString *)text;

// 小写转大写
+ (NSString *)lowercaseToUppercase:(NSString *)lowercase;

@end
