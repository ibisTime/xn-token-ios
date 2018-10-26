//
//  CustomRefreshGifHeader.h
//  RedScarf
//
//  Created by CPZX008 on 16/11/23.
//  Copyright © 2016年 xboker. All rights reserved.
//

#import "MJRefreshGifHeader.h"

@interface CustomRefreshGifHeader : MJRefreshGifHeader

/** 设置state状态下的动画图片images 动画持续时间duration*/
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state;
- (void)setImages:(NSArray *)images forState:(MJRefreshState)state;

@end
