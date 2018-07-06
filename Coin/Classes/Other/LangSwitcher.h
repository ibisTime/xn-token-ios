//
//  LangSwitcher.h
//  Coin
//
//  Created by  tianlei on 2017/12/08.
//  Copyright © 2017年  tianlei. All rights reserved.
//
//语言切换
static NSString * const AppLanguage = @"appLanguage";
#define ZBLocalized(key, comment)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:AppLanguage]] ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:nil]

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, LangType) {
    LangTypeSimple,
    LangTypeTraditional,
    LangTypeEnglish
//    ,
//    LangTypeKorean,
//    LangTypeJapanese
};

@interface LangSwitcher : NSObject


/**
 key 传nil
 */
+ (NSString *)switchLang:(NSString *)content key:(NSString *)key;

+ (NSString *)currentLang;
+ (LangType)currentLangType;

+ (void)changLangType:(LangType)langType;

/**
 进行繁体初始化
 */
+ (void)startWithTraditional;
//初始化多语言功能
//- (void)initLanguage;
//
////当前语言
//- (NSString *)currentLanguage;
//
////设置要转换的语言
//- (void)setLanguage:(NSString *)language;
//
////设置为系统语言
//- (void)systemLanguage;
@end
