//
//  HomeHeaderView.h
//  OGC
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
//M
#import "BannerModel.h"

typedef NS_ENUM(NSInteger, HomeEventsType) {
    
    HomeEventsTypeBanner = 0,   //Banner图
    HomeEventsTypeStatistics,   //统计
};

typedef void(^HomeHeaderEventsBlock)(HomeEventsType type, NSInteger index);

@interface HomeHeaderView : UIView

@property (nonatomic, copy) HomeHeaderEventsBlock headerBlock;
//
@property (nonatomic, strong) NSMutableArray <BannerModel *>*banners;

@end
