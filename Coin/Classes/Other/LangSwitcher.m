//
//  LangSwitcher.m
//  Coin
//
//  Created by  tianlei on 2017/12/08.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "LangSwitcher.h"
#import "ZMChineseConvert.h"

#define SIMPLE @"simple"
#define TRADITIONAL @"Traditional"
#define ENGLISH @"English"
#define KOREAN @"Korean"
#define Japanese @"Japanese"


#define LANG @"LANG"


@implementation LangSwitcher

+ (NSString *)switchLang:(NSString *)content key:(NSString *)key {
    
    NSString *lang = [[NSUserDefaults standardUserDefaults] objectForKey:LANG];
    if (!lang || [lang isEqualToString:SIMPLE]) {
        return content;
    }else if ([lang isEqualToString:TRADITIONAL])
    {
        return [ZMChineseConvert convertSimplifiedToTraditional:content];
    }else{
        
        NSString *text = [NSBundle.mainBundle localizedStringForKey:(content) value:@"" table:nil];
       NSString *langue = [[NSUserDefaults standardUserDefaults] objectForKey:AppLanguage];
        NSLog(@"%@",text);
        NSLog(@"%@",langue);

        return ZBLocalized(content, nil);
//        return NSLocalizedStringFromTable(content,@"MyStrings", @"");

    }
    
    
}

+ (LangType)currentLangType {
    
    NSString *lang = [[NSUserDefaults standardUserDefaults] objectForKey:LANG];
    if (!lang) {
        return LangTypeSimple;
    }
    
    if ([lang isEqualToString:SIMPLE]) {
        return LangTypeSimple;
    }
    
    if ([lang isEqualToString:TRADITIONAL]) {
        return LangTypeEnglish;
    }
    if ([lang isEqualToString:ENGLISH]) {
        return LangTypeEnglish;
    }
//    if ([lang isEqualToString:KOREAN]) {
//        return LangTypeKorean;
//
//    }if ([lang isEqualToString:Japanese]) {
//        return LangTypeJapanese;
//    }

    return LangTypeEnglish;
    
}



+ (NSString *)currentLang {
    
    NSDictionary *dict = @{
                           SIMPLE : @"简体中文",                           ENGLISH : @"英文"
                           };
    
    NSString *lang = [[NSUserDefaults standardUserDefaults] objectForKey:LANG];
    if (!lang) {
        return dict[ENGLISH];
    }
    //
    return [self switchLang:dict[lang]? : dict[ENGLISH] key:nil];
    
}

+ (void)changLangType:(LangType)langType {
    
   NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
    switch (langType) {
        case LangTypeSimple: {
            
            [userDefaults setObject:SIMPLE forKey:LANG];
            NSString *lan =[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
            
            if ([lan hasPrefix:@"zh"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans-US" forKey:AppLanguage];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
        } break;
        case LangTypeTraditional: {
            
            [userDefaults setObject:ENGLISH forKey:LANG];

        } break;

        case LangTypeEnglish: {
            [userDefaults setObject:ENGLISH forKey:LANG];
            NSString *lan =[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
            
           
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            
            break;
        }
            
            default:
            break;
//        case LangTypeKorean: {
//            [userDefaults setObject:KOREAN forKey:LANG];
//
//            break;
//        }
//        case LangTypeJapanese: {
//            [userDefaults setObject:Japanese forKey:LANG];
//
//            break;
//        }
    }
    
}

+ (void)startWithTraditional {
    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];

    NSLog(@"currentlanguage = %@ alllanguage%@",currentLanguage,[NSLocale preferredLanguages]);

    NSString *lang = [[NSUserDefaults standardUserDefaults] objectForKey:LANG];
    if (!lang || lang.length <= 0) {
        
        //获取手机当前语言
        NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
        if ([currentLanguage isEqualToString:@"en-US"]||[currentLanguage isEqualToString:@"en"]) {
            [self changLangType:LangTypeEnglish];

            //英文
        }
//        else if ([currentLanguage isEqualToString:@"ko-US"])
//        {//韩文
//            [self changLangType:LangTypeKorean];
//
//
//        }else if ([currentLanguage isEqualToString:@"ja-US"])
//        {//日文
//            [self changLangType:LangTypeJapanese];
//
//
//        }
        else if ([currentLanguage isEqualToString:@"zh-Hant-US"]||[currentLanguage isEqualToString:@"zh-Hant-HK"])
        {//繁体
            [self changLangType:LangTypeSimple];

            
        }else if ([currentLanguage isEqualToString:@"zh-Hans-US"])
        {//简体
            [self changLangType:LangTypeSimple];

        }else{
            
            [self changLangType:LangTypeEnglish];

        }
        
    }else{
        
        
        [self changLangType:LangTypeEnglish];
        
    }
//zh-Hant-US zh-Hans-US
    
}





@end
