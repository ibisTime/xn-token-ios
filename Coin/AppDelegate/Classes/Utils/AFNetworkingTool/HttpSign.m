//
//  HttpSign.m
//  AFNetworkingTool
//
//  Created by 蔡卓越 on 15/11/15.
//  Copyright © 2015年 蔡卓越. All rights reserved.
//

#import "HttpSign.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HttpSign
// MD5加密
+ (NSString *)doMD5:(NSString *)signStr
{
    const char *cStr = [signStr UTF8String]; //转换成utf-8
    unsigned char result[16];  //开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5(cStr, (uint32_t)strlen(cStr), result);
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
}

// SHA1加密
+ (NSString *)doSHA1:(NSString *)signStr
{
    //用此方法中文字符串转data时会造成数据丢失
    //const char *cstr = [signStr UTF8String];
    //NSData *data = [NSData dataWithBytes:cstr length:signStr.length];
    NSData *data = [signStr dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (uint32_t)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

// SHA256加密
+ (NSString *)doSHA256:(NSString *)text
{
    //const char *cstr = [text UTF8String];
    //NSData *data = [NSData dataWithBytes:cstr length:text.length];
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, (uint32_t)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

// 小写转大写
+ (NSString *)lowercaseToUppercase:(NSString *)lowercase
{
    return [lowercase uppercaseString];
}

@end
