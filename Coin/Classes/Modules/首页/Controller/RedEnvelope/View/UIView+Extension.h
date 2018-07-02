//
//  UIView+Extension.h
//  YYFocus
//
//  Created by anjun on 15/7/7.
//  Copyright (c) 2015年 anjun. All rights reserved.
//

#import <UIKit/UIKit.h>


CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat xv;
@property (nonatomic, assign) CGFloat yv;
@property (nonatomic, assign) CGFloat centerXv;
@property (nonatomic, assign) CGFloat centerYv;
@property (nonatomic, assign) CGFloat widthv;
@property (nonatomic, assign) CGFloat heightv;

@property (nonatomic, assign) CGSize sizev;
@property (nonatomic, assign) CGPoint originv;

@property (nonatomic, assign) CGFloat topv;
@property (nonatomic, assign) CGFloat leftv;
@property (nonatomic, assign) CGFloat bottomv;
@property (nonatomic, assign) CGFloat rightv;

@property (readonly) CGPoint bottomLeftv;
@property (readonly) CGPoint bottomRightv;
@property (readonly) CGPoint topRightv;


-(UIViewController *)viewController;

@end
