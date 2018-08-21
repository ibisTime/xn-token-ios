
//
//  UIButton+EnLargeEdge.m
//  EnLargeEdge
//
//  Created by 蔡卓越 on 16/3/8.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "UIButton+EnLargeEdge.h"
#import <objc/runtime.h>
#import <CDCommon/UIView+Frame.h>

@implementation UIButton (EnLargeEdge)

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (EdgeBlock)topEdge {
    
    return ^(CGFloat topSize) {
        objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:topSize], OBJC_ASSOCIATION_COPY_NONATOMIC);
        return self;
    };
}

- (EdgeBlock)leftEdge {
    
    return ^(CGFloat leftSize) {
        objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:leftSize], OBJC_ASSOCIATION_COPY_NONATOMIC);
        return self;
    };
}

- (EdgeBlock)bottomEdge {
    
    return ^(CGFloat bottomSize) {
        objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottomSize], OBJC_ASSOCIATION_COPY_NONATOMIC);
        return self;
    };
}

- (EdgeBlock)rightEdge {
    
    return ^(CGFloat rightSize) {
        objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:rightSize], OBJC_ASSOCIATION_COPY_NONATOMIC);
        return self;
    };
}

- (void)setEnlargeEdge:(CGFloat)size {
    
    [self setEnlargeEdgeWithTop:size right:size bottom:size left:size];
}

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left {
    
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect {
    
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    
    CGFloat leftNum = leftEdge ? leftEdge.floatValue : 0;
    CGFloat rightNum = rightEdge ? rightEdge.floatValue : 0;
    CGFloat topNum = topEdge ? topEdge.floatValue : 0;
    CGFloat bottomNum = bottomEdge ? bottomEdge.floatValue : 0;
    
    CGFloat x = self.bounds.origin.x - leftNum;
    CGFloat y = self.bounds.origin.y - topNum;
    CGFloat width = self.bounds.size.width + leftNum + rightNum;
    CGFloat height = self.bounds.size.height + topNum + bottomNum;
    
    return CGRectMake(x, y, width, height);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? YES : NO;
    
//        CGRect bounds = self.bounds;
//        //若原热区小于44x44，则放大热区，否则保持原大小不变
//        CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
//        CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
//        bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
//        return CGRectContainsPoint(bounds, point);
    
}

- (void)setTitleLeft {
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.frame.size.width - self.frame.size.width + self.titleLabel.intrinsicContentSize.width, 0, 0)];
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -self.titleLabel.frame.size.width - self.frame.size.width + self.imageView.frame.size.width)];
    
}

- (void)setTitleRight {
    
    CGFloat width = (self.frame.size.width - self.imageView.width - self.titleLabel.width)/2.0;
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, width, 0, 0)];
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0,
                                              width - self.imageView.width, 0, 0)];
}

- (void)setTitleBottom {
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.frame.size.width, -self.imageView.frame.size.height - 20, 0)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height, 0, 0, -self.titleLabel.intrinsicContentSize.width)];
}

- (CGSize)boundingRectWithText:(NSString*)text Font:(UIFont*)font size:(CGSize)size {
    
    CGSize _size;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine |
    
    NSStringDrawingUsesLineFragmentOrigin |
    
    NSStringDrawingUsesFontLeading;
    
    _size = [text boundingRectWithSize:size options: options attributes:attribute context:nil].size;
    
#else
    
    _size = [text sizeWithFont:font constrainedToSize:size];
    
#endif
    
    return _size;
    
}
@end
