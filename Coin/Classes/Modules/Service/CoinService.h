//
//  CoinService.h
//  Coin
//
//  Created by  tianlei on 2018/2/03.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoinUtil.h"

@interface CoinService : NSObject

+ (instancetype)shareService;

- (NSString *)pageAddressApiCode:(NSString *)coin;

@end
