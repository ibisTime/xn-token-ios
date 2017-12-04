//
//  TopLabelUtil.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/2/7.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TopLabelStyle) {
    
    TopLabelStyleNormal,    //未超出范围
    TopLabelStyleMore, //超出屏幕范围
};

typedef NS_ENUM(NSInteger, LineType) {
    
    LineTypeTitleLength,         //字体长度
    LineTypeButtonLength,       //按钮长度
};

typedef void (^ClickBtnBlock)(NSInteger index);

@class TopLabelUtil;

@protocol SegmentDelegate;

@protocol SegmentDelegate <NSObject>

@required
-(void)segment:(TopLabelUtil *)segment didSelectIndex:(NSInteger)index;
@end

@interface TopLabelUtil : UIScrollView
//segment 文字数组
@property(nonatomic,strong) NSArray *titleArray;
//segment 文字颜色
@property(nonatomic,strong) UIColor *titleNormalColor;
//segment 选中时文字颜色
@property(nonatomic,strong) UIColor *titleSelectColor;
//segment 文字字体，默认15
@property(nonatomic,strong) UIFont  *titleFont;
//segment 默认选中按钮/视图 1
@property(nonatomic,assign) NSInteger defaultSelectIndex;
//segment 点击按钮触发事件代理
@property(nonatomic, assign) id<SegmentDelegate> delegate;
//底部线条长度
@property (nonatomic, assign) LineType lineType;
//小红点
@property (nonatomic, strong) UIView *redView;

//选择到哪个按钮
- (void)selectSortBarWithIndex:(NSInteger)index;

//视图偏移时，控件随着发生变化
-(void)dyDidScrollChangeTheTitleColorWithContentOfSet:(CGFloat)width;

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
