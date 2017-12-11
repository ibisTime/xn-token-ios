//
//  LangSwitcher.m
//  Coin
//
//  Created by  tianlei on 2017/12/08.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "LangSwitcher.h"
#import "ZMChineseConvert.h"

@implementation LangSwitcher

+ (NSString *)switchLang:(NSString *)content key:(NSString *)key {
    
    
    
   return [ZMChineseConvert convertSimplifiedToTraditional:content];

//    [NSLocale currentLocale]
//    return content;
    
}


+ (NSString *)switchLang:(NSString *)content {
    return content;
}

@end
