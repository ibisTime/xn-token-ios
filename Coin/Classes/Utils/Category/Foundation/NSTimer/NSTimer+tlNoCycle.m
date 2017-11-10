//
//  NSTimer+tlNoCycle.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NSTimer+tlNoCycle.h"

@implementation NSTimer (tlNoCycle)

+ (NSTimer *)tl_scheduledTimerWithTimeInterval:(NSTimeInterval)inerval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block{
    
    return [NSTimer scheduledTimerWithTimeInterval:inerval target:self selector:@selector(tl_blcokInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)tl_blcokInvoke:(NSTimer *)timer {
    
    void (^block)(NSTimer *timer) = timer.userInfo;
    
    if (block) {
        block(timer);
    }
}

@end
