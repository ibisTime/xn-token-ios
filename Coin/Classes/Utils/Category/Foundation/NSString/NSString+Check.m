//
//  NSString+Check.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NSString+Check.h"

@implementation NSString (Check)

+ (BOOL)isValidatePhoneNumber:(NSString *)mobile {
    
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (mobile.length != 11) {
        
        return NO;
    }
    else {
        
        /**
         
         * 移动号段正则表达式
         
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        
        /**
         
         * 联通号段正则表达式
         
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        
        /**
         
         * 电信号段正则表达式
         
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            
            return YES;
            
        }
        else {
            
            return NO;
            
        }
    }
}

- (BOOL)isValidateEmail {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)bankCardluhmCheck{
    NSString * lastNum = [[self substringFromIndex:(self.length-1)] copy];//取出最后一位
    NSString * forwardNum = [[self substringToIndex:(self.length -1)] copy];//前15或18位
    
    NSMutableArray * forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<forwardNum.length; i++) {
        NSString * subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }
    
    NSMutableArray * forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = (int)(forwardArr.count-1); i> -1; i--) {//前15位或者前18位倒序存进数组
        [forwardDescArr addObject:forwardArr[i]];
    }
    
    NSMutableArray * arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 < 9
    NSMutableArray * arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 > 9
    NSMutableArray * arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];//偶数位数组
    
    for (int i=0; i< forwardDescArr.count; i++) {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i%2) {//偶数位
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        }else{//奇数位
            if (num * 2 < 9) {
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            }else{
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }
    
    __block  NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNumTotal += [obj integerValue];
    }];
    
    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNum2Total += [obj integerValue];
    }];
    
    __block NSInteger sumEvenNumTotal =0 ;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumEvenNumTotal += [obj integerValue];
    }];
    
    NSInteger lastNumber = [lastNum integerValue];
    
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    
    return (luhmTotal%10 ==0)?YES:NO;
}

- (BOOL)isBlank
{
    NSString *s = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (s == nil || [s isEqualToString:@""]) {
        return true;
    }
    return false;
}

- (BOOL)isNotBlank
{
    NSString *s = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(s != nil && ![s isEqualToString:@""]) {
        return true;
    }
    return false;
}

- (BOOL)isPhoneNum {
    
    NSString *str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:@"^1[3,4,5,7,8]\\d{9}$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *regStr = @"^1[3,4,5,7,8]\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regStr];
    return [predicate evaluateWithObject:str];
    
}

- (BOOL)isBlankName
{
    if (self.length <= 0 || self.length > 40) {
        return NO;
    }
    
    if ([self isChinese]) {
        return YES;
    } else {
        return NO;
    }
    
}

- (BOOL)isBankCardNo
{
    if ([self isDigital]) {
        
        if (self.length >= 16 && self.length <= 30) {
            
            return YES;
            
        } else {
            
            return NO;
        }
        
    } else {
        
        return NO;
        
    }
    
}

- (BOOL)isDigital:(NSUInteger)length
{
    //    ^\d{n}$ n为数字
    //    ^[0-9]*$ 是否为数字
    if (length == 18) {
        return YES;
    }
    
    BOOL result = false;
    NSString *regex = [NSString stringWithFormat:@"^\\d{%ld}$",length];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:self];
    return result;
    
}

- (BOOL)isDigital
{
    //    ^\d{n}$ n为数字
    //    ^[0-9]*$ 是否为数字
    if(0 == self.length) return NO;
    
    BOOL result = false;
    NSString *regex =@"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:self];
    return result;
}


- (BOOL)isDigitalOrLetter
{
    if (self.length == 0) {
        return NO;
    }
    BOOL result = false;
    NSString *regex =@"^[0-9a-zA-Z]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:self];
    return result;
}

- (BOOL)isChinese
{
    if (![self valid]) {
        return NO;
    }
    
    BOOL flag = YES;
    for(int i=0; i< [self length];i++)
    {
        //       \u3400  \u9fcc
        int a = [self characterAtIndex:i];
        if( a >= 0x3400 && a <= 0x9fff){
            
        } else {
            flag = NO;
        }
    }
    return flag;
}

- (BOOL)isLegal
{
    if (!self.length) {
        return NO;
    }
    BOOL result = false;
    NSString *regex = @"^[A-Za-z0-9\u3400-\u9FFF_-]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:self];
    
    return result;
    
}

- (BOOL)valid {
    
    return  self != nil && self.length > 0;
    
}

- (NSString *)vaildString {
    
    if (self == nil || [self isKindOfClass:[NSNull class]]) {
        
        return @"";
    }
    
    return self;
}

@end
