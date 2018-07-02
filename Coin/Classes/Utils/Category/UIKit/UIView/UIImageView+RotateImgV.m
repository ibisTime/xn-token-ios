//
//  UIImageView+RotateImgV.m
//  RotateImgV
//
//  Created by Ashen on 15/11/10.
//  Copyright © 2015年 Ashen. All rights reserved.
//

#import "UIImageView+RotateImgV.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImageView (RotateImgV)

- (void)rotate360DegreeWithImageView {
    CABasicAnimation * ca = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    ca.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    ca.duration = 2;
    ca.cumulative = NO;
    ca.repeatCount = 1;
    [self.layer addAnimation:ca forKey:@"rotationAnimation"];
}
- (void)stopRotate {
    [self.layer removeAllAnimations];
}
@end
