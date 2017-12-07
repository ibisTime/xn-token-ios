//
//  UILabel+Extension.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

//调整行间距
- (void)labelWithTextString:(NSString *)textString lineSpace:(CGFloat)lineSpace;

/**
 同一个string里不同的颜色和字体
 @param string 全部文字
 @param title 不同颜色的文字
 @param font 字体大小
 @param color 字体颜色
 */
- (void)labelWithString:(NSString *)string title:(NSString *)title font:(UIFont *)font color:(UIColor *)color;

/**
 同一个string里不同的颜色和字体
 @param string 全部文字
 @param title 不同颜色的文字
 @param font 字体大小
 @param color 字体颜色
 @param lineSpace 行间距
 */
- (void)labelWithString:(NSString *)string title:(NSString *)title font:(UIFont *)font color:(UIColor *)color lineSpace:(CGFloat)lineSpace;

//获取label的行数
- (NSInteger)getLinesArrayOfStringInLabel;

@end
