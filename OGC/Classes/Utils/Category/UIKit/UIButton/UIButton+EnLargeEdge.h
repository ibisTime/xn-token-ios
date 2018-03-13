//
//  UIButton+EnLargeEdge.h
//  EnLargeEdge
//
//  Created by 蔡卓越 on 16/3/8.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIButton* (^EdgeBlock) (CGFloat size);

@interface UIButton (EnLargeEdge)

- (EdgeBlock)topEdge;

- (EdgeBlock)leftEdge;

- (EdgeBlock)bottomEdge;

- (EdgeBlock)rightEdge;

- (void)setEnlargeEdge:(CGFloat) size;

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
//图片在左，文字在右
- (void)setTitleRight;
//图片在右，文字在左
- (void)setTitleLeft;
//设置button的label宽度
- (CGSize)boundingRectWithText:(NSString*)text Font:(UIFont*)font size:(CGSize)size;

@end
