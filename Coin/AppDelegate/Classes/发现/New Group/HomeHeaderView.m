//
//  HomeHeaderView.m
//  OGC
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "HomeHeaderView.h"

#import "UIColor+theme.h"
//Category
#import "UIButton+EnLargeEdge.h"
//V
#import "TLBannerView.h"

@interface HomeHeaderView()<HW3DBannerViewDelegate>
{
    NSInteger selectNum;
}

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
//        [self initBannerView];
        [self addSubview:self.scrollView];

    }
    return self;
}

-(HW3DBannerView *)scrollView
{
    if (!_scrollView) {
//        CoinWeakSelf;
        _scrollView = [HW3DBannerView initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 30, SCREEN_WIDTH/2 - 15) imageSpacing:10 imageWidth:SCREEN_WIDTH - 30];
        _scrollView.initAlpha = 0; // 设置两边卡片的透明度
        _scrollView.imageRadius = 5; // 设置卡片圆角
        _scrollView.imageHeightPoor = 20;// 设置占位图片
        _scrollView.delegate = self;
        _scrollView.autoScrollTimeInterval = 4;
//        _scrollView.data = @[@"banner",@"banner",@"banner"];
        _scrollView.clickImageBlock = ^(NSInteger currentIndex) {
            
            selectNum = currentIndex;
        };
    }
    return _scrollView;
}

-(void)HW3DBannerViewClick
{
    CoinWeakSelf;
    if (weakSelf.headerBlock) {
        weakSelf.headerBlock(HomeEventsTypeBanner, selectNum,nil);
    }
}

//-(void)click1:(UITapGestureRecognizer *)sender{
//
//}


#pragma mark - Init
//- (void)initBannerView {
//
//    CoinWeakSelf;
//
//    //顶部轮播
//    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(15, 5, kScreenWidth-30, kHeight(138))];
//    bannerView.layer.cornerRadius = 5;
//    bannerView.clipsToBounds = YES;
//
//    bannerView.selected = ^(NSInteger index) {
//
//        if (weakSelf.headerBlock) {
//
//            weakSelf.headerBlock(HomeEventsTypeBanner, index,nil);
//        }
//    };
//
//    [self addSubview:bannerView];
//
//    self.bannerView = bannerView;
//}

#pragma mark - Setting
- (void)setBanners:(NSMutableArray<BannerModel *> *)banners {

    _banners = banners;

    NSMutableArray *imgUrls = [NSMutableArray array];

    [banners enumerateObjectsUsingBlock:^(BannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if (obj.pic) {

            [imgUrls addObject:obj.pic];
        }
    }];
    _scrollView.data = imgUrls;
//    self.bannerView.imgUrls = imgUrls;

}



#pragma mark - Events
- (void)lookFlowList:(UITapGestureRecognizer *)tapGR {
    
    if (_headerBlock) {
        
        _headerBlock(HomeEventsTypeStatistics, 0,nil);
    }
}



@end
