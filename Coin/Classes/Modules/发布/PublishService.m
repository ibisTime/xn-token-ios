//
//  PublishService.m
//  Coin
//
//  Created by  tianlei on 2017/12/07.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PublishService.h"

NSString *const kSaveDraft = @"0";
NSString *const kPublish = @"1";
NSString *const kPublishDraft = @"2";
NSString *const kPublishRedit = @"3";


NSString *const kPublishTradeTypeSell = @"1";
NSString *const kPublishTradeTypeBuy = @"0";

@implementation PublishService

+ (NSString *)publishCodeByType:(PublishType) type {
    

    switch (type) {
        case PublishTypePublish: {
            
            return kPublish;
            
        }  break;
            
        case PublishTypeSaveDraft: {
            
            return kSaveDraft;
            
        }  break;
            
        case PublishTypePublishDraft: {
            
            return kPublishDraft;
            
        }  break;
            
        case PublishTypePublishRedit: {
            
            return   kPublishRedit;
            
        }  break;

    }
    
    return nil;
    
}


@end


