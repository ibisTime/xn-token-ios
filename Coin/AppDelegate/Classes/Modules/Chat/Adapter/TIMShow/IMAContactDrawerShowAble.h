//
//  IMAContactDrawerShowAble.h
//  TIMAdapter
//
//  Created by AlexiChen on 16/2/18.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAShowAble.h"

@protocol IMAContactDrawerShowAble <IMAShowAble>

@property (nonatomic, assign) BOOL isFold;          // 是否展开

@property (nonatomic, assign) BOOL isPicked;        // 好友选择的时候使用

// 分组实际人数
- (NSInteger)itemsCount;

// 分组人员列表，人数与itemsCount可能不一致
- (NSArray *)items;


@end
