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
//
//typedef NS_ENUM(NSInteger, PublishSellPositionType) {
//
//    PublishSellPositionTypePublish = 0,  //发布
//    PublishSellPositionTypeDraft,        //草稿
//};

@interface PublishSellVC : TLBaseVC

@property (nonatomic, strong) NSString *adsCode;

//@property (nonatomic, assign) PublishSellPositionType type;
@property (nonatomic, assign) PublishType publishType;


@end
