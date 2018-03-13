//
//  NSString+Date.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)

// 根据指定格式将 NSDate 转换为 NSString
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter;

// 根据指定格式将 NSString 转换为 NSDate
+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter;

//获取当前时间
+ (NSDate *)getLoaclDateWithFormatter:(NSString *)formatter;

// 根据时间戳得到时间字符串
+ (NSString*)stringFromTimeStamp:(NSString*)timeStampStr;

// 根据时间格式和时间戳字符串 获取时间字符串
+ (NSString*)stringFromTimeStamp:(NSString *)timeStampStr formatter:(NSString *)formatter;

// 根据字符串时间戳获取日历DateComponents
- (NSDateComponents*)timeIntetvalStringToDateComponents;

// 获取当前时间的日历
+ (NSDateComponents*)getCurrentComponents;

// 根据时间戳得到字符串
+ (NSString*)stringWithTimeStamp:(NSString *)timeStampStr;


// 根据时间格式和时间戳字符串 获取时间字符串
+ (NSString*)stringWithTimeStamp:(NSString *)timeStampStr formatter:(NSString *)formatter;

//根据字符串和字符串时间格式获取指定时间格式字符串
+ (NSString *)stringWithTimeString:(NSString *)timeString timeFormatter:(NSString *)timeFormatter fotmatter:(NSString *)formatter;

//根据时间获取指定的时间
+ (NSString *)stringWithTimeStr:(NSString *)timeStampStr format:(NSString *)format;

//时间转换  Jan 5, 2017 12:00:00 AM -> 2016-02-02
- (NSString *)convertToDetailDate; //带有时分秒

//时间线的时间，一周， 1小时后，
- (NSString *)convertToTimelineDate;

- (NSString *)convertDate;



- (NSDate *)convertToSysDate;
//转为指定格式
- (NSString *)convertDateWithFormat:(NSString *)format;

@end

FOUNDATION_EXTERN NSString  * const kCDSysTimeFormat;
