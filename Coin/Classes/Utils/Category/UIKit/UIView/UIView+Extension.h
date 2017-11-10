//
//  UIView+Extension.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

//制作半圆
- (CALayer *)getLayerWithDirection:(NSString *)direction size:(CGSize)size;

//画一条线
- (void)drawDashLine:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

//给整个视图画虚线
- (void)drawAroundLine:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;


- (UIView*)subViewOfClassName:(NSString*)className;

@end
