//
//  UITabBar+Badge.m
//  Coin
//
//  Created by 蔡卓越 on 2017/12/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "UITabBar+Badge.h"

#define TabbarItemNums 5.0    //tabbar的数量

@implementation UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index{
    
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    CGFloat badgeW = 8;
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = badgeW/2.0;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.65) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, badgeW, badgeW);
    [self addSubview:badgeView];
    
}

- (void)hideBadgeOnItemIndex:(int)index{
    
    //移除小红点
    [self removeBadgeOnItemIndex:index];
    
}

- (void)removeBadgeOnItemIndex:(int)index{
    
    //按照tag值进行移除
    
    UIView *badgeView = [self viewWithTag:888+index];
    if (badgeView) {
        [badgeView removeFromSuperview];
    }
    
//    for (UIView *subView in self.subviews) {
//
//        if (subView.tag == 888+index) {
//
//            [subView removeFromSuperview];
//
//        }
//    }
}

@end
