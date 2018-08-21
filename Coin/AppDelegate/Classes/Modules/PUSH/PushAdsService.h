//
//  AdsService.h
//  Coin
//
//  Created by  tianlei on 2017/12/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AdvertiseModel;
@class UIViewController;
@interface PushAdsService : NSObject


+ (void)pushToAdsDetail:(AdvertiseModel *)advertiseModel currentVC:(UIViewController *)currentVC ;

@end
