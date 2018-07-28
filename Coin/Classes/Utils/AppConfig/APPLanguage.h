//
//  APPLanguage.h
//  Coin
//
//  Created by shaojianfei on 2018/7/28.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPLanguage : NSObject

@property (nonatomic , copy) NSString *currentLange;
+ (instancetype)currentLanguage;

@end
