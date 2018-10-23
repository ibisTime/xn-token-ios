//
//  HomeHeaderView.m
//  OGC
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "HomeHeaderView.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "UIColor+theme.h"
//Category
#import "UIButton+EnLargeEdge.h"
#import "NSString+Extension.h"
#import "CoinUtil.h"
//V
#import "TLBannerView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HomeHeaderView()

//轮播图
@property (nonatomic,strong) TLBannerView *bannerView;
//统计
@property (nonatomic, strong) UIView *statisticsView;
//数据
@property (nonatomic, strong) UILabel *dataLbl;
//应用
@property (nonatomic, strong) UIView *applicationView;

@property (nonatomic, strong) UIButton *tempBtn;

@end

@implementation HomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        //轮播图
        [self initBannerView];

    }
    return self;
}

#pragma mark - Init
- (void)initBannerView {
    
    CoinWeakSelf;
    
    //顶部轮播
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(15, 5, kScreenWidth-30, kHeight(138))];
    bannerView.layer.cornerRadius = 5;
    bannerView.clipsToBounds = YES;
    
    bannerView.selected = ^(NSInteger index) {
        
        if (weakSelf.headerBlock) {
            
            weakSelf.headerBlock(HomeEventsTypeBanner, index,nil);
        }
    };
    
    [self addSubview:bannerView];
    
    self.bannerView = bannerView;
}

#pragma mark - Setting
- (void)setBanners:(NSMutableArray<BannerModel *> *)banners {

    _banners = banners;

    NSMutableArray *imgUrls = [NSMutableArray array];

    [banners enumerateObjectsUsingBlock:^(BannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if (obj.pic) {

            [imgUrls addObject:obj.pic];
        }
    }];
    self.bannerView.imgUrls = imgUrls;

}



#pragma mark - Events
- (void)lookFlowList:(UITapGestureRecognizer *)tapGR {
    
    if (_headerBlock) {
        
        _headerBlock(HomeEventsTypeStatistics, 0,nil);
    }
}



@end
