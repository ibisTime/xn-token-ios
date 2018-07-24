//
//  UILable+convience.h
//  WeRide
//
//  Created by  tianlei on 2016/12/5.
//  Copyright © 2016年 trek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (convience)

- (instancetype)initWithFrame:(CGRect)frame
                 textAligment:(NSTextAlignment)aligment
              backgroundColor:(UIColor *)color
                         font:(UIFont *)font
                    textColor:(UIColor *)textColor;

+ (instancetype)labelWithFrame:(CGRect)frame
                 textAligment:(NSTextAlignment)aligment
              backgroundColor:(UIColor *)color
                         font:(UIFont *)font
                    textColor:(UIColor *)textColor;

//设置Label的字体
+ (UILabel *)labelWithBackgroundColor:(UIColor *)color textColor:(UIColor *)textColor font:(CGFloat)font;

/**
 黑色Label，带frame
 */
+ (UILabel *)labelWithTitle:(NSString *)title frame:(CGRect)frame;

+ (UILabel *)labelWithNaTitle:(NSString *)title frame:(CGRect)frame;

@end
