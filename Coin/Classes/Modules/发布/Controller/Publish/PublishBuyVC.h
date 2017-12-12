//
//  PublishBuyVC.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "PublishService.h"

#import "AdvertiseModel.h"


/**
 发布购买广告
 */
@interface PublishBuyVC : TLBaseVC

@property (nonatomic, copy) NSString *adsCode;

@property (nonatomic, assign) PublishType publishType;

@end
