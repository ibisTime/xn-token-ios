//
//  UserDefaultsUtil.m
//  LetWeCode
//
//  Created by 崔露凯 on 15/10/28.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#import "UserDefaultsUtil.h"

@implementation UserDefaultsUtil

#pragma mark - 基本方法
+ (BOOL)isContainObjectForKey:(NSString*)key {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        return YES;
    }
    return NO;
}

+ (void)setObject:(id)object forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString convertNullOrNil:object] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getObjectForKey:(NSString*)key {

    if ([self isContainObjectForKey:key]) {
       return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return nil;
}

+ (void)removeObjectForKey:(NSString*)key {

    if ([self isContainObjectForKey:key]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - 读写Cookie
+ (void)setUserDefaultCookie:(NSString*)cookie {
    
    [self setObject:cookie forKey:kUserDefaultCookie];
}

+ (NSString*)getUsetDefaultCookie {
   return [self getObjectForKey:kUserDefaultCookie];
}

#pragma mark - 读写用户名密码
+ (void)setUserDefaultName:(NSString*)userName {

    [self setObject:userName forKey:kUserDefaultUserName];
}

+ (NSString*)getUserDefaultName {
   return [self getObjectForKey:kUserDefaultUserName];
}

+ (void)setUserDefaultPassword:(NSString*)password {
    [self setObject:password forKey:kUserDefaultPassword];
}

+ (NSString*)getUserDefaultPassword {
    return [self getObjectForKey:kUserDefaultPassword];
}

+ (BOOL)isContainUserDefault {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUserLoginStatus];
}

+ (void)setUserLogin {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserLoginStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeUserLogin {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUserLoginStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma 判断测试环境
+ (void)setServiceSandbox:(BOOL)isSandbox {
    [[NSUserDefaults standardUserDefaults] setBool:isSandbox forKey:kIsSandbox];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getServiceSandbox {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsSandbox];
}



@end
