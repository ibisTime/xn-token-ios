//
//  UIView+Extension.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
- (CALayer *)getLayerWithDirection:(NSString *)direction size:(CGSize)size {
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    if ([direction isEqualToString:@"left"]) {
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:size];
        
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        
    } else if ([direction isEqualToString:@"right"]) {
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:size];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
    }
    
    return maskLayer;
    
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawDashLine:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0)];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[lineColor CGColor]];
    
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength],
      [NSNumber numberWithInt:lineSpacing],nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, 0,CGRectGetHeight(self.frame));
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [[self layer] addSublayer:shapeLayer];
    
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawAroundLine:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0)];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[lineColor CGColor]];
    
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength],
      [NSNumber numberWithInt:lineSpacing],nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, 0,CGRectGetHeight(self.frame));
    
    CGPathMoveToPoint(path, NULL, 0,CGRectGetHeight(self.frame));
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame),CGRectGetHeight(self.frame));
    
    CGPathMoveToPoint(path, NULL, CGRectGetWidth(self.frame),CGRectGetHeight(self.frame));
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame),0);
    
    CGPathMoveToPoint(path, NULL, CGRectGetWidth(self.frame),0);
    CGPathAddLineToPoint(path, NULL, 0,0);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [[self layer] addSublayer:shapeLayer];
    
}

- (UIView*)subViewOfClassName:(NSString*)className {
    
    for (UIView* subView in self.subviews) {
        
        if ([NSStringFromClass(subView.class) isEqualToString:className]) {
            
            return subView;
        }
        
        UIView* resultFound = [subView subViewOfClassName:className];
        
        if (resultFound) {
            
            return resultFound;
        }
    }
    return nil;
}
@end
