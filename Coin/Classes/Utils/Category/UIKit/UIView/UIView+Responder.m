//
//  UIView+Responder.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "UIView+Responder.h"

@implementation UIView (Responder)

- (UIViewController *)viewController
{
    UIResponder *responser = [self nextResponder];
    do {
        if ([responser isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responser;
        }
        responser = [responser nextResponder];
    } while (responser != nil);
    return nil;
}

@end
