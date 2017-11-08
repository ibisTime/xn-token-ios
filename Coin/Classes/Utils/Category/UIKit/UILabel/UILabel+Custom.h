//
//  UILabel+Custom.h
//  BS
//
//  Created by 蔡卓越 on 16/4/7.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Custom)

/**
 白色Label
 */
+ (UILabel *)labelWithTitle:(NSString *)title;

/**
 黑色Label，带frame
 */
+ (UILabel *)labelWithTitle:(NSString *)title frame:(CGRect)frame;

//调整行间距
- (void)labelWithTextString:(NSString *)textString lineSpace:(CGFloat)lineSpace;

//设置Label的字体
+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)textColor textFont:(CGFloat)textFont;

//同一个string里不同的颜色和字体

/**

 @param string 全部文字
 @param title 不同颜色的文字
 @param font 字体大小
 @param color 字体颜色
 */
- (void)labelWithString:(NSString *)string title:(NSString *)title font:(UIFont *)font color:(UIColor *)color;

+ (UILabel *)labelWithFrame:(CGRect)frame
               textAligment:(NSTextAlignment)aligment
            backgroundColor:(UIColor *)color
                       font:(UIFont *)font
                  textColor:(UIColor *)textColor;

- (instancetype)initWithFrame:(CGRect)frame
                 textAligment:(NSTextAlignment)aligment
              backgroundColor:(UIColor *)color
                         font:(UIFont *)font
                    textColor:(UIColor *)textColor;

//获取label的行数
- (NSInteger)getLinesArrayOfStringInLabel;

@end
