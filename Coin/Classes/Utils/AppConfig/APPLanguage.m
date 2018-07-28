//
//  APPLanguage.m
//  Coin
//
//  Created by shaojianfei on 2018/7/28.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "APPLanguage.h"

@implementation APPLanguage


-(void)setCurrentLange:(NSString *)currentLange
{
    
    _currentLange = currentLange;
}

+ (instancetype)currentLanguage {
    
    static dispatch_once_t onceToken;
    static APPLanguage *langue;
    dispatch_once(&onceToken, ^{
        
        langue = [[APPLanguage alloc] init];
        
    });
    
    return langue;
}
@end
