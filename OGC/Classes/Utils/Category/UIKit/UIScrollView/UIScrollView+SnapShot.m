//
//  UIScrollView+SnapShot.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/15.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "UIScrollView+SnapShot.h"

@implementation UIScrollView (SnapShot)


- (UIImage *)snapshotViewWithCapInsets:(UIEdgeInsets)capInsets {
    
    return [self snapshotViewFromRect:CGRectZero withCapInsets:capInsets];
}

- (UIImage *)snapshotViewFromRect:(CGRect)rect withCapInsets:(UIEdgeInsets)capInsets {
    
    CGRect frame = self.frame;
    //修改滚动视图的frame
    CGRect contentFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y,self.contentSize.width, self.contentSize.height);
    
    self.frame = contentFrame;
    
    UIGraphicsBeginImageContextWithOptions(self.contentSize, NO, [UIScreen mainScreen].scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    CGContextTranslateCTM(currentContext, - CGRectGetMinX(rect), - CGRectGetMinY(rect));
    [self.layer renderInContext:currentContext];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext(); UIGraphicsEndImageContext();
    UIImageView *snapshotView = [[UIImageView alloc] initWithFrame:rect];
    snapshotView.image = [snapshotImage resizableImageWithCapInsets:capInsets];
    
    //画好后还原frame
    self.frame = frame;
    
    return snapshotView.image;
}

@end
