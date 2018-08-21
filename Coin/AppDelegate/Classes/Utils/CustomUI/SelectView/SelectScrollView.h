//
//  SelectScrollView.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/24.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortBar.h"

typedef void(^SelectBlock)(NSInteger index);

@interface SelectScrollView : UIView

@property (nonatomic, strong) SortBar *headView;

@property (nonatomic, strong) UIScrollView *scrollView;
//当前索引
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) SelectBlock selectBlock;

- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray *)itemTitles;

@end
