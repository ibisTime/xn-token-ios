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

//typedef NS_ENUM(NSInteger, PublishBuyPositionType) {
//
//    PublishBuyPositionTypePublish = 0,  //发布
//    PublishBuyPositionTypeDraft,        //草稿
//
//};

@interface PublishBuyVC : TLBaseVC

@property (nonatomic, copy) NSString *adsCode;

@property (nonatomic, assign) PublishType publishType;

@end
