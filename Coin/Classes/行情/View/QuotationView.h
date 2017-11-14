//
//  QuotationView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLBannerView.h"
#import "NoticeModel.h"

typedef NS_ENUM(NSInteger, QuotationEventType) {
    
    QuotationEventTypeHTML = 0,         //banner链接
    QuotationEventTypeCoinDetail,       //虚拟币详情
    QuotationEventTypeNotice,           //系统公告
    QuotationEventTypeGuideDetail,      //指导详情
    
};

typedef void(^QuototionBlock)(QuotationEventType quototionType, NSInteger index);

@interface QuotationView : UIScrollView

@property (nonatomic, copy) QuototionBlock quotationBlock;
//轮播图
@property (nonatomic,strong) TLBannerView *bannerView;
//系统消息
@property (nonatomic,strong) NSMutableArray <NoticeModel *>*notices;

@end
