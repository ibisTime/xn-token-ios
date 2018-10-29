//
//  HW3DBannerView.h
//  cycleScrollDemo
//
//  Created by 李含文 on 2017/12/26.
//  Copyright © 2017年 SK丿希望. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HW3DBannerViewDelegate <NSObject>

-(void)HW3DBannerViewClick;

@end

@interface HW3DBannerView : UIView<UIScrollViewDelegate>

@property (nonatomic, assign) id <HW3DBannerViewDelegate> delegate;

/**
 图片间有间距  又要有翻页效果～～
 @param imageSpacing 图片间 间距
 @param imageWidth 图片宽
 */
+(instancetype)initWithFrame:(CGRect)frame
                imageSpacing:(CGFloat)imageSpacing
                  imageWidth:(CGFloat)imageWidth;
/**
 图片间有间距  又要有翻页效果～～
 @param imageSpacing 图片间 间距
 @param imageWidth 图片宽
 @param data 数据
 */
+(instancetype)initWithFrame:(CGRect)frame
                imageSpacing:(CGFloat)imageSpacing
                  imageWidth:(CGFloat)imageWidth
                        data:(NSArray *)data;

/** 点击中间图片的回调 */
@property (nonatomic, copy) void (^clickImageBlock)(NSInteger currentIndex);
/** 图片的圆角半径 */
@property(nonatomic, assign) CGFloat imageRadius;
/** 数据源 */
@property (nonatomic,strong) NSArray *data;
/** 图片高度差 默认0 */
@property (nonatomic, assign) CGFloat imageHeightPoor;
/** 初始alpha默认1 */
@property (nonatomic, assign) CGFloat initAlpha;


/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL showPageControl;
/** 当前小圆点颜色 */
@property(nonatomic,retain)UIColor *curPageControlColor;
/** 其余小圆点颜色  */
@property(nonatomic,retain)UIColor *otherPageControlColor;


/** 占位图*/
@property (nonatomic,strong) UIImage  *placeHolderImage;
/** 是否在只有一张图时隐藏pagecontrol，默认为YES */
@property(nonatomic) BOOL hidesForSinglePage;
/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;
/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;

@end
#pragma mark - 使用方法
//#import "HW3DBannerView.h"
//
//
//#define KScreenWidth self.view.frame.size.width
//#define KScreenHeight self.view.frame.size.height
//@property (nonatomic,strong) HW3DBannerView *scrollView;
//@property (nonatomic,strong) HW3DBannerView *scrollView1;
//#pragma mark - 3D滚动图
//_scrollView = [HW3DBannerView initWithFrame:CGRectMake(0, 100, KScreenWidth, 150) imageSpacing:10 imageWidth:KScreenWidth - 50];
//
//_scrollView.initAlpha = 0.5;
//_scrollView.imageRadius = 10;
//_scrollView.imageHeightPoor = 10;
//self.scrollView.data = @[@"http://d.hiphotos.baidu.com/image/pic/item/b7fd5266d016092408d4a5d1dd0735fae7cd3402.jpg",@"http://h.hiphotos.baidu.com/image/h%3D300/sign=2b3e022b262eb938f36d7cf2e56085fe/d0c8a786c9177f3e18d0fdc779cf3bc79e3d5617.jpg",@"http://a.hiphotos.baidu.com/image/pic/item/b7fd5266d01609240bcda2d1dd0735fae7cd340b.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/728da9773912b31b57a6e01f8c18367adab4e13a.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/0d338744ebf81a4c5e4fed03de2a6059242da6fe.jpg"];
//[self.view addSubview:self.scrollView];
//_scrollView.clickImageBlock = ^(NSInteger currentIndex) {
//
//};
//
//#pragma mark - 普通滚动图
//_scrollView1 = [HW3DBannerView initWithFrame:CGRectMake(0, 300, KScreenWidth, 150) imageSpacing:0 imageWidth:KScreenWidth];
//_scrollView1.clickImageBlock = ^(NSInteger currentIndex) {
//
//};
//_scrollView1.initAlpha = 1;
//self.scrollView1.data = @[@"http://d.hiphotos.baidu.com/image/pic/item/b7fd5266d016092408d4a5d1dd0735fae7cd3402.jpg",@"http://h.hiphotos.baidu.com/image/h%3D300/sign=2b3e022b262eb938f36d7cf2e56085fe/d0c8a786c9177f3e18d0fdc779cf3bc79e3d5617.jpg",@"http://a.hiphotos.baidu.com/image/pic/item/b7fd5266d01609240bcda2d1dd0735fae7cd340b.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/728da9773912b31b57a6e01f8c18367adab4e13a.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/0d338744ebf81a4c5e4fed03de2a6059242da6fe.jpg"];
//[self.view addSubview:self.scrollView1];

