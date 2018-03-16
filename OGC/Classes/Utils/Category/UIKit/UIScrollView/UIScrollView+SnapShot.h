//
//  UIScrollView+SnapShot.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/15.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 截长图
 */
@interface UIScrollView (SnapShot)

/**
 @param capInsets 内置距离
 @return image
 */
- (UIImage *)snapshotViewWithCapInsets:(UIEdgeInsets)capInsets;

@end
