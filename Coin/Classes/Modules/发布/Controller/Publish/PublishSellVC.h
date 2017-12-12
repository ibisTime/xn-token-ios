//
//  PublishSellVC.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "PublishService.h"
#import "AdvertiseModel.h"


/**
 发布出售广告, 卖币广告
 */
@interface PublishSellVC : TLBaseVC

@property (nonatomic, strong) NSString *adsCode;

@property (nonatomic, assign) PublishType publishType;


@end
