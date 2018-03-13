//
//  SortOrderBar.h
//  BS
//
//  Created by 蔡卓越 on 16/4/21.
//  Copyright © 2016年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SortSelectBlock) (NSInteger index);

@interface SortBar : UIScrollView

@property (nonatomic, assign) NSInteger curruntIndex;

/**
 * 数组元素个数必须和初始化数组元素个数相同
 */
- (void)changeSortBarWithNames:(NSArray*)sortNames;

/**
 * 重新移除原来的按钮,创建新的按钮
 * @sortNames 选项的标题
 * @index     选中第几项,默认为0
 */
- (void)resetSortBarWithNames:(NSArray*)sortNames selectIndex:(NSInteger)index;


- (void)selectSortBarWithIndex:(NSInteger)index;

- (instancetype)initWithFrame:(CGRect)frame sortNames:(NSArray*)sortNames sortBlock:(SortSelectBlock)sortBlock;



@end
