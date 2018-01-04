//
//  TLPublishSellVC.h
//  Coin
//
//  Created by  tianlei on 2018/1/03.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "PublishService.h"

// 卖币 还是 买币

@interface TLPublishSellVC : TLBaseVC

@property (nonatomic, strong) NSString *adsCode;

@property (nonatomic, assign) PublishType publishType;

@end
