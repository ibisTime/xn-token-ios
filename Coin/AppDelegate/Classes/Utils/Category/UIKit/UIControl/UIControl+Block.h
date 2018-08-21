//
//  UIControl+Block.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Block)

- (void)bk_addEventHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;

@end
