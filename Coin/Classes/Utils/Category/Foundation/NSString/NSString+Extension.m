//
//  NSString+Extension.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

#import "AppConfig.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import <NetworkExtension/NetworkExtension.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <net/if.h>
#import <sys/sysctl.h>
#import <sys/socket.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation NSString (Extension)

+ (NSString *)convertNullOrNil:(NSString *)str {
    
    if ([str isKindOfClass:[NSNull class]]) {
        str = @"";
    }
    else if ([str isEqual:[NSNull class]]) {
        str = @"";
    }
    else if (str == nil) {
        str = @"";
    }
    return str;
}

+ (NSString *)stringWithRegularExpression:(NSString *)regularStr string:(NSString *)string {
    
    NSRange range = [string rangeOfString:regularStr options:NSRegularExpressionSearch];
    
    if (range.location != NSNotFound) {
        
        return [string substringWithRange:range];
    }
    
    return nil;
}
//序列化JSON
+ (NSString *)serializeMessage:(id)message {
    
    NSData *serizlizeData = [NSJSONSerialization dataWithJSONObject:message options:0 error:nil];
    return [[NSString alloc] initWithData:serizlizeData encoding:NSUTF8StringEncoding];
}

//反序列化JSON
+ (id)deserializeMessageJSON:(NSString *)messageJSON {
    
    if (messageJSON) {
        NSData *messageData = [messageJSON dataUsingEncoding:NSUTF8StringEncoding];
        return [NSJSONSerialization JSONObjectWithData:messageData options:NSJSONReadingMutableContainers error:nil];
        
    }
    return nil;
}

+ (NSString *)stringWithReturnCode:(NSInteger)returnCode {
    
    NSString *promptStr = @"";
    
    switch (returnCode) {
            
        case 400:
            promptStr = @"分享失败";
            break;
            
        case 505:
            promptStr = @"用户被封禁";
            break;
            
        case 510:
            promptStr = @"发送失败";
            break;
            
        case 522:
            promptStr = @"分享失败";
            break;
            
        case 5007:
            promptStr = @"发送内容为空";
            break;
            
        case 5016:
            promptStr = @"分享内容重复";
            break;
            
        case 5020:
            promptStr = @"分享失败";
            break;
            
        case 5027:
            promptStr = @"分享失败";
            break;
            
        case 5050:
            promptStr = @"网络错误";
            break;
            
        case 5051:
            promptStr = @"获取账户失败";
            break;
            
        case 5052:
            promptStr = @"取消分享";
            break;
            
        case 5053:
            promptStr = @"账号未登录";
            break;
            
        case 100031:
            promptStr = @"分享失败";
            break;
            
        default:
            break;
    }
    
    return promptStr;
}

- (NSAttributedString *)attrStr {
    
    return [[NSAttributedString alloc] initWithString:self];
    
}

- (NSString *)convertImageUrl {
    
    //auto-orient 根据原信息 旋转
    //strip 取出图片原信息
    return  [self convertImageUrlWithScale:75];
    
}

//scale 0-100
- (NSString *)convertImageUrlWithScale:(NSInteger)scale {
    
    if ([self hasPrefix:@"http"] || [self hasPrefix:@"https"]) {
        
        return self;
        
    } else {
        
        //        return [[@"http:/7xnuu2.com1.z0.glb.clouddn.com/" add:self] add:@"?imageMogr2/auto-orient/strip/quality/50!"];
        NSString *imageUrl = [[NSString stringWithFormat:@"%@/%@?imageMogr2/auto-orient/strip/quality/%ld!",[AppConfig config].qiniuDomain,self,scale] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        return imageUrl;
    }
    
}

- (NSString *)convertOriginalImgUrl {
    
    if ([self hasPrefix:@"http"] || [self hasPrefix:@"https"]) {
        
        return self;
        
    } else {
        
        return  [[NSString stringWithFormat:@"%@/%@?imageMogr2/auto-orient/strip",[AppConfig config].qiniuDomain,self] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    
}

- (NSString *)md5String
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

//获取app版本号
+ (NSString *)appVersionString {
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)convertToSysMoney {
    
    double v = [self doubleValue];
    double t0 = v*1000;
    long long money = (long long)t0;
    return [NSString stringWithFormat:@"%lld",money];
}

- (NSString *)convertToSysCoin {
    
    NSDecimalNumber *m = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *n = [NSDecimalNumber decimalNumberWithString:[@(1.0e+18) stringValue]];
    NSDecimalNumber *o = [m decimalNumberByMultiplyingBy:n];
    return [o stringValue];
    
}

- (NSString *)convertToSimpleRealCoin {
    
    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
    }
    
    NSRoundingMode mode = [self hasPrefix:@"-"] ? NSRoundUp : NSRoundDown;
    
    //保留8位小数,第九位舍去
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode
                                                                                             scale:8                   raiseOnExactness:NO
raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSDecimalNumber *m = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *n = [NSDecimalNumber decimalNumberWithString:[@(1.0e+18) stringValue]];
    NSDecimalNumber *o = [m decimalNumberByDividingBy:n];
    
    //最终结果
    NSDecimalNumber *p = [o decimalNumberByRoundingAccordingToBehavior:handler];
    
    return [NSString stringWithFormat:@"%@",p];
}

//减法
- (NSString *)subNumber:(NSString *)number {
    
    //保留8位小数,第九位舍去
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                             scale:8
                                                                                  raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSDecimalNumber *m = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *n = [NSDecimalNumber decimalNumberWithString:number];
    NSDecimalNumber *o = [m decimalNumberBySubtracting:n];
    NSDecimalNumber *p = [o decimalNumberByRoundingAccordingToBehavior:handler];
    
    return [NSString stringWithFormat:@"%@",p];
}

//除法
- (NSString *)divNumber:(NSString *)number leaveNum:(NSInteger)num {
    
    //保留8位小数,第九位舍去
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown

                                                                                             scale:num
                                                  raiseOnExactness:NO
                   raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSDecimalNumber *m = [NSDecimalNumber decimalNumberWithString:self];
    
    NSDecimalNumber *n = [NSDecimalNumber decimalNumberWithString:number];
    
    NSDecimalNumber *o = [m decimalNumberByDividingBy:n];
    
    NSDecimalNumber *p = [o decimalNumberByRoundingAccordingToBehavior:handler];
    
    return [NSString stringWithFormat:@"%@",p];
}

//能去掉小数点的尽量去掉小数点
- (NSString *)convertToSimpleRealMoney {
    
    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
        
    }
    
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                             scale:2
                                                                                  raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *result = [price decimalNumberByRoundingAccordingToBehavior:handler];
    return [result stringValue];
    
}

- (NSString *)convertToRealMoneyWithNum:(NSInteger)num {
    
    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
    }
    
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:num raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:self];
    
    NSDecimalNumber *result = [price decimalNumberByRoundingAccordingToBehavior:handler];
    
    return [result stringValue];
    
}

+ (NSString *)getWifiMacAddress {
    
    NSArray *ifs = CFBridgingRelease(CNCopySupportedInterfaces());
    
    id info = nil;
    
    for (NSString *ifname in ifs) {
        
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef)ifname);
        
        if (info && [info count]) {
            
            break;
        }
    }
    
    NSDictionary *dic = (NSDictionary *)info;
    
    NSString *wifiMacAddress = [dic objectForKey:@"BSSID"];
    
    NSArray *mac = [wifiMacAddress componentsSeparatedByString:@":"];
    
    NSMutableString *wifiAddress = [NSMutableString string];
    
    
    for (int i = 0 ; i < mac.count; i++) {
        
        NSString *sub = mac[i];
        
        if (sub.length == 1) {
            
            [wifiAddress appendString:[NSString stringWithFormat:@"0%@", sub]];
            
        } else {
            
            [wifiAddress appendString:sub];
            
        }
    }
    
    return wifiAddress;
}

#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


@end
