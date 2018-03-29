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


#define LANG @"LANG"


@implementation LangSwitcher

+ (NSString *)switchLang:(NSString *)content key:(NSString *)key {
    
    NSString *lang = [[NSUserDefaults standardUserDefaults] objectForKey:LANG];
    if (!lang || [lang isEqualToString:SIMPLE]) {
        return content;
    }

   return [ZMChineseConvert convertSimplifiedToTraditional:content];
    
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
        return LangTypeTraditional;
    }

    return LangTypeSimple;
    
}



+ (NSString *)currentLang {
    
    NSDictionary *dict = @{
                           SIMPLE : @"简体中文",
                           TRADITIONAL : @"繁体中文"
                           };
    
    NSString *lang = [[NSUserDefaults standardUserDefaults] objectForKey:LANG];
    if (!lang) {
        return dict[SIMPLE];
    }
    //
    return [self switchLang:dict[lang]? : dict[SIMPLE] key:nil];
    
}

+ (void)changLangType:(LangType)langType {
    
   NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
    switch (langType) {
        case LangTypeSimple: {
            
            [userDefaults setObject:SIMPLE forKey:LANG];
            
        } break;
        case LangTypeTraditional: {
            
            [userDefaults setObject:TRADITIONAL forKey:LANG];

        } break;

    }
    
}

+ (void)startWithTraditional {
    
    NSString *lang = [[NSUserDefaults standardUserDefaults] objectForKey:LANG];
    if (!lang || lang.length <= 0) {
        
        [self changLangType:LangTypeTraditional];
    }
    
}





@end
