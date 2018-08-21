//
//  UIBarButtonItem+convience.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (convience)

/** 向导航栏上面添加按钮*/
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

/**向某个控制器添加文字型RightItem*/
+ (void)addRightItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor frame:(CGRect)frame vc:(UIViewController *)vc action:(SEL)action;

+ (instancetype)addRightItemWithTitle:(NSString *)title selectTitle:(NSString*)selectTitle target:(id)target action:(SEL)action;

/**向某个控制器添加图片型RightItem*/
+ (void)addRightItemWithImageName:(NSString *)imageName frame:(CGRect)frame vc:(UIViewController *)vc action:(SEL)action;

/**向某个控制器添加图片型LeftItem*/
+ (void)addLeftItemWithImageName:(NSString *)imageName frame:(CGRect)frame vc:(UIViewController *)vc action:(SEL)action;

/**向某个控制器添加View型right*/
+ (void)addRightItemWithView:(UIView*)view vc:(UIViewController *)vc;

/**
 *  向右添加item数组
 */

+ (void)addRightItemArray:(NSArray *)btnArray vc:(UIViewController *)vc;

@end
