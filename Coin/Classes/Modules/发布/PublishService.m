//
//  PublishService.m
//  Coin
//
//  Created by  tianlei on 2017/12/07.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PublishService.h"
#import "OverTimeModel.h"


NSString *const kSaveDraft = @"0";
NSString *const kPublish = @"1";
NSString *const kPublishDraft = @"2";
NSString *const kPublishRedit = @"3";


NSString *const kPublishTradeTypeSell = @"1";
NSString *const kPublishTradeTypeBuy = @"0";


@interface PublishService()

@property (nonatomic, strong) NSMutableArray <NSString *> *limitTimes;

@end

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

+ (instancetype)shareInstance {
    
    static PublishService *publishService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        publishService = [[PublishService alloc] init];
        
    });
    
    return publishService;
    
}


- (NSArray <NSString *> *)obtainLimitTimes {
    
    return self.limitTimes;
}

- (void)handleOutLimitTime:(NSArray *)arr{
    
    
    NSArray <OverTimeModel *>*data = [OverTimeModel tl_objectArrayWithDictionaryArray:arr];
    
    self.limitTimes = [[NSMutableArray alloc] init];
    
    
    [[data reversedArray]  enumerateObjectsUsingBlock:^(OverTimeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.limitTimes addObject:obj.dvalue];
        
        
    }];
        
}



@end


