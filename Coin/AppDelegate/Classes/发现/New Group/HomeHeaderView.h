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
#import "HomeFindModel.h"
#import "HW3DBannerView.h"

typedef NS_ENUM(NSInteger, HomeEventsType) {
    
    HomeEventsTypeBanner = 0,   //Banner图
    HomeEventsTypeStatistics = 1,   //统计
    HomeEventsTypeStore = 2,        //商家
    HomeEventsTypeGoodMall = 3,     //在线商城
    HomeEventsTypePosMining = 4,    //Pos挖矿
    HomeEventsTypeRedEnvelope = 5,    //红包
};

typedef void(^HomeHeaderEventsBlock)(HomeEventsType type, NSInteger index, HomeFindModel*find);

@interface HomeHeaderView : UIScrollView

@property (nonatomic, copy) HomeHeaderEventsBlock headerBlock;

@property (nonatomic , strong)HW3DBannerView *scrollView;
//轮播图
@property (nonatomic, strong) NSMutableArray <BannerModel *>*banners;
//统计
//@property (nonatomic, strong) CountInfoModel *countInfo;
//@property (nonatomic,strong) NSArray <HomeFindModel *>*findModels;


@end
