//
//  QuestionModel.m
//  Coin
//
//  Created by shaojianfei on 2018/8/4.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "QuestionModel.h"
#import <MJExtension/MJExtension.h>
@implementation QuestionModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Description": @"description"};
}

@end
