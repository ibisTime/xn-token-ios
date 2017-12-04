//
//  UITabBar+Badge.h
//  Coin
//
//  Created by 蔡卓越 on 2017/12/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点


@end
