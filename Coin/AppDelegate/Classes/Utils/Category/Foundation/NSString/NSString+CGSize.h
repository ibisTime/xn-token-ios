//
//  NSString+CGSize.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (CGSize)

//计算字符串长度
- (CGSize)calculateStringSize:(CGSize)size font:(UIFont *)font;

//根据string和font获取字的宽度
+ (CGFloat)getWidthWithString:(NSString *)string font:(CGFloat)font;

@end
