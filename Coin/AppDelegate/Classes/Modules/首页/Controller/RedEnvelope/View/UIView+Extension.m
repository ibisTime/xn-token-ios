//
//  UIView+Extension.m
//  YYFocus
//
//  Created by anjun on 15/7/7.
//  Copyright (c) 2015年 anjun. All rights reserved.
//

#import "UIView+Extension.h"

CGPoint CGRectGetCenter(CGRect rect)
{
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center)
{
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x-CGRectGetMidX(rect);
    newrect.origin.y = center.y-CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

@implementation UIView (Extension)

- (void)setXv:(CGFloat)xv
{
    CGRect frame = self.frame;
    frame.origin.x = xv;
    self.frame = frame;
}

- (CGFloat)xv
{
    return self.frame.origin.x;
}

- (void)setYv:(CGFloat)yv
{
    CGRect frame = self.frame;
    frame.origin.y = yv;
    self.frame = frame;
}

- (CGFloat)yv
{
    return self.frame.origin.y;
}

- (void)setCenterXv:(CGFloat)centerXv
{
    CGPoint center = self.center;
    center.x = centerXv;
    self.center = center;
}

- (CGFloat)centerXv
{
    return self.center.x;
}

- (void)setCenterYv:(CGFloat)centerYv
{
    CGPoint center = self.center;
    center.y = centerYv;
    self.center = center;
}

- (CGFloat)centerYv
{
    return self.center.y;
}

- (void)setWidthv:(CGFloat)widthv
{
    CGRect frame = self.frame;
    frame.size.width = widthv;
    self.frame = frame;
}

- (CGFloat)widthv
{
    return self.frame.size.width;
}

- (void)setHeightv:(CGFloat)heightv
{
    CGRect frame = self.frame;
    frame.size.height = heightv;
    self.frame = frame;
}

- (CGFloat)heightv
{
    return self.frame.size.height;
}

- (void)setSizev:(CGSize)sizev
{
    CGRect frame = self.frame;
    frame.size = sizev;
    self.frame = frame;
}

- (CGSize)sizev
{
    return self.frame.size;
}

- (CGPoint) originv
{
    return self.frame.origin;
}

- (void) setOriginv: (CGPoint) aPointv
{
    CGRect newframe = self.frame;
    newframe.origin = aPointv;
    self.frame = newframe;
}

- (CGFloat) topv
{
    return self.frame.origin.y;
}

- (void) setTopv: (CGFloat) newtopv
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtopv;
    self.frame = newframe;
}

- (CGFloat) leftv
{
    return self.frame.origin.x;
}

- (void) setLeftv: (CGFloat) newleftv
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleftv;
    self.frame = newframe;
}

- (CGFloat) bottomv
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottomv: (CGFloat) newbottomv
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottomv - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat) rightv
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setRightv: (CGFloat) newrightv
{
    CGFloat delta = newrightv - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

- (CGPoint) bottomRightv
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) bottomLeftv
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) topRightv
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

-(UIViewController *)viewController
{
    //下一个响应者
    UIResponder *next=[self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next=[next nextResponder];
    } while (next!=nil);
    
    return nil;
}

@end
