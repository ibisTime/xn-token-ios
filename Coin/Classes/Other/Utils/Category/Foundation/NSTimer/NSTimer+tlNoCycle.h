//
//  NSTimer+tlNoCycle.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (tlNoCycle)

+ (NSTimer *)tl_scheduledTimerWithTimeInterval:(NSTimeInterval)inerval
                                        repeats:(BOOL)repeats
                                          block:(void(^)(NSTimer *timer))block;

@end
