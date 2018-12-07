//
//  FindTheGameModel.m
//  Coin
//
//  Created by 郑勤宝 on 2018/12/6.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "FindTheGameModel.h"

@implementation FindTheGameModel

-(NSArray *)picListArray
{
    if (!_picListArray) {
        
        NSArray *imgs = [self.picScreenshot componentsSeparatedByString:@"||"];
        NSMutableArray *newImgs = [NSMutableArray arrayWithCapacity:imgs.count];
        [imgs enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj convertImageUrl]) {
                
                
                [newImgs addObject:[obj convertImageUrl]];
            }
        }];
        
        _picListArray = newImgs;
    }
    
    return _picListArray;
}

-(NSArray *)labelArray
{
    if (!_labelArray) {
        
        NSArray *imgs = [self.label componentsSeparatedByString:@"||"];
        NSMutableArray *newImgs = [NSMutableArray arrayWithCapacity:imgs.count];
        [imgs enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [newImgs addObject:obj];
        }];
        
        _labelArray = newImgs;
    }
    
    return _labelArray;
}

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"ID"]) {
        return @"id";
    }
    
    return propertyName;
}

@end
