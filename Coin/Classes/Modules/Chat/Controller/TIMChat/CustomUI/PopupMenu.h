
//
//  PopupMenu.h
//  TIMChat
//
//  Created by AlexiChen on 16/2/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopupMenu : NSObject

+ (void) showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems;

+ (void) dismissMenu;

+ (UIColor *)tintColor;
+ (void)setTintColor:(UIColor *)tintColor;

+ (UIFont *)titleFont;
+ (void)setTitleFont: (UIFont *)titleFont;

@end
