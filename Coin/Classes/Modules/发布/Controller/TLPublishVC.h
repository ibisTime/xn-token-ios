//
//  TLPublishSellVC.h
//  Coin
//
//  Created by  tianlei on 2018/1/03.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "PublishService.h"

typedef NS_ENUM(NSUInteger, TLPublishVCType) {
    TLPublishVCTypeSell = 0,
    TLPublishVCTypeBuy = 1
};
// 卖币 还是 买币

@interface TLPublishVC : TLBaseVC

@property (nonatomic, strong) NSString *adsCode;


//以下必须同时设置
@property (nonatomic, assign) TLPublishVCType VCType;
@property (nonatomic, assign) PublishType publishType;

@end
