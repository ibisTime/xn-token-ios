//
//  UIBarButtonItem+convience.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "UIBarButtonItem+convience.h"
#import "CoinHeader.h"

@implementation UIBarButtonItem (convience)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *customView = [[UIView alloc] initWithFrame:button.bounds];
    
    [customView addSubview:button];
    
    return [[self alloc] initWithCustomView:customView];
}

+ (void)addRightItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor frame:(CGRect)frame vc:(UIViewController *)vc action:(SEL)action;
{
    
    [self addItemWithDirection:@"右边" title:title titleColor:titleColor imageName:nil frame:frame vc:vc action:action];
}

+ (instancetype)addRightItemWithTitle:(NSString *)title selectTitle:(NSString*)selectTitle target:(id)target action:(SEL)action {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.titleLabel.font = Font(15.0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:selectTitle forState:UIControlStateSelected];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *customView = [[UIView alloc] initWithFrame:btn.bounds];
    
    [customView addSubview:btn];
    
    return [[self alloc] initWithCustomView:customView];
    
}

+ (void)addRightItemWithImageName:(NSString *)imageName frame:(CGRect)frame vc:(UIViewController *)vc action:(SEL)action {
    
    [self addItemWithDirection:@"右边" title:nil titleColor:nil imageName:imageName frame:frame vc:vc action:action];
}

+ (void)addItemWithDirection:(NSString *)direction title:(NSString *)title titleColor:(UIColor *)titleColor imageName:(NSString *)imageName frame:(CGRect)frame vc:(UIViewController *)vc action:(SEL)action {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (title) {
        btn.titleLabel.font = Font(16.0);
        [btn setTitle:title forState:UIControlStateNormal];
        
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    btn.frame = frame;
    
    if (imageName) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    [btn addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *customView = [[UIView alloc] initWithFrame:btn.bounds];
    
    [customView addSubview:btn];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:customView];
    if ([direction isEqualToString:@"左边"]) {
        
        vc.navigationItem.leftBarButtonItem = item;
        
    }else if ([direction isEqualToString:@"右边"]) {
        
        vc.navigationItem.rightBarButtonItem = item;
    }
    
}

+ (void)addLeftItemWithImageName:(NSString *)imageName frame:(CGRect)frame vc:(UIViewController *)vc action:(SEL)action {
    
    [self addItemWithDirection:@"左边" title:nil titleColor:nil imageName:imageName frame:frame vc:vc action:action];
}

+ (void)addRightItemWithView:(UIView*)view vc:(UIViewController *)vc{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    vc.navigationItem.rightBarButtonItem = item;
}

+ (void)addRightItemArray:(NSArray *)btnArray vc:(UIViewController *)vc {
    
    NSMutableArray *itemArray = [NSMutableArray array];
    
    for (UIButton *btn in btnArray) {
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        [itemArray addObject:item];
        
    }
    
    vc.navigationItem.rightBarButtonItems = itemArray;
}

@end
