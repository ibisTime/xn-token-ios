//
//  UIColor+Extension.h
//  MOOM
//
//  Created by 田磊 on 16/4/25.
//  Copyright © 2016年 田磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

//color转为Image
- (UIImage *)convertToImage;

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithUIColor:(UIColor *)color alpha:(CGFloat)alpha;

@end
